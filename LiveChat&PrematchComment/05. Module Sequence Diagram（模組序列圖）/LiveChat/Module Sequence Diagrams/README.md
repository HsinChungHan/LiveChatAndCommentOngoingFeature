# LiveChat Module Sequence Diagrams

本目錄包含 LiveChat Feature 的模組序列圖。

## 文件列表

- `01_data_initialization_initialize_chatroom.md` - 初始化聊天室流程
- `02_data_interaction_send_message.md` - 發送聊天訊息流程
- `03_structural_navigation_block_user.md` - 封鎖用戶流程
- `04_structural_navigation_profile.md` - 跳轉個人主頁流程

## Flow 關係

| Flow ID | Flow Type | Flow Name | 父流程 |
|---------|----------|----------|--------|
| **LC-FULL-001** | Full | 用戶進入與離開聊天室（含 WebSocket 相依） | - |
| **LC-SUB-001** | Sub | 用戶留 comment 時登入與 nickname 檢查 | LC-FULL-001 |
| **LC-SUB-002** | Sub | 用戶點擊 avatar 與封鎖其他 user 邏輯 | LC-FULL-001 |
| **LC-SUB-003** | Sub | 聊天室訊息傳遞與滾動加載 | LC-FULL-001 |

