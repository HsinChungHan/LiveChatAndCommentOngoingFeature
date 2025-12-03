# ChatWebSocketClient 設計方案

**生成時間**: 2025-12-03

## 📋 參考實作分析

### 1. WebSocketStompManager.swift

**特點**:
- 使用 `SportyStomp` 框架
- 使用 `SwiftStompDelegate` 處理連線事件
- 使用 callback (`MessageHandler`) 處理訊息
- 在 `init` 中建立連線並啟用心跳 (`enableAutoPing()`)
- 訂閱 topic: `/topic/user.{userId}`

**關鍵代碼**:
```swift
class WebSocketStompManager {
    var swiftStomp: SportyStomp
    var messageHandler: MessageHandler?
    
    init(userId: String, messageHandler: @escaping MessageHandler) {
        swiftStomp = SportyStomp(host: webSocketDomain, headers: headers)
        swiftStomp.enableAutoPing()
        swiftStomp.connectWithCustomHeaders()
        swiftStomp.delegate = self
    }
    
    func onMessageReceived(swiftStomp: SportyStomp, message: Any?, ...) {
        // 解析訊息並調用 messageHandler
    }
}
```

### 2. EventDetail.WebSocketFeature

**特點**:
- 使用 TCA Reducer 模式
- 使用 `AsyncStream` 提供訊息流
- 使用 `.run { send in ... }` 處理 AsyncStream
- 使用 `cancellable(id:)` 管理訂閱生命週期
- 支援多個訂閱（event status, market odds, market status）

**關鍵代碼**:
```swift
case .startMarketOddsSubscription(let event):
    return .run(
        operation: { send in
            let marketOddsStream = try await eventDetailRepository.subscribeForAllMarketOddsChange(of: event)
            for await marketMessage in marketOddsStream {
                await send(.marketOddsUpdated(marketMessage))
            }
        }
    )
    .cancellable(id: CancelID.marketOddsSubscription(eventId: state.eventId), cancelInFlight: true)
```

### 3. EventOddsWebSocketManager

**特點**:
- 使用 `class` + `NSLock` 保護共享狀態
- 支援多訂閱者（使用 UUID 追蹤）
- 使用 `AsyncStream` 提供訊息流
- 廣播機制：將訊息廣播給所有訂閱者
- 訂閱管理：追蹤訂閱者數量，只有當所有訂閱者都取消時才取消訂閱

**關鍵代碼**:
```swift
public final class EventOddsWebSocketManager {
    private var activeSubscriptions: [String: EventSubscription] = [:]
    private let subscriptionsLock = NSLock()
    
    private class EventSubscription {
        private var messageContinuations: [UUID: AsyncStream<MarketMessage>.Continuation] = [:]
        private let continuationsLock = NSLock()
        
        func addSubscriber() -> AsyncStream<MarketMessage> {
            let id = UUID()
            let messageStream = AsyncStream<MarketMessage> { continuation in
                continuationsLock.lock()
                defer { continuationsLock.unlock()}
                messageContinuations[id] = continuation
            }
            return messageStream
        }
        
        func broadcastMessage(_ message: MarketMessage) {
            // 廣播給所有訂閱者
        }
    }
}
```

## 🎯 ChatWebSocketClient 設計方案

### 架構對齊檢查

#### ✅ 符合 Clean Architecture 層級關係

根據 `02_Architecture/01_clean_architecture_diagram.md`：
- **Client Layer** → **API Layer**：`ChatWebSocketClient` 使用 `ChatAPI.WebSocketEndpoint` 和 `ChatAPI.WebSocketMessageDTO`
- **Repository Layer** → **Client Layer**：`LiveChatRepository` 使用 `ChatWebSocketClient`
- **UseCase Layer** → **Repository Layer**：`JoinChatroomUseCase` / `LeaveChatroomUseCase` 使用 `LiveChatRepository`

#### ✅ 符合 Module Responsibility

根據 `03_Module Responsibility/01_module_responsibility.md`：
- `ChatWebSocketClient` 職責：
  - WebSocket 通訊（即時訊息）
  - 訂閱 / 取消訂閱
  - 訊息接收與發送
  - 連線管理（重連、心跳等）
- 被 `LiveChatRepository` 使用，不被 Feature 直接使用

#### ✅ 符合 API Spec

根據 `08_API Spec & Mapping/01_api_spec.md`：
- **WebSocket URL**: `wss://www.encorebet.net/chat/websocket/web-chat`
- **實際實作**：使用 STOMP 協議，需要訂閱 `/topic/chat_room.{chatroomId}`
- **Message DTO**: `ChatAPI.WebSocketMessageDTO`（包含 `type` 和 `data: MessageResponseDataDTO`）

#### ✅ 符合 Module Sequence Diagram

根據 `05. Module Sequence Diagram（模組序列圖）/LiveChat/Module Sequence Diagrams/01_data_initialization_initialize_chatroom.md`：
- **連線時機**：進入 Live Detail Page 時建立 WebSocket 連線
- **訂閱時機**：加入聊天室時訂閱 `/topic/chat_room.{chatroomId}`
- **取消訂閱時機**：離開 Live Detail Page 時取消訂閱

#### ✅ 符合 Feature State 設計

根據 `06_Feature State & Action (TCA)/01_feature_state_action.md`：
- `LiveChatState` 包含 `isWebSocketConnected: Bool` 和 `webSocketError: Error?`
- `LiveChatAction` 包含 WebSocket 相關的 Action（如 `webSocketMessageReceived`）

### 設計決策

#### 1. 類型選擇：`actor` vs `class`

**決定**: 使用 `actor`（符合 TDD 規範，確保線程安全）

**理由**:
- TDD 文件要求使用 `actor`
- `actor` 提供內建的線程安全保證
- 符合現代 Swift 並發模式

#### 2. 訊息傳遞：`AsyncStream` vs `callback`

**決定**: 使用 `AsyncStream`（參考 EventDetail 和 EventOddsWebSocketManager）

**理由**:
- 符合現代 Swift 並發模式
- 更容易與 TCA 整合（參考 `EventDetail.WebSocketFeature`）
- 支援多訂閱者模式（參考 `EventOddsWebSocketManager`）
- 更好的生命週期管理

#### 3. 框架選擇：`SportyStomp`

**決定**: 使用 `SportyStomp`（參考 WebSocketStompManager）

**理由**:
- 專案已有 SportyStomp 框架
- 已實作心跳機制 (`enableAutoPing()`)
- 已實作 STOMP 協議支援
- 有完整的 delegate 機制

#### 4. API 層級使用

**決定**: 使用 `ChatAPI.WebSocketEndpoint` 和 `ChatAPI.WebSocketMessageDTO`

**理由**:
- 符合 Clean Architecture：Client 使用 API Layer 定義的 endpoint 和 DTO
- 實際實作中已定義 `ChatAPI.WebSocketEndpoint` 和 `ChatAPI.WebSocketMessageDTO`
- 保持架構一致性

### 架構設計

```swift
import Foundation
import SportyStomp

public actor ChatWebSocketClient {
    // MARK: - Properties
    
    private var swiftStomp: SportyStomp?
    private var connectionState: ConnectionState = .disconnected
    private var subscriptions: [String: ChatroomSubscription] = [:]
    private var reconnectTask: Task<Void, Never>?
    private var reconnectAttempts: Int = 0
    
    // MARK: - Types
    
    public enum ConnectionState: Equatable {
        case disconnected
        case connecting
        case connected
        case reconnecting
        case error(String)
    }
    
    private class ChatroomSubscription {
        let chatroomId: String
        let subscriptionId: String
        private var messageContinuations: [UUID: AsyncStream<ChatAPI.WebSocketMessageDTO>.Continuation] = [:]
        private let continuationsLock = NSLock()
        
        init(chatroomId: String, subscriptionId: String) {
            self.chatroomId = chatroomId
            self.subscriptionId = subscriptionId
        }
        
        func addSubscriber() -> AsyncStream<ChatAPI.WebSocketMessageDTO> {
            let id = UUID()
            let messageStream = AsyncStream<ChatAPI.WebSocketMessageDTO> { continuation in
                continuationsLock.lock()
                defer { continuationsLock.unlock() }
                messageContinuations[id] = continuation
            }
            return messageStream
        }
        
        func removeSubscriber(id: UUID) {
            continuationsLock.lock()
            defer { continuationsLock.unlock() }
            messageContinuations.removeValue(forKey: id)
        }
        
        func broadcastMessage(_ message: ChatAPI.WebSocketMessageDTO) {
            continuationsLock.lock()
            defer { continuationsLock.unlock() }
            
            messageContinuations = messageContinuations.compactMapValues { continuation in
                switch continuation.yield(message) {
                case .enqueued:
                    return continuation
                case .dropped, .terminated:
                    return nil
                @unknown default:
                    return nil
                }
            }
        }
        
        var subscriberCount: Int {
            continuationsLock.lock()
            defer { continuationsLock.unlock() }
            return messageContinuations.count
        }
        
        func finishAllStreams() {
            continuationsLock.lock()
            defer { continuationsLock.unlock() }
            for continuation in messageContinuations.values {
                continuation.finish()
            }
            messageContinuations.removeAll()
        }
    }
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Connection Management
    
    /// 建立 WebSocket 連線
    /// - Parameters:
    ///   - userId: 用戶 ID（用於連線 headers）
    ///   - domain: WebSocket domain（例如 "www.encorebet.net"）
    /// - Throws: 連線錯誤
    /// 
    /// **時機**: 進入 Live Detail Page 時呼叫（參考 Module Sequence Diagram）
    /// **實作**: 使用 `ChatAPI.WebSocketEndpoint.url(for: domain)` 取得 URL
    public func connect(userId: String, domain: String) async throws {
        // 1. 使用 ChatAPI.WebSocketEndpoint.url(for: domain) 取得 URL
        // 2. 建立 SportyStomp 連線（設定 headers，包含 userId）
        // 3. 設定 delegate
        // 4. 啟用心跳 (enableAutoPing())
        // 5. 連線 (connectWithCustomHeaders())
        // 6. 更新 connectionState
    }
    
    /// 斷開 WebSocket 連線
    /// 
    /// **時機**: 離開 Live Detail Page 時呼叫（參考 Module Sequence Diagram）
    public func disconnect() async {
        // 1. 取消所有訂閱（finishAllStreams）
        // 2. 取消重連任務
        // 3. 斷開連線 (disconnect())
        // 4. 清理資源
        // 5. 更新 connectionState
    }
    
    // MARK: - Subscription Management
    
    /// 訂閱指定聊天室的訊息
    /// - Parameter chatroomId: 聊天室 ID
    /// - Returns: AsyncStream<ChatAPI.WebSocketMessageDTO> 訊息流
    /// 
    /// **時機**: 加入聊天室時呼叫（參考 Module Sequence Diagram）
    /// **實作**: 使用 `ChatAPI.WebSocketEndpoint.subscribeDestination(chatroomId:)` 取得 topic
    /// **STOMP 訂閱**: 使用 `SportyStomp.subscribe(to:destination, id:subscriptionId)`
    public func subscribe(chatroomId: String) -> AsyncStream<ChatAPI.WebSocketMessageDTO> {
        // 1. 檢查是否已訂閱該 chatroomId
        // 2. 如果未訂閱：
        //    - 建立 ChatroomSubscription
        //    - 使用 ChatAPI.WebSocketEndpoint.subscribeDestination(chatroomId:) 取得 topic
        //    - 使用 SportyStomp.subscribe(to:topic, id:subscriptionId)
        // 3. 返回 AsyncStream（支援多訂閱者）
    }
    
    /// 取消訂閱指定聊天室
    /// - Parameter chatroomId: 聊天室 ID
    /// 
    /// **時機**: 離開聊天室或離開頁面時呼叫
    /// **實作**: 只有當所有訂閱者都取消時才取消 STOMP 訂閱
    public func unsubscribe(chatroomId: String) async {
        // 1. 移除訂閱者（removeSubscriber）
        // 2. 如果沒有其他訂閱者：
        //    - 取消 STOMP 訂閱 (unsubscribe(id:subscriptionId))
        //    - 移除 ChatroomSubscription
    }
    
    // MARK: - Message Sending
    
    /// 發送訊息到指定聊天室
    /// - Parameters:
    ///   - chatroomId: 聊天室 ID
    ///   - text: 訊息內容
    /// - Throws: 發送錯誤
    /// 
    /// **注意**: 訊息發送應透過 HTTP API（`LiveChatClient.sendMessage`），
    /// WebSocket 主要用於接收即時訊息。此方法為可選功能。
    public func sendMessage(chatroomId: String, text: String) async throws {
        // 使用 STOMP SEND 指令發送訊息（如果需要）
        // 注意：根據 API Spec，訊息發送主要透過 HTTP API
    }
    
    // MARK: - Private Methods
    
    private func reconnect() async {
        // 指數退避重連策略
    }
    
    private func startHeartbeat() {
        // 心跳機制（由 SportyStomp 的 enableAutoPing() 處理）
    }
}

// MARK: - SwiftStompDelegate

extension ChatWebSocketClient: SwiftStompDelegate {
    nonisolated func onConnect(swiftStomp: SportyStomp, connectType: StompConnectType) {
        Task { @MainActor in
            await handleConnect(connectType: connectType)
        }
    }
    
    nonisolated func onDisconnect(swiftStomp: SportyStomp, disconnectType: StompDisconnectType) {
        Task { @MainActor in
            await handleDisconnect(disconnectType: disconnectType)
        }
    }
    
    nonisolated func onMessageReceived(swiftStomp: SportyStomp, message: Any?, messageId: String, destination: String, headers: [String: String]) {
        Task { @MainActor in
            await handleMessageReceived(message: message, destination: destination)
        }
    }
    
    nonisolated func onError(swiftStomp: SportyStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        Task { @MainActor in
            await handleError(briefDescription: briefDescription, type: type)
        }
    }
    
    // 其他 delegate 方法...
}
```

## 🔑 關鍵設計要點

### 1. 連線管理

- **初始連線**: 在 `connect()` 中建立 SportyStomp 連線
- **自動重連**: 使用指數退避策略
- **心跳機制**: 使用 SportyStomp 的 `enableAutoPing()`
- **狀態管理**: 使用 `ConnectionState` enum 追蹤連線狀態

### 2. 訂閱管理

- **多訂閱者支援**: 參考 EventOddsWebSocketManager，使用 UUID 追蹤訂閱者
- **訂閱生命週期**: 只有當所有訂閱者都取消時才取消訂閱
- **廣播機制**: 將訊息廣播給所有訂閱者
- **STOMP Topic**: 使用 `ChatAPI.WebSocketEndpoint.subscribeDestination(chatroomId:)` 取得 `/topic/chat_room.{chatroomId}`
- **訂閱時機**: 加入聊天室時訂閱（參考 Module Sequence Diagram）

### 3. 訊息處理

- **訊息解析**: 參考 WebSocketStompManager，解析 STOMP 訊息格式
- **DTO 結構**: 使用 `ChatAPI.WebSocketMessageDTO`（包含 `type: String` 和 `data: MessageResponseDataDTO`）
- **訊息路由**: 根據 `destination` header 判斷訊息屬於哪個 chatroom，並廣播給對應的訂閱者
- **錯誤處理**: 處理解析錯誤和連線錯誤
- **Mapping**: DTO → Domain Model 的轉換在 `LiveChatRepository` 層完成（符合 Clean Architecture）

### 4. 並發安全

- **Actor 隔離**: 使用 `actor` 確保線程安全
- **Delegate 處理**: 使用 `nonisolated` + `Task` 處理 delegate 回調
- **鎖機制**: 在 `ChatroomSubscription` 中使用 `NSLock` 保護共享狀態

## 📝 實作步驟

1. **建立基本結構**
   - 定義 `ChatWebSocketClient` actor
   - 定義 `ConnectionState` enum
   - 定義 `ChatroomSubscription` class

2. **實作連線管理**
   - 實作 `connect()` 方法
   - 實作 `disconnect()` 方法
   - 實作 `SwiftStompDelegate` 方法

3. **實作訂閱管理**
   - 實作 `subscribe()` 方法
   - 實作 `unsubscribe()` 方法
   - 實作廣播機制

4. **實作訊息發送**
   - 實作 `sendMessage()` 方法

5. **實作重連機制**
   - 實作指數退避重連策略

6. **測試與驗證**
   - 單元測試
   - 整合測試

## 🔗 相關文件

### TDD 架構文件
- [00_Overview: 功能概述](../../../output/LiveChat&PrematchComment/00_Overview/01_overview.md)
- [02_Architecture: Clean Architecture 架構圖](../../../output/LiveChat&PrematchComment/02_Architecture/01_clean_architecture_diagram.md)
- [03_Module Responsibility: 模組職責](../../../output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md)
- [04_Domain Model: Domain Model 定義](../../../output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md)
- [05_Module Sequence Diagram: 模組序列圖](../../../output/LiveChat&PrematchComment/05. Module Sequence Diagram（模組序列圖）/LiveChat/Module Sequence Diagrams/01_data_initialization_initialize_chatroom.md)
- [06_Feature State & Action: TCA State/Action](../../../output/LiveChat&PrematchComment/06_Feature State & Action (TCA)/01_feature_state_action.md)
- [08_API Spec & Mapping: API 規格](../../../output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md)

### TDD Ticket
- [TDD-022: ChatWebSocketClient](../../12_Tickets/03_client/TDD-022_ChatWebSocketClient.md)

### 參考實作
- [WebSocketStompManager 參考實作](../../../Input/LiveChat&PrematchComment/CodeRef/WebSocketStompManager.swift)
- [EventDetail.WebSocketFeature](../../../../FCom/Home Tab/EventDetail/EventDetail/Feature/EventDetail+Feature+WebSocket.swift)
- [EventOddsWebSocketManager](../../../../FCom/Home Tab/EventDetail/EventDetail/Service/EventOddsWebSocketManager.swift)

### 實際 API 實作
- [ChatAPI.WebSocketEndpoint](../../../../MatchChat/Sources/MatchChat/Services/API/Chat/ChatAPI+WebSocket.swift)
- [ChatAPI.WebSocketMessageDTO](../../../../MatchChat/Sources/MatchChat/Services/API/Chat/ChatAPI+Models.swift)

