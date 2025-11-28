# TDD-031: LiveChatRepository

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-031 |
| **標題** | 實作 LiveChatRepository |
| **類型** | Repository |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-004, TDD-005, TDD-021, TDD-022 |
| **Story Point** | 8 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：3 天<br/>最嚴厲：2 天 |
| **開發日期 / Development Date** | 2025-12-05 (週五)

## 描述 / Description

實作 LiveChatRepository。 / Implement LiveChatRepository。

## 需求 / Requirements

1. 實作 Repository Protocol（定義在 `ChatAPI+RepositoryProtocol.swift`） / Implement Repository Protocol (defined in `ChatAPI+RepositoryProtocol.swift`)
2. 實作 Repository（定義在 `ChatAPI+Repository.swift`，使用 `actor`） / Implement Repository (defined in `ChatAPI+Repository.swift`, using `actor`)
3. 實作 DTO → Domain Model 轉換（使用 extension，如 `ChatAPI+LiveChat.swift`） / Implement DTO → Domain Model conversion (using extension, e.g., `ChatAPI+LiveChat.swift`)
4. 整合 `LiveChatClient` 和 `ChatWebSocketClient` 呼叫 / Integrate `LiveChatClient` and `ChatWebSocketClient` calls
5. 管理 WebSocket 連線 / Manage WebSocket connection
6. 實作所有方法： / Implement all methods:
   - `getChatroomInfo(refId: String) async throws -> LiveChat.ChatroomInfo`
   - `joinChatroom(chatroomId: String) async throws -> Void`
   - `loadHistoricalMessages(chatroomId: String, lastMessageNo: Int) async throws -> [LiveChat.Message]`
   - `sendMessage(chatroomId: String, content: String, messageType: LiveChat.MessageType) async throws -> LiveChat.Message`
   - `leaveChatroom(chatroomId: String) async throws -> Void`
   - `subscribeWebSocket() async throws -> Void`
   - `unsubscribeWebSocket() async throws -> Void`
   - `addToBlacklist(userId: String, eventId: String, timestamp: Date) async throws -> Void`
   - `checkAndCleanBlacklist() async throws -> Void`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/LiveChat/Services/API/Chat/
  ├── ChatAPI+RepositoryProtocol.swift  # Repository Protocol
  ├── ChatAPI+Repository.swift          # Repository 實作（actor）
  └── ChatAPI+LiveChat.swift            # DTO → Domain Model 轉換
```

### 命名規範 / Naming Conventions

- Repository 使用 `actor`，實作 `ChatRepositoryProtocol` / Repository uses `actor`, implements `ChatRepositoryProtocol`
- DTO → Domain Model 轉換使用 extension，方法命名為 `toDomainXXX()` / DTO → Domain Model conversion uses extension, method named `toDomainXXX()`
- Domain Model 使用 `LiveChat.XXX` 命名空間 / Domain Model uses `LiveChat.XXX` namespace
- 使用 `public` 修飾符 / Use `public` modifier

## 驗收條件 / Acceptance Criteria

- [ ] Repository Protocol 定義完成（在 `ChatAPI+RepositoryProtocol.swift`） / Repository Protocol definition complete (in `ChatAPI+RepositoryProtocol.swift`)
- [ ] Repository 實作完成，使用 `actor`（在 `ChatAPI+Repository.swift`） / Repository implementation complete, using `actor` (in `ChatAPI+Repository.swift`)
- [ ] DTO → Domain Model Mapping 實作完成，使用 extension（在 `ChatAPI+LiveChat.swift`） / DTO → Domain Model Mapping implementation complete, using extension (in `ChatAPI+LiveChat.swift`)
- [ ] 所有方法使用 `LiveChat.XXX` 命名空間 / All methods use `LiveChat.XXX` namespace
- [ ] WebSocket 連線管理實作完成 / WebSocket connection management implementation complete
- [ ] 黑名單管理實作完成 / Blacklist management implementation complete
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] 所有方法 Unit Test 覆蓋率 ≥ 80% / All methods Unit Test Coverage ≥ 80%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Domain Model：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`
- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`

## 調整因子說明 / 調整因子說明

- 基礎估時：中等 Repository = 3 SP
- +2 SP：需要整合多個 Client（HTTP + WebSocket） / - +2 SP：需要整合多個 Client(HTTP + WebSocket)
- +2 SP：複雜的資料合併邏輯（歷史訊息與 WebSocket 訊息合併） / - +2 SP：複雜的資料合併Logic(歷史訊息與 WebSocket 訊息合併)
- +1 SP：黑名單管理邏輯 / - +1 SP：黑名單管理Logic

