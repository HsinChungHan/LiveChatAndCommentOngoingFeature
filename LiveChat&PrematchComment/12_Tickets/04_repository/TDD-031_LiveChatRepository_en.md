# TDD-031: LiveChatRepository

## Ticket Information

|------|-----|
|  | **Ticket ID** | TDD-031 |
| **Jira Key** | FOOTBALL-9186 |  |
|  | Implement LiveChatRepository |  |
|  | **Type** | Repository |  |
|  | P0 |  |
|  | LiveChat |  |
|  | TDD-004, TDD-005, TDD-021, TDD-022 |  |
|  | **Story Point** | 8 |  |
|  | Standard：3 days<br/>Most Stringent：2 days |  |

## Description

Implement LiveChatRepository。

## Requirements

1. Implement Repository 介面
2. Implement DTO → Domain Model 轉換
3. Integrate LiveChatClient and ChatWebSocketClient Call
4. 管理 WebSocket 連線
5. ImplementallMethods：
6. - `getChatroomInfo(refId: String) async throws -> ChatroomInfo`
7. - `joinChatroom(chatroomId: String) async throws -> Void`
8. - `loadHistoricalMessages(chatroomId: String, lastMessageNo: Int) async throws -> [Message]`
9. - `sendMessage(chatroomId: String, content: String, messageType: MessageType) async throws -> Message`
10. - `leaveChatroom(chatroomId: String) async throws -> Void`
11. - `subscribeWebSocket() async throws -> Void`
12. - `unsubscribeWebSocket() async throws -> Void`
13. - `addToBlacklist(userId: String, eventId: String, timestamp: Date) async throws -> Void`
14. - `checkAndCleanBlacklist() async throws -> Void`

## Acceptance Criteria

- [ ] Repository 介面Implementation Complete
- [ ] DTO → Domain Model Mapping Implementation Complete
- [ ] WebSocket 連線管理Implementation Complete
- [ ] 黑名單管理Implementation Complete
- [ ] allMethods Unit Test Coverage ≥ 80%
- [ ] Integration Test Passed

## Related Documents

- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Domain Model：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`
- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`

## 調整因子說明

- +2 SP：需要整合多個 Client(HTTP + WebSocket)
- +2 SP：複雜的資料合併Logic(歷史訊息與 WebSocket 訊息合併)
- +1 SP：黑名單管理Logic

