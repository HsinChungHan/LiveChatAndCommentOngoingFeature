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

## 描述 / Description

實作 LiveChatRepository。 / Implement LiveChatRepository。

## 需求 / Requirements

1. 實作 Repository 介面 / Implement Repository 介面
2. 實作 DTO → Domain Model 轉換 / Implement DTO → Domain Model 轉換
3. 整合 LiveChatClient 和 ChatWebSocketClient 呼叫 / Integrate LiveChatClient 和 ChatWebSocketClient Call
4. 管理 WebSocket 連線 / 管理 WebSocket 連線
5. 實作所有方法： / 實作所有Methods：
   - `getChatroomInfo(refId: String) async throws -> ChatroomInfo`
   - `joinChatroom(chatroomId: String) async throws -> Void`
   - `loadHistoricalMessages(chatroomId: String, lastMessageNo: Int) async throws -> [Message]`
   - `sendMessage(chatroomId: String, content: String, messageType: MessageType) async throws -> Message`
   - `leaveChatroom(chatroomId: String) async throws -> Void`
   - `subscribeWebSocket() async throws -> Void`
   - `unsubscribeWebSocket() async throws -> Void`
   - `addToBlacklist(userId: String, eventId: String, timestamp: Date) async throws -> Void`
   - `checkAndCleanBlacklist() async throws -> Void`

## 驗收條件 / Acceptance Criteria

- [ ] Repository 介面實作完成 / Repository 介面Implementation Complete
- [ ] DTO → Domain Model Mapping 實作完成 / DTO → Domain Model Mapping Implementation Complete
- [ ] WebSocket 連線管理實作完成 / WebSocket 連線管理Implementation Complete
- [ ] 黑名單管理實作完成 / 黑名單管理Implementation Complete
- [ ] 所有方法 Unit Test 覆蓋率 ≥ 80% / 所有Methods Unit Test Coverage ≥ 80%
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

