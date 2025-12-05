# TDD 文件更新記錄 - 2025-12-04

## 更新摘要

基於 2025-12-05 的實作改進，更新了相關 TDD 文件以反映實際實作的設計決策。

## 更新內容

### 1. **TDD-010: PrematchCommentAPI** ✅

**檔案**: `12_Tickets/02_api/TDD-010_PrematchCommentAPI.md`

**變更原因**: 引入 `SharedBetsMetadata` 包裝型別以符合 Swift Concurrency Sendable 要求

**變更內容**:
- ✏️ Endpoint `publishComment` 參數：`[String: AnyCodable]?` → `[String: Any]?`
- ✏️ Request DTO `sharedBetsMeta`：`[String: AnyCodable]?` → `[String: Any]?`（API 層使用原始字典）
- ➕ 新增 `SharedBetsMetadata` 結構定義
- ✏️ Repository Protocol `publishComment` 參數：`[String: AnyCodable]?` → `SharedBetsMetadata?`
- ✏️ Repository 實作：新增解包邏輯 `sharedBetsMeta?.value`
- ✏️ 命名規範：新增 `SharedBetsMetadata` 說明

**設計理念**:
```
Client Layer (SharedBetsMetadata) 
    ↓ 包裝 Sendable
Repository Layer (SharedBetsMetadata) 
    ↓ 解包
Endpoint/API Layer ([String: Any])
    ↓ JSON 序列化
Network
```

---

### 2. **TDD-020: PrematchCommentClient** ✅

**檔案**: `12_Tickets/03_client/TDD-020_PrematchCommentClient.md`

**變更原因**: Client 層使用 `SharedBetsMetadata` 包裝型別

**變更內容**:
- ✏️ `publishComment` 方法參數：`sharedBetsMeta: [String: AnyCodable]?` → `sharedBetsMeta: SharedBetsMetadata?`
- ➕ 新增方法註解說明 Sendable 包裝
- ✏️ 命名規範：新增 `SharedBetsMetadata` 說明

**程式碼範例**:
```swift
/// 發佈評論
/// - Note: sharedBetsMeta 使用 SharedBetsMetadata 包裝以符合 Sendable 協議
public func publishComment(
    refId: String, 
    content: String, 
    parentId: Int64?, 
    sharedBetsMeta: SharedBetsMetadata?,  // ← 變更
    tagUserId: String?
) async throws -> PrematchCommentAPI.CommentDTO
```

---

### 3. **TDD-022: ChatWebSocketClient** ✅

**檔案**: `12_Tickets/03_client/TDD-022_ChatWebSocketClient.md`

**變更原因**: `subscribe` 方法改為 `nonisolated` 以改善併發模型

**變更內容**:
- ✏️ `subscribe` 方法簽名：新增 `nonisolated` 修飾符
- ✏️ 方法註解：新增併發設計說明
- ✏️ 命名規範：新增 `nonisolated` 說明

**程式碼範例**:
```swift
/// 訂閱指定聊天室的訊息流
/// - Parameter chatroomId: 聊天室 ID
/// - Returns: AsyncStream<ChatAPI.WebSocketMessageDTO> 訊息流
/// 
/// **時機**: 加入聊天室時呼叫（參考 Module Sequence Diagram）
/// **設計**: 使用 nonisolated 允許同步創建 AsyncStream，實際訂閱邏輯在 actor 內執行
public nonisolated func subscribe(chatroomId: String) -> AsyncStream<...>
```

**設計理念**:
- `nonisolated` 方法可同步創建 `AsyncStream`
- 實際訂閱邏輯提取到 `performSubscribe` helper（actor-isolated）
- 避免不必要的 await 調用，改善 API 易用性

---

## 變更統計

| TDD Ticket | 檔案 | 變更類型 | 變更數量 |
|-----------|------|---------|---------|
| TDD-010 | PrematchCommentAPI | 型別更新、新增設計說明 | 6 處 |
| TDD-020 | PrematchCommentClient | 型別更新、註解補充 | 3 處 |
| TDD-022 | ChatWebSocketClient | 簽名更新、設計說明 | 3 處 |
| **總計** | - | - | **12 處** |

---

## 設計決策記錄

### 決策 1: 引入 SharedBetsMetadata 包裝型別

**問題**: 
- `[String: Any]` 字典不符合 `Sendable` 協議
- Swift Concurrency 環境中產生編譯警告

**解決方案**:
```swift
public struct SharedBetsMetadata: @unchecked Sendable {
    public let value: [String: Any]
    
    public init(_ value: [String: Any]) {
        self.value = value
    }
}
```

**優點**:
- ✅ 符合 Sendable 協議，消除編譯警告
- ✅ 型別安全，明確意圖
- ✅ 封裝實作細節，未來可擴展
- ✅ 只在需要的層級（Repository/Client）使用

**限制**:
- 使用 `@unchecked Sendable`（需要開發者確保安全性）
- 需要在 Repository 層手動解包

---

### 決策 2: subscribe 方法 nonisolated 化

**問題**:
- Actor-isolated 方法返回 `AsyncStream` 需要 await
- 調用方需要在 async context 才能獲取 stream

**解決方案**:
```swift
public nonisolated func subscribe(chatroomId: String) -> AsyncStream<...> {
    AsyncStream { continuation in
        Task {
            await self.performSubscribe(chatroomId: chatroomId, continuation: continuation)
        }
    }
}
```

**優點**:
- ✅ 同步創建 AsyncStream，改善 API 易用性
- ✅ 實際訂閱邏輯仍在 actor 內執行，保持線程安全
- ✅ 符合 Swift Concurrency 最佳實踐

**參考**:
- Apple AsyncStream 設計模式
- EventOddsWebSocketManager 實作

---

## 影響範圍分析

### 向後兼容性

| 變更 | 是否 Breaking Change | 影響範圍 |
|------|---------------------|---------|
| SharedBetsMetadata | ✅ 是 | Client 層調用方需更新 |
| subscribe nonisolated | ❌ 否 | 移除 await 要求，更容易使用 |

### 需要更新的程式碼

1. **使用 PrematchCommentClient 的程式碼**
   - 需要將 `[String: Any]` 包裝成 `SharedBetsMetadata`
   - 範例：
   ```swift
   // Before
   let meta: [String: Any] = ["betId": "123"]
   try await client.publishComment(..., sharedBetsMeta: meta, ...)
   
   // After
   let meta = SharedBetsMetadata(["betId": "123"])
   try await client.publishComment(..., sharedBetsMeta: meta, ...)
   ```

2. **使用 ChatWebSocketClient 的程式碼**
   - 可以移除不必要的 await（向後兼容）
   - 範例：
   ```swift
   // Before (仍可用)
   let stream = await client.subscribe(chatroomId: id)
   
   // After (更簡潔)
   let stream = client.subscribe(chatroomId: id)
   ```

---

## 測試更新需求

### 單元測試

- [ ] TDD-010: 測試 `SharedBetsMetadata` 包裝/解包邏輯
- [ ] TDD-020: 測試 Client 使用 `SharedBetsMetadata` 參數
- [ ] TDD-022: 測試 `subscribe` nonisolated 行為

### 整合測試

- [ ] 端到端測試 publishComment 功能（含 sharedBetsMeta）
- [ ] WebSocket subscribe/unsubscribe 生命週期測試

---

## 相關文件

- **實作一致性檢查**: `13_Implementation_Status/tdd_consistency_check_2025-12-05.md`
- **變更日誌**: `14_Changelog/CHANGELOG.md`
- **Commit 記錄**:
  - `1f97afa505` - refactor: wrap shared bets metadata in sendable type
  - `163d376ab6` - refactor: make websocket subscribe method nonisolated

---

## 下次更新建議

1. **補充測試** (優先級: P0)
   - 為 `SharedBetsMetadata` 新增單元測試
   - 驗證 nonisolated subscribe 的併發安全性

2. **文件完善** (優先級: P2)
   - 增加 `SharedBetsMetadata` 使用範例
   - 更新 API 整合指南

3. **定期檢查** (優先級: P2)
   - 每完成一個 layer 後檢查 TDD 一致性
   - 確保文件與實作同步

---

**更新人**: AI Assistant  
**更新日期**: 2025-12-04  
**關聯 Tickets**: FOOTBALL-9180-9184  
**Git Branch**: feature/FOOTBALL-9180-9184-DataLayer

