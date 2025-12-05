# TDD-022: ChatWebSocketClient

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-022 |
| **Jira Key** | FOOTBALL-9183 |
| **標題** | 實作 ChatWebSocketClient（WebSocket） |
| **類型** | Client |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-011 |
| **Story Point** | 13 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：5 天<br/>最嚴厲：3 天 |
| **開發日期 / Development Date** | 2025-12-03 (週三)

## 描述 / Description

實作 ChatWebSocketClient（WebSocket）。 / Implement ChatWebSocketClient(WebSocket)。

## 需求 / Requirements

1. 實作 `ChatWebSocketClient`（使用 WebSocket 框架） / Implement `ChatWebSocketClient` (using WebSocket framework)
2. 實作連線管理（重連、心跳等） / Implement connection management (reconnect, heartbeat, etc.)
3. 實作訂閱 / 取消訂閱 / Implement subscribe / unsubscribe
4. 實作訊息接收與發送 / Implement message receive and send
5. 實作指數退避重連策略 / Implement exponential backoff reconnect strategy
6. 檔案結構：`Sources/LiveChat/Services/API/ChatWebSocketClient.swift` / File structure: `Sources/LiveChat/Services/API/ChatWebSocketClient.swift`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
MatchChat/Sources/MatchChat/Services/API/
  └── ChatWebSocketClient.swift
```

**注意**: 實際路徑與 TDD 不同是因為 MatchChat 是統一 package，但檔案位置在正確的層級（Services/API/）。

### 參考實作 / Reference Implementations

#### 1. WebSocketStompManager.swift

**位置**: `TDDs/LiveChat&PrematchComment/Input/LiveChat&PrematchComment/CodeRef/WebSocketStompManager.swift`

**特點**:
- 使用 `SportyStomp` 框架
- 使用 `SwiftStompDelegate` 處理連線事件
- 使用 callback (`MessageHandler`) 處理訊息
- 在 `init` 中建立連線並啟用心跳 (`enableAutoPing()`)
- 訂閱 topic: `/topic/user.{userId}`

**關鍵實作**:
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
}
```

#### 2. EventDetail.WebSocketFeature

**位置**: `FCom/Home Tab/EventDetail/EventDetail/Feature/EventDetail+Feature+WebSocket.swift`

**特點**:
- 使用 TCA Reducer 模式
- 使用 `AsyncStream` 提供訊息流
- 使用 `.run { send in ... }` 處理 AsyncStream
- 使用 `cancellable(id:)` 管理訂閱生命週期

#### 3. EventOddsWebSocketManager

**位置**: `FCom/Home Tab/EventDetail/EventDetail/Service/EventOddsWebSocketManager.swift`

**特點**:
- 使用 `class` + `NSLock` 保護共享狀態
- 支援多訂閱者（使用 UUID 追蹤）
- 使用 `AsyncStream` 提供訊息流
- 廣播機制：將訊息廣播給所有訂閱者

### 設計決策 / Design Decisions

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
- 更容易與 TCA 整合
- 支援多訂閱者模式
- 更好的生命週期管理

#### 3. 框架選擇：`SportyStomp`

**決定**: 使用 `SportyStomp`（參考 WebSocketStompManager）

**理由**:
- 專案已有 SportyStomp 框架
- 已實作心跳機制 (`enableAutoPing()`)
- 已實作 STOMP 協議支援
- 有完整的 delegate 機制

### 程式碼範例 / Code Example

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
    private let userId: String
    private let domain: String
    
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
    
    public init(userId: String, domain: String, appVersion: String? = nil, deviceId: String? = nil) {
        self.userId = userId
        self.domain = domain
        var headers: [String: String] = [
            "Platform": "ios",
            "userId": userId
        ]
        
        // 如果提供了 appVersion 和 deviceId，則加入 headers
        // 否則由調用者負責在外部設定這些 headers
        if let appVersion = appVersion {
            headers["App-Version"] = appVersion
        }
        if let deviceId = deviceId {
            headers["Device-Id"] = deviceId
        }
        
        self.webSocketRequestHeaders = headers
    }
    
    // MARK: - Connection Management
    
    public func connect() async throws {
        // 1. 建立 SportyStomp 連線
        // 2. 設定 delegate
        // 3. 啟用心跳 (enableAutoPing())
        // 4. 更新狀態
    }
    
    public func disconnect() async {
        // 1. 取消所有訂閱
        // 2. 斷開連線
        // 3. 清理資源
    }
    
    // MARK: - Subscription Management
    
    /// 訂閱指定聊天室的訊息流
    /// - Parameter chatroomId: 聊天室 ID
    /// - Returns: AsyncStream<ChatAPI.WebSocketMessageDTO> 訊息流
    /// 
    /// **時機**: 加入聊天室時呼叫（參考 Module Sequence Diagram）
    /// **設計**: 使用 nonisolated 允許同步創建 AsyncStream，實際訂閱邏輯在 actor 內執行
    public nonisolated func subscribe(chatroomId: String) -> AsyncStream<ChatAPI.WebSocketMessageDTO> {
        // 1. 同步創建 AsyncStream
        // 2. 在 Task 中執行 actor-isolated 的訂閱邏輯
        // 3. 返回 AsyncStream
    }
    
    public func unsubscribe(chatroomId: String) async {
        // 1. 取消訂閱
        // 2. 如果沒有其他訂閱者，移除訂閱
    }
    
    // MARK: - Message Sending
    
    public func sendMessage(chatroomId: String, text: String) async throws {
        // 發送訊息到指定 chatroom（使用 SportyStomp.send）
    }
    
    // MARK: - Private Methods
    
    private func reconnect() async {
        // 指數退避重連策略
        // 參考: 初始延遲 1 秒，每次重試翻倍，最大延遲 60 秒
    }
    
    private func handleMessageReceived(message: Any?, destination: String) async {
        // 1. 解析 STOMP 訊息（參考 WebSocketStompManager）
        // 2. 轉換為 ChatAPI.WebSocketMessageDTO
        // 3. 廣播給對應的訂閱者
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
    
    nonisolated func onReceipt(swiftStomp: SportyStomp, receiptId: String) {}
    nonisolated func onSocketEvent(eventName: String, description: String) {}
}
```

### 命名規範 / Naming Conventions

- WebSocket Client 使用 `actor`，確保線程安全 / WebSocket Client uses `actor`, ensures thread safety
- 使用 `public` 修飾符 / Use `public` modifier
- 實作連線、斷線、發送、訂閱等方法 / Implement connect, disconnect, send, subscribe methods
- 使用 `AsyncStream` 提供訊息流，而非 callback / Use `AsyncStream` for message flow, not callback
- 使用 `ChatroomSubscription` 管理多訂閱者 / Use `ChatroomSubscription` to manage multiple subscribers
- `subscribe` 方法標記為 `nonisolated` 以允許同步創建 AsyncStream / `subscribe` method marked as `nonisolated` to allow synchronous AsyncStream creation

### 關鍵設計要點 / Key Design Points

#### 1. 連線管理 / Connection Management

- **初始連線**: 在 `connect()` 中建立 SportyStomp 連線
- **自動重連**: 使用指數退避策略（初始 1 秒，每次翻倍，最大 60 秒）
- **心跳機制**: 使用 SportyStomp 的 `enableAutoPing()`
- **狀態管理**: 使用 `ConnectionState` enum 追蹤連線狀態

#### 2. 訂閱管理 / Subscription Management

- **多訂閱者支援**: 參考 EventOddsWebSocketManager，使用 UUID 追蹤訂閱者
- **訂閱生命週期**: 只有當所有訂閱者都取消時才取消訂閱
- **廣播機制**: 將訊息廣播給所有訂閱者
- **Topic 格式**: `/topic/chat_room.{chatroomId}`（參考 ChatAPI.WebSocketEndpoint）

#### 3. 訊息處理 / Message Handling

- **訊息解析**: 參考 WebSocketStompManager，解析 STOMP 訊息格式
- **DTO 轉換**: 將接收到的訊息轉換為 `ChatAPI.WebSocketMessageDTO`
- **錯誤處理**: 處理解析錯誤和連線錯誤

#### 4. 並發安全 / Concurrency Safety

- **Actor 隔離**: 使用 `actor` 確保線程安全
- **Delegate 處理**: 使用 `nonisolated` + `Task` 處理 delegate 回調
- **鎖機制**: 在 `ChatroomSubscription` 中使用 `NSLock` 保護共享狀態

## 驗收條件 / Acceptance Criteria

- [ ] `ChatWebSocketClient` 實作完成，使用 `actor` / `ChatWebSocketClient` implementation complete, using `actor`
- [ ] WebSocket 連線管理實作完成 / WebSocket connection management implementation complete
- [ ] 訂閱 / 取消訂閱實作完成 / Subscribe / unsubscribe implementation complete
- [ ] 訊息接收與發送實作完成 / Message receive and send implementation complete
- [ ] 重連機制實作完成（指數退避） / Reconnect mechanism implementation complete (exponential backoff)
- [ ] 心跳機制實作完成 / Heartbeat mechanism implementation complete
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%
- [ ] Integration Test 通過 / Integration Test Passed

## 架構對齊 / Architecture Alignment

### ✅ Clean Architecture 層級關係

根據 `output/LiveChat&PrematchComment/02_Architecture/01_clean_architecture_diagram.md`：
- **Client Layer** → **API Layer**：`ChatWebSocketClient` 使用 `ChatAPI.WebSocketEndpoint` 和 `ChatAPI.WebSocketMessageDTO`
- **Repository Layer** → **Client Layer**：`LiveChatRepository` 使用 `ChatWebSocketClient`
- **UseCase Layer** → **Repository Layer**：`JoinChatroomUseCase` / `LeaveChatroomUseCase` 使用 `LiveChatRepository`

### ✅ Module Responsibility

根據 `output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`：
- `ChatWebSocketClient` 職責：
  - WebSocket 通訊（即時訊息）
  - 訂閱 / 取消訂閱
  - 訊息接收與發送
  - 連線管理（重連、心跳等）
- 被 `LiveChatRepository` 使用，不被 Feature 直接使用

### ✅ API Spec 對齊

根據 `output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`：
- **WebSocket URL**: `wss://www.encorebet.net/chat/websocket/web-chat`
- **實際實作**：使用 STOMP 協議，需要訂閱 `/topic/chat_room.{chatroomId}`
- **Message DTO**: `ChatAPI.WebSocketMessageDTO`（包含 `type: String` 和 `data: MessageResponseDataDTO`）

### ✅ Module Sequence Diagram 對齊

根據 `output/LiveChat&PrematchComment/05. Module Sequence Diagram（模組序列圖）/LiveChat/Module Sequence Diagrams/01_data_initialization_initialize_chatroom.md`：
- **連線時機**：進入 Live Detail Page 時建立 WebSocket 連線
- **訂閱時機**：加入聊天室時訂閱 `/topic/chat_room.{chatroomId}`
- **取消訂閱時機**：離開 Live Detail Page 時取消訂閱

### ✅ Feature State 對齊

根據 `output/LiveChat&PrematchComment/06_Feature State & Action (TCA)/01_feature_state_action.md`：
- `LiveChatState` 包含 `isWebSocketConnected: Bool` 和 `webSocketError: Error?`
- `LiveChatAction` 包含 WebSocket 相關的 Action（如 `webSocketMessageReceived`）

## 相關文件 / Related Documents

### TDD 架構文件
- **Overview**: `output/LiveChat&PrematchComment/00_Overview/01_overview.md`
- **Architecture**: `output/LiveChat&PrematchComment/02_Architecture/01_clean_architecture_diagram.md`
- **Module Responsibility**: `output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- **Domain Model**: `output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`
- **Module Sequence Diagram**: `output/LiveChat&PrematchComment/05. Module Sequence Diagram（模組序列圖）/LiveChat/Module Sequence Diagrams/01_data_initialization_initialize_chatroom.md`
- **Feature State & Action**: `output/LiveChat&PrematchComment/06_Feature State & Action (TCA)/01_feature_state_action.md`
- **API Spec**: `output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`

### 實際 API 實作
- **ChatAPI.WebSocketEndpoint**: `MatchChat/Sources/MatchChat/Services/API/Chat/ChatAPI+WebSocket.swift`
- **ChatAPI.WebSocketMessageDTO**: `MatchChat/Sources/MatchChat/Services/API/Chat/ChatAPI+Models.swift`

## 參考實作 / Reference Implementations

- **WebSocketStompManager.swift**: `TDDs/LiveChat&PrematchComment/Input/LiveChat&PrematchComment/CodeRef/WebSocketStompManager.swift`
  - SportyStomp 使用範例
  - Delegate pattern 實作
  - 心跳機制實作

- **EventDetail.WebSocketFeature**: `FCom/Home Tab/EventDetail/EventDetail/Feature/EventDetail+Feature+WebSocket.swift`
  - TCA + AsyncStream 模式
  - 訂閱生命週期管理

- **EventOddsWebSocketManager**: `FCom/Home Tab/EventDetail/EventDetail/Service/EventOddsWebSocketManager.swift`
  - 多訂閱者管理策略
  - AsyncStream 廣播機制

## 調整因子說明 / 調整因子說明

- 基礎估時：複雜 Client = 8 SP
- +3 SP：WebSocket
- +2 SP：複雜 Reconnect 邏輯 / - +2 SP：複雜 Reconnect Logic

