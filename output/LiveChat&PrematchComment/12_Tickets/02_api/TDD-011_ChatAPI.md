# TDD-011: ChatAPI

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-011 |
| **標題** | 實作 ChatAPI 定義 |
| **類型** | API |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-004, TDD-005 |
| **Story Point** | 5 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：2 天<br/>最嚴厲：1 天 |

## 描述 / Description

實作 ChatAPI API 定義（包含 HTTP 和 WebSocket）。 / Implement ChatAPI API 定義(包含 HTTP 和 WebSocket)。

## 需求 / Requirements

1. 定義所有 HTTP Endpoints（URL、Method、Request/Response DTO） / Define All HTTP Endpoints(URL, Method, Request/Response DTO)
2. 定義 WebSocket 端點和訊息格式 / Define WebSocket 端點和訊息格式
3. 定義 Error Response 格式 / Define Error Response 格式
4. 定義 API 文件註解 / Define API 文件註解
5. Endpoints：
   - `GET /chat/match/{refId}`
   - `POST /chat/match/join`
   - `POST /chat/match/backward`
   - `POST /chat/match/leave`
   - `POST /chat/{matchId}/message`
   - `wss://www.encorebet.net/chat/websocket/web-chat`（WebSocket）

## 驗收條件 / Acceptance Criteria

- [ ] 所有 HTTP Endpoints 定義完成 / 所有 HTTP Endpoints Definition Complete
- [ ] WebSocket 端點和訊息格式定義完成 / WebSocket 端點和訊息格式Definition Complete
- [ ] Request/Response DTO 定義完成 / Request/Response DTO Definition Complete
- [ ] API 文件註解完整 / API 文件註解完整
- [ ] Error Response 格式定義完成 / Error Response 格式Definition Complete

## 相關文件 / Related Documents

- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`

## 調整因子說明 / 調整因子說明

- +2 SP：WebSocket API（複雜度較高） / - +2 SP：WebSocket API(複雜度較高)

