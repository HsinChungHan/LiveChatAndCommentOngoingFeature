# TDD-010: PrematchCommentAPI

## Ticket Information

|------|-----|
|  | **Ticket ID** | TDD-010 |
| **Jira Key** | FOOTBALL-9178 |  |
|  | Implement PrematchCommentAPI Define |  |
|  | **Type** | API |  |
|  | P0 |  |
|  | PrematchComment |  |
|  | TDD-001, TDD-002, TDD-006 |  |
|  | **Story Point** | 3 |  |
|  | Standard：1 days<br/>Most Stringent：1 days |  |

## Description

Implement PrematchCommentAPI API 定義。

## Requirements

1. Define All Endpoints(URL, Method, Request/Response DTO)
2. Define Error Response 格式
3. Define API 文件註解
4. 4. Endpoints：
5. - `GET /chat/match/comment/info/{refId}`
6. - `GET /chat/match/comment/popular`
7. - `GET /chat/match/comment/newest`
8. - `GET /chat/match/comment/replies`
9. - `POST /chat/match/comment`
10. - `POST /chat/match/comment/like`

## Acceptance Criteria

- [ ] all Endpoints Definition Complete
- [ ] Request/Response DTO Definition Complete
- [ ] API 文件註解完整
- [ ] Error Response 格式Definition Complete

## Related Documents

- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
