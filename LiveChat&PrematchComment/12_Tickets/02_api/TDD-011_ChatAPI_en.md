# TDD-011: ChatAPI

## Ticket Information

|------|-----|
|  | **Ticket ID** | TDD-011 |
| **Jira Key** | FOOTBALL-9179 |  |
|  | Implement ChatAPI Define |  |
|  | **Type** | API |  |
|  | P0 |  |
|  | LiveChat |  |
|  | TDD-004, TDD-005 |  |
|  | **Story Point** | 5 |  |
|  | Standard：2 days<br/>Most Stringent：1 days |  |

## Description

Implement ChatAPI API 定義(包含 HTTP 和 WebSocket)。

## Requirements

1. Define All HTTP Endpoints(URL, Method, Request/Response DTO)
2. Define WebSocket 端點and訊息格式
3. Define Error Response 格式
4. Define API 文件註解
5. 5. Endpoints：
6. - `GET /chat/match/{refId}`
7. - `POST /chat/match/join`
8. - `POST /chat/match/backward`
9. - `POST /chat/match/leave`
10. - `POST /chat/{matchId}/message`
11. - `wss://www.encorebet.net/chat/websocket/web-chat`（WebSocket）

## Acceptance Criteria

- [ ] all HTTP Endpoints Definition Complete
- [ ] WebSocket 端點and訊息格式Definition Complete
- [ ] Request/Response DTO Definition Complete
- [ ] API 文件註解完整
- [ ] Error Response 格式Definition Complete

## Related Documents

- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`

## 調整因子說明

- +2 SP：WebSocket API(複雜度較高)

