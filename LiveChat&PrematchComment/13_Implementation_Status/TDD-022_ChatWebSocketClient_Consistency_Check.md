# TDD-022 ChatWebSocketClient 一致性檢查報告

**檢查日期**: 2025-12-03  
**Ticket**: TDD-022 (FOOTBALL-9183)  
**實作檔案**: `MatchChat/Sources/MatchChat/Services/API/ChatWebSocketClient.swift`

---

## ✅ 符合項目 / Compliant Items

### 1. 檔案結構 / File Structure
- ✅ **路徑**: `MatchChat/Sources/MatchChat/Services/API/ChatWebSocketClient.swift`
- ✅ **說明**: 實際路徑與 TDD 不同是因為 MatchChat 是統一 package，但檔案位置在正確的層級（Services/API/）

### 2. 類型定義 / Type Definition
- ✅ **使用 `actor`**: `public actor ChatWebSocketClient` 符合 TDD 要求
- ✅ **ConnectionState enum**: 包含所有必要的狀態（disconnected, connecting, connected, reconnecting, error）
- ✅ **ChatroomSubscription class**: 實作多訂閱者管理，使用 NSLock 保護共享狀態

### 3. 初始化 / Initialization
- ✅ **參數**: `init(userId:domain:appVersion:deviceId:)` 符合 TDD 規範
- ✅ **Headers 設定**: 正確設定 Platform, userId, App-Version, Device-Id

### 4. 連線管理 / Connection Management
- ✅ **`connect()` 方法**: 實作完成，使用 SportyStomp，啟用心跳
- ✅ **`disconnect()` 方法**: 實作完成，清理所有訂閱和資源
- ✅ **心跳機制**: 使用 `enableAutoPing()` ✅
- ✅ **狀態管理**: 使用 `ConnectionState` enum 追蹤連線狀態 ✅

### 5. 訂閱管理 / Subscription Management
- ✅ **`subscribe(chatroomId:)` 方法**: 實作完成，返回 `AsyncStream<ChatAPI.WebSocketMessageDTO>`
- ✅ **多訂閱者支援**: 使用 UUID 追蹤訂閱者，符合 TDD 要求
- ✅ **廣播機制**: `ChatroomSubscription.broadcastMessage()` 實作完成
- ✅ **Topic 格式**: 使用 `/topic/chat_room.{chatroomId}` 符合 API Spec
- ✅ **x-queue-name header**: 正確設定

### 6. 訊息處理 / Message Handling
- ✅ **訊息接收**: `handleMessageReceived()` 實作完成
- ✅ **DTO 轉換**: 嘗試解析為 `ChatAPI.WebSocketMessageDTO`
- ✅ **錯誤處理**: 包含 fallback 解析邏輯（參考 WebSocketStompManager）
- ✅ **訊息發送**: `sendMessage(chatroomId:text:)` 實作完成

### 7. 重連機制 / Reconnect Mechanism
- ✅ **指數退避策略**: 實作完成（初始 1 秒，每次翻倍，最大 60 秒）
- ✅ **重連觸發**: 在 `handleDisconnect()` 和 `handleError()` 中正確觸發

### 8. Delegate 實作 / Delegate Implementation
- ✅ **SwiftStompDelegate**: 所有必要方法都已實作
- ✅ **nonisolated 方法**: 正確使用 `nonisolated` + `Task` 處理 delegate 回調
- ✅ **Sendable conformance**: 為 StompConnectType, StompDisconnectType, StompErrorType 添加了 `@unchecked @retroactive Sendable`

### 9. 命名規範 / Naming Conventions
- ✅ **public 修飾符**: 所有公開方法都使用 `public`
- ✅ **方法命名**: 符合 Swift 命名規範
- ✅ **MARK 註解**: 正確使用 MARK 組織代碼

### 10. 依賴關係 / Dependencies
- ✅ **SportyStomp**: 已添加到 Package.swift
- ✅ **ChatAPI.WebSocketEndpoint**: 正確使用
- ✅ **ChatAPI.WebSocketMessageDTO**: 正確使用

---

## ⚠️ 需要注意的問題 / Issues to Address

### 1. 方法簽名差異 / Method Signature Differences

#### `unsubscribe()` 方法
- **TDD 要求**: `unsubscribe(chatroomId: String) async`
- **實際實作**: `unsubscribe(subscriberId: UUID) async` 和 `unsubscribeAll(chatroomId: String) async`
- **評估**: ✅ **實際實作更合理**
  - 支援多訂閱者模式，需要通過 `subscriberId` 來取消特定訂閱
  - 提供了 `unsubscribeAll()` 作為補充，可以取消整個 chatroom 的所有訂閱
  - **建議**: 在 TDD 文件中更新此方法簽名，或添加說明

### 2. 測試覆蓋率不足 / Insufficient Test Coverage

#### 缺少 ChatWebSocketClient 單元測試
- **TDD 要求**: Unit Test 覆蓋率 ≥ 80%
- **實際狀況**: 
  - ✅ 有 `ChatAPIWebSocketTests.swift`，但只測試了 `WebSocketEndpoint`
  - ❌ **缺少 `ChatWebSocketClient` 的單元測試**
- **建議**: 
  - 添加 `ChatWebSocketClientTests.swift`
  - 測試覆蓋：
    - 連線管理（connect, disconnect）
    - 訂閱管理（subscribe, unsubscribe）
    - 訊息接收與發送
    - 重連機制
    - 錯誤處理

### 3. TODO 項目 / TODO Items

實作中包含以下 TODO，需要後續驗證：

#### 3.1 accept-version 格式驗證
```swift
// TODO: 驗證 accept-version 格式
// API Spec 要求: accept-version:1,2,1,1,1.0
// SportyStomp 默認: "1.1,1.2"
// 需要測試 connectWithCustomHeaders(acceptVersion: "1,2,1,1,1.0") 是否正常工作
```
- **狀態**: ⚠️ 待驗證
- **建議**: 在 Integration Test 中驗證

#### 3.2 heart-beat header 驗證
```swift
// TODO: 驗證 heart-beat header
// API Spec 要求: heart-beat:4000,4000 (在 CONNECT frame 中)
// SportyStomp 使用 enableAutoPing() 提供 WebSocket 層的 ping
// 需要確認服務端是否需要 STOMP 層的 heart-beat header
```
- **狀態**: ⚠️ 待驗證
- **建議**: 與後端確認是否需要 STOMP 層的 heart-beat header

#### 3.3 訊息格式驗證
```swift
// TODO: 驗證訊息格式是否符合 API Spec
// API Spec 要求格式: {"type":"MESSAGE","data":{...}}
// 需要確認實際接收到的訊息格式是否完全符合此規範
```
- **狀態**: ⚠️ 待驗證
- **建議**: 在 Integration Test 中驗證實際訊息格式

### 4. 方法註解中的注意事項 / Notes in Method Comments

#### `unsubscribe(subscriberId:)` 方法
```swift
/// **注意**: 這個方法需要改進，因為 AsyncStream 沒有提供 subscriberId。
/// 實際使用時，可能需要返回一個包含 stream 和 unsubscribe 方法的 tuple。
```
- **評估**: 當前實作已經通過 `addSubscriber()` 返回 `(stream, id)` tuple，解決了這個問題
- **建議**: 更新註解，說明當前實作已經解決了這個問題

---

## 📋 驗收條件檢查 / Acceptance Criteria Check

| 驗收條件 | 狀態 | 說明 |
|---------|------|------|
| `ChatWebSocketClient` 實作完成，使用 `actor` | ✅ | 已實作 |
| WebSocket 連線管理實作完成 | ✅ | connect/disconnect 已實作 |
| 訂閱 / 取消訂閱實作完成 | ✅ | subscribe/unsubscribe 已實作 |
| 訊息接收與發送實作完成 | ✅ | handleMessageReceived/sendMessage 已實作 |
| 重連機制實作完成（指數退避） | ✅ | reconnect() 已實作 |
| 心跳機制實作完成 | ✅ | enableAutoPing() 已實作 |
| 檔案結構符合參考代碼風格 | ✅ | 符合 |
| Unit Test 覆蓋率 ≥ 80% | ❌ | **缺少 ChatWebSocketClient 單元測試** |
| Integration Test 通過 | ⚠️ | 需要驗證 |

---

## 🔍 架構對齊檢查 / Architecture Alignment Check

### ✅ Clean Architecture 層級關係
- **Client Layer** → **API Layer**: ✅ 使用 `ChatAPI.WebSocketEndpoint` 和 `ChatAPI.WebSocketMessageDTO`
- **Repository Layer** → **Client Layer**: ⚠️ 需要檢查 `LiveChatRepository` 是否正確使用 `ChatWebSocketClient`

### ✅ Module Responsibility
- ✅ WebSocket 通訊（即時訊息）
- ✅ 訂閱 / 取消訂閱
- ✅ 訊息接收與發送
- ✅ 連線管理（重連、心跳等）

### ✅ API Spec 對齊
- ✅ WebSocket URL: 使用 `ChatAPI.WebSocketEndpoint.url(for:)`
- ✅ Topic 格式: `/topic/chat_room.{chatroomId}`
- ✅ Message DTO: `ChatAPI.WebSocketMessageDTO`
- ⚠️ accept-version 和 heart-beat: 待驗證（見 TODO）

### ✅ Module Sequence Diagram 對齊
- ✅ 連線時機: `connect()` 方法已實作
- ✅ 訂閱時機: `subscribe(chatroomId:)` 方法已實作
- ✅ 取消訂閱時機: `unsubscribe()` 方法已實作

---

## 📝 改進建議 / Improvement Suggestions

### 1. 優先級：高 / Priority: High

#### 1.1 添加單元測試
- **檔案**: `MatchChat/Tests/MatchChatTests/ChatWebSocketClientTests.swift`
- **測試項目**:
  - 連線管理（成功/失敗場景）
  - 訂閱管理（單一/多訂閱者）
  - 訊息接收與解析
  - 重連機制（指數退避）
  - 錯誤處理

#### 1.2 驗證 API Spec 兼容性
- 測試 `accept-version: "1,2,1,1,1.0"` 是否正常工作
- 確認服務端是否需要 STOMP 層的 `heart-beat` header
- 驗證實際接收到的訊息格式是否符合 API Spec

### 2. 優先級：中 / Priority: Medium

#### 2.1 更新方法註解
- 更新 `unsubscribe(subscriberId:)` 的註解，說明當前實作已經解決了 AsyncStream subscriberId 的問題

#### 2.2 添加 Integration Test
- 在 `MatchChatIntegrationTests` 中添加 `ChatWebSocketClientIntegrationTests.swift`
- 測試實際 WebSocket 連線、訂閱、訊息接收

### 3. 優先級：低 / Priority: Low

#### 3.1 代碼優化
- 考慮將 `extractChatroomId()` 改為更健壯的正則表達式解析
- 考慮添加更詳細的錯誤日誌

---

## ✅ 總結 / Summary

### 整體評估 / Overall Assessment

**實作完成度**: 95% ✅

**主要成就**:
- ✅ 所有核心功能已實作
- ✅ 符合 TDD 設計規範（使用 actor、AsyncStream 等）
- ✅ 正確使用 SportyStomp 框架
- ✅ 實作指數退避重連策略
- ✅ 支援多訂閱者模式

**主要缺失**:
- ❌ 缺少 ChatWebSocketClient 單元測試
- ⚠️ 需要驗證 API Spec 兼容性（accept-version、heart-beat、訊息格式）

**建議行動**:
1. **立即**: 添加 ChatWebSocketClient 單元測試
2. **短期**: 驗證 API Spec 兼容性（Integration Test）
3. **中期**: 更新 TDD 文件，反映實際的方法簽名

---

**報告生成時間**: 2025-12-03  
**下次檢查建議**: 完成單元測試後








