# PrematchComment Module Sequence Diagrams

本目錄包含 PrematchComment Feature 的模組序列圖。

## 文件列表

- `01_data_initialization_refresh.md` - 初始化與刷新留言列表流程
- `02_data_interaction_publish_comment.md` - 發送留言流程
- `03_data_interaction_toggle_like.md` - 切換 Like 狀態流程
- `04_data_interaction_load_replies.md` - 載入回覆列表流程
- `05_structural_navigation_profile.md` - 跳轉個人主頁流程
- `06_event_status_subscription.md` - Event Status 訂閱與通知流程

## Flow 關係

| Flow ID | Flow Type | Flow Name | 父流程 |
|---------|----------|----------|--------|
| **PC-FULL-001** | Full | 用戶進入 Upcoming Race Page, Prematch Comment Page 與 Top | - |
| **PC-SUB-001** | Sub | Event Status 訂閱與通知流程 | PC-FULL-001 |
| **PC-SUB-002** | Sub | 用戶發 Comment - Reply（含登入與 nickname 檢查） | PC-FULL-001 |
| **PC-SUB-003** | Sub | 用戶查看 replies（含分頁載入） | PC-FULL-001 |
| **PC-SUB-004** | Sub | 用戶點擊 Like（含登入檢查） | PC-FULL-001 |
| **PC-SUB-005** | Sub | 用戶點擊用戶名稱 → 跳轉個人主頁 | PC-FULL-001 |
| **PC-SUB-001** | Sub | Event Status 訂閱與通知流程 | PC-FULL-001 |

