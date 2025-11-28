# Test Scenarios

## PrematchComment UseCases

### ReloadCommentListUseCase

#### Basic Flow
- **描述**：正常載入留言列表
- **前置條件**：用戶已進入 Prematch Comment Page
- **輸入**：`refId: "match123"`, `triggerType: .init`, `mode: .top`, `cursor: nil`
- **預期結果**：成功載入留言列表，回傳 `comments` 和 `pagingInfo`

#### Branch Flow - Top Mode
- **描述**：載入 Top 模式的留言列表
- **輸入**：`mode: .top`
- **預期結果**：載入按 Like 數排序的留言列表

#### Branch Flow - Newest Mode
- **描述**：載入 Newest 模式的留言列表
- **輸入**：`mode: .newest`
- **預期結果**：載入按時間排序的留言列表

#### Branch Flow - Trigger Type
- **描述**：不同觸發方式的載入
- **輸入**：`triggerType: .init` / `.refresh` / `.switch`
- **預期結果**：根據 triggerType 執行對應的載入邏輯

#### Loop Flow - Pagination
- **描述**：分頁載入更多留言
- **輸入**：`cursor: Cursor(value: "next123")`
- **預期結果**：載入下一頁留言，回傳新的 `cursor`

#### Error Flow - Network Error
- **描述**：網路連線失敗
- **預期結果**：拋出 `NetworkError`，顯示錯誤 Toast

#### Error Flow - Server Error
- **描述**：伺服器回傳 500 錯誤
- **預期結果**：拋出 `APIError.serverError`，顯示錯誤 Toast

#### Edge Case - Empty List
- **描述**：留言列表為空
- **預期結果**：回傳空陣列 `[]`，顯示空狀態 UI

#### Edge Case - Invalid Cursor
- **描述**：無效的 cursor
- **輸入**：`cursor: Cursor(value: "invalid")`
- **預期結果**：回傳空陣列或錯誤

---

### PublishCommentUseCase

#### Basic Flow - Publish Comment
- **描述**：成功發送留言
- **前置條件**：用戶已登入且有 nickname
- **輸入**：`refId: "match123"`, `content: "Hello"`, `parentId: nil`
- **預期結果**：成功發送留言，回傳新的 `Comment`

#### Branch Flow - Publish Reply
- **描述**：成功發送回覆
- **輸入**：`parentId: "comment123"`
- **預期結果**：成功發送回覆，回傳新的 `Comment`（parentId 有值）

#### Optional Flow - No Nickname
- **描述**：用戶沒有 nickname，需要建立
- **前置條件**：用戶已登入但無 nickname
- **預期結果**：調用 FComSharedFlow Package 建立 nickname，建立成功後發送留言

#### Optional Flow - Not Logged In
- **描述**：用戶未登入
- **前置條件**：用戶未登入
- **預期結果**：跳轉到登入頁面，登入成功後回到原頁面

#### Error Flow - Validation Error
- **描述**：留言內容為空
- **輸入**：`content: ""`
- **預期結果**：拋出 `ValidationError`，顯示「留言內容不能為空」

#### Error Flow - Content Too Long
- **描述**：留言內容超過長度限制
- **輸入**：`content: String(repeating: "a", count: 501)`
- **預期結果**：拋出 `ValidationError`，顯示「留言內容不能超過 500 字」

#### Error Flow - API Error
- **描述**：API 回傳錯誤
- **預期結果**：拋出 `APIError`，顯示錯誤 Toast

---

### ToggleLikeUseCase

#### Basic Flow - Like Comment
- **描述**：成功點讚留言
- **前置條件**：用戶已登入
- **輸入**：`commentId: "comment123"`
- **預期結果**：成功點讚，回傳更新後的 `Comment`（likeCount +1）

#### Basic Flow - Unlike Comment
- **描述**：成功取消點讚
- **前置條件**：用戶已登入且已點讚
- **預期結果**：成功取消點讚，回傳更新後的 `Comment`（likeCount -1）

#### Optional Flow - Not Logged In
- **描述**：用戶未登入
- **預期結果**：跳轉到登入頁面

#### Error Flow - API Error
- **描述**：API 回傳錯誤
- **預期結果**：拋出 `APIError`，顯示錯誤 Toast

#### Edge Case - Optimistic UI
- **描述**：Optimistic UI 更新
- **預期結果**：UI 立即更新 Like 數，API 請求在背景執行

---

### LoadRepliesUseCase

#### Basic Flow
- **描述**：成功載入回覆列表
- **輸入**：`commentId: "comment123"`, `cursor: nil`
- **預期結果**：成功載入回覆列表（最多 5 筆），回傳 `replies` 和 `pagingInfo`

#### Loop Flow - Load More Replies
- **描述**：載入更多回覆
- **輸入**：`cursor: Cursor(value: "next123")`
- **預期結果**：載入下一批回覆（最多 5 筆）

#### Edge Case - No More Replies
- **描述**：沒有更多回覆
- **預期結果**：回傳空陣列，`pagingInfo.hasMore = false`

#### Edge Case - Less Than 5 Replies
- **描述**：回覆數量少於 5 筆
- **預期結果**：回傳所有回覆，`pagingInfo.hasMore = false`

---

### NavigateToProfileUseCase

#### Basic Flow
- **描述**：成功跳轉到個人主頁
- **輸入**：`userId: "user123"`
- **預期結果**：成功跳轉到該用戶的個人主頁

#### Error Flow - Navigation Failed
- **描述**：路由跳轉失敗
- **預期結果**：記錄錯誤日誌，不影響主要功能

---

## LiveChat UseCases

### SendChatMessageUseCase

#### Basic Flow - With Nickname
- **描述**：成功發送聊天訊息（有 nickname）
- **前置條件**：用戶已登入且有 nickname
- **輸入**：`chatroomId: "room123"`, `content: "Hello"`, `messageType: .text`
- **預期結果**：成功發送訊息，回傳新的 `Message`

#### Branch Flow - Without Nickname
- **描述**：成功發送聊天訊息（無 nickname，需建立）
- **前置條件**：用戶已登入但無 nickname
- **預期結果**：調用 FComSharedFlow Package 建立 nickname，建立成功後發送訊息

#### Optional Flow - Not Logged In
- **描述**：用戶未登入
- **預期結果**：跳轉到登入頁面

#### Error Flow - Validation Error
- **描述**：訊息內容為空
- **輸入**：`content: ""`
- **預期結果**：拋出 `ValidationError`

#### Error Flow - API Error
- **描述**：API 回傳錯誤
- **預期結果**：拋出 `APIError`，顯示錯誤 Toast

---

### JoinChatroomUseCase

#### Basic Flow
- **描述**：成功加入聊天室並載入歷史訊息
- **輸入**：`refId: "match123"`
- **預期結果**：成功加入聊天室，回傳 `chatroomInfo` 和 `messages`

#### Branch Flow - Merge Messages
- **描述**：合併歷史訊息與 WebSocket 訊息
- **預期結果**：歷史訊息與 WebSocket 訊息合併，依 `messageNo` 去重

#### Error Flow - Get Chatroom Info Failed
- **描述**：取得聊天室資訊失敗
- **預期結果**：拋出錯誤，隱藏 Live Chat Bar

#### Error Flow - Get Chatroom Info Failed
- **描述**：取得聊天室資訊失敗（在開啟聊天視窗前）
- **預期結果**：拋出 `APIError`，隱藏 Live Chat Bar

#### Edge Case - No Historical Messages
- **描述**：沒有歷史訊息
- **預期結果**：回傳空陣列 `[]`

#### Edge Case - WebSocket Not Connected
- **描述**：WebSocket 未連線
- **預期結果**：先建立 WebSocket 連線，再載入歷史訊息

---

### LeaveChatroomUseCase

#### Basic Flow
- **描述**：成功離開聊天室
- **輸入**：`chatroomId: "room123"`
- **預期結果**：成功離開聊天室，清除快取的訊息

#### Branch Flow - Clean Blacklist
- **描述**：執行黑名單清理
- **預期結果**：檢查黑名單紀錄，超過 4 小時的紀錄自動移除

#### Edge Case - Blacklist Cleanup
- **描述**：黑名單清理邏輯
- **測試場景**：
  - 黑名單紀錄未超過 4 小時：保留
  - 黑名單紀錄超過 4 小時：移除

#### Error Flow - Leave Failed
- **描述**：離開聊天室失敗
- **預期結果**：記錄錯誤日誌，仍清除本地快取

---

### BlockUserUseCase

#### Basic Flow
- **描述**：成功封鎖用戶
- **輸入**：`userId: "user123"`, `eventId: "event123"`, `timestamp: Date()`
- **預期結果**：成功將用戶加入黑名單 DB

#### Branch Flow - WebSocket Reconnect
- **描述**：WebSocket 重連後同步 blocked user 清單
- **預期結果**：WebSocket 重連時同步黑名單到伺服器

#### Error Flow - Block Failed
- **描述**：封鎖用戶失敗
- **預期結果**：拋出錯誤，顯示錯誤 Toast

---

## WebSocket 測試場景

### WebSocket Connection

#### Basic Flow - Connect
- **描述**：成功建立 WebSocket 連線
- **預期結果**：WebSocket 連線成功，`isWebSocketConnected = true`

#### Error Flow - Connection Failed
- **描述**：WebSocket 連線失敗
- **預期結果**：自動重連（指數退避策略）

#### Recover Flow - Reconnect
- **描述**：WebSocket 連線中斷後重連
- **預期結果**：自動重連成功，同步 blocked user 清單

#### Edge Case - Connection Lost
- **描述**：WebSocket 連線中斷
- **預期結果**：顯示「重新連線中...」狀態，自動重連

### WebSocket Message

#### Basic Flow - Receive Message
- **描述**：成功接收 WebSocket 訊息
- **預期結果**：解析訊息為 `Message`，更新到 State

#### Error Flow - Message Parse Error
- **描述**：訊息解析失敗
- **預期結果**：記錄錯誤日誌，忽略該訊息

#### Edge Case - Duplicate Message
- **描述**：收到重複訊息（相同的 messageNo）
- **預期結果**：去重，不重複顯示

---

## 測試覆蓋率要求

### UseCase 測試覆蓋率

- **基本要求**：≥ 80%
- **關鍵 UseCase**：≥ 90%
  - PublishCommentUseCase
  - SendChatMessageUseCase
  - JoinChatroomUseCase

### 測試類型要求

每個 UseCase 必須包含：
- ✅ Basic Flow 測試
- ✅ Error Flow 測試
- ✅ Edge Case 測試（至少 1 個）

關鍵 UseCase 還需包含：
- ✅ Branch Flow 測試
- ✅ Optional Flow 測試
- ✅ Recover Flow 測試

