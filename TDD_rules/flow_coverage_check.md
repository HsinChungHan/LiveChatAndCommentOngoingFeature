# Module Sequence Diagram 覆蓋檢查

## 原始 Mermaid 流程 vs 生成的序列圖對照

### PrematchComment Feature

#### ✅ 1. @flow: Full - 主流程
**原始流程包含：**
- 進入 Race Detail Page → GET 個人資訊 API → GET /chat/match/comment/info/{refId}
- 進入 Prematch Comment Page → GET /chat/match/comment/popular
- 切換 tab (Newest/Top)
- 點擊 Refresh (Top/Newest)

**對應序列圖：**
- ✅ `01_data_initialization_refresh.md` - 完整覆蓋所有流程

#### ✅ 2. @flow: Sub - Replies Pagination
**原始流程包含：**
- 點擊 12 replies → GET /chat/match/comment/replies
- loop 每次最多 5 筆
- 顯示/隱藏 Show more replies

**對應序列圖：**
- ✅ `02_data_interaction_load_replies.md` - 完整覆蓋

#### ✅ 3. @flow: Sub - Like Flow
**原始流程包含：**
- User 點擊 Like
- 未登入 → 登入流程
- Optimistic UI +1
- POST /chat/match/comment/like

**對應序列圖：**
- ✅ `03_data_interaction_toggle_like.md` - 完整覆蓋

#### ✅ 4. @flow: Sub - Comment / Reply Publish
**原始流程包含：**
- User 點擊輸入框
- 未登入 → 登入
- 使用者送出 Comment/Reply
- 有 nickname → POST /chat/match/comment
- 無 nickname → 建立 nickname → POST /chat/match/comment

**對應序列圖：**
- ✅ `04_data_interaction_publish_comment.md` - 完整覆蓋

#### ✅ 5. @flow: Sub - 點擊使用者進入 Profile
**原始流程包含：**
- 點擊使用者 → Profile Flow
- 顯示 Profile

**對應序列圖：**
- ✅ `05_structural_navigation_profile.md` - 完整覆蓋

---

### LiveChat Feature

#### ✅ 1. @flow: Full - 主流程
**原始流程包含：**
- 進入 Live Detail Page
- subscribe WebSocket
- GET /chat/match/{refId} → chatroomId, lastMessageNo
- 有 chatroomId → 顯示 Live Chat bar
- Join Chatroom → POST /chat/match/join
- POST /chat/match/backward → historicalMessages
- websocketMessages → merge messages

**對應序列圖：**
- ✅ `01_data_initialization_initialize_chatroom.md` - 覆蓋：進入頁面、subscribe、GET chatroomInfo
- ✅ `02_data_interaction_join_chatroom.md` - 覆蓋：Join Chatroom、Load History
- ✅ `03_data_interaction_receive_websocket.md` - 覆蓋：接收 WebSocket 訊息、merge messages

**檢查結果：** ✅ 完整覆蓋（已拆分為 3 個序列圖，符合規範）

#### ✅ 2. @flow: Sub - Chat 發送流程
**原始流程包含：**
- 點擊輸入框
- 未登入 → 登入
- 使用者送出 Chat
- 有 nickname → POST /chat/match/comment
- 無 nickname → 建立 nickname → POST /chat/{matchId}/message

**對應序列圖：**
- ✅ `04_data_interaction_send_message.md` - 完整覆蓋

#### ✅ 3. @flow: Sub - 點擊使用者（Profile / Block）
**原始流程包含：**
- 點擊使用者 → Profile / Block 選單
- Profile → Go to Profile → 顯示 Profile
- Block → 加入 Blacklist (userId, eventId, timestamp) → WebSocket 重連同步 blocked list
- 離開 Chatroom → 清理過期 blacklist (4hr TTL)

**對應序列圖：**
- ✅ `05_structural_navigation_user_interaction.md` - 覆蓋：Profile / Block
- ✅ `06_data_interaction_leave_chatroom.md` - 覆蓋：離開 Chatroom、清理過期 blacklist

**檢查結果：** ✅ 完整覆蓋（離開 Chatroom 已獨立為序列圖）

---

## 總結

### PrematchComment Feature
- ✅ 5 個原始流程全部覆蓋
- ✅ 生成 5 個序列圖檔案

### LiveChat Feature
- ✅ 3 個原始流程全部覆蓋
- ✅ 生成 6 個序列圖檔案（Full Flow 已合理拆分為多個序列圖）

### 所有原始 Mermaid 流程都已完整覆蓋 ✅

