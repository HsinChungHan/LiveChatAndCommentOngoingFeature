# 模組職責說明

## Feature Modules

| 模組名稱 | 層級 | 職責 | 使用的 UseCase | 不包含 |
|---------|------|------|---------------|--------|
| **PrematchCommentFeature** | Domain Layer - Feature Layer | 1. UI orchestration（將 UI event 轉成 Action）<br>2. 將 Action 轉為 UseCase Input<br>3. 呼叫 UseCase<br>4. 接收 UseCase Output 更新 State<br>5. 處理 Event Status 通知 | 1. ReloadCommentListUseCase<br>2. PublishCommentUseCase<br>3. ToggleLikeUseCase<br>4. LoadRepliesUseCase<br>5. NavigateToProfileUseCase | 1. 商業邏輯<br>2. 資料存取邏輯 |
| **LiveChatFeature** | Domain Layer - Feature Layer | 1. UI orchestration（將 UI event 轉成 Action）<br>2. 將 Action 轉為 UseCase Input<br>3. 呼叫 UseCase<br>4. 接收 UseCase Output 更新 State<br>5. 管理 WebSocket 連線狀態 | 1. SendChatMessageUseCase<br>2. JoinChatroomUseCase<br>3. LeaveChatroomUseCase<br>4. NavigateToProfileUseCase<br>5. BlockUserUseCase | 1. 商業邏輯<br>2. 資料存取邏輯 |

## UseCase Modules

| UseCase 名稱 | 層級 | 職責 | Input Model | Output Model | 使用的 Repository | 使用的 Shared Feature |
|-------------|------|------|------------|-------------|------------------|---------------------|
| **ReloadCommentListUseCase** | Domain Layer - UseCase Layer | 1. 載入留言列表<br>2. 支援 top / newest 模式<br>3. 支援初始化、刷新、切換標籤等觸發方式 | 1. `refId: String`<br>2. `triggerType: TriggerType`（init / refresh / switch）<br>3. `mode: SortMode`（top / newest）<br>4. `cursor: Cursor?`（可選） | 1. `comments: [Comment]`<br>2. `pagingInfo: PagingInfo?` | PrematchCommentRepository | - |
| **PublishCommentUseCase** | Domain Layer - UseCase Layer | 1. 發送留言或回覆<br>2. 檢查登入狀態（透過 Main App）<br>3. 檢查 nickname（透過 Main App）<br>4. 若無 nickname 則調用 FComSharedFlow Package 建立 | 1. `refId: String`<br>2. `content: String`<br>3. `parentId: String?`（可選，用於回覆） | 1. `comment: Comment` | PrematchCommentRepository | 1. PersonalPage Package（External）<br>2. FComSharedFlow Package（External） |
| **ToggleLikeUseCase** | Domain Layer - UseCase Layer | 1. 切換 Like 狀態<br>2. 檢查登入狀態（透過 Main App）<br>3. Optimistic UI 更新<br>4. 同步 Like 狀態到伺服器 | 1. `commentId: String` | 1. `comment: Comment`（更新後的 Comment） | PrematchCommentRepository | PersonalPage Package（External） |
| **LoadRepliesUseCase** | Domain Layer - UseCase Layer | 1. 載入回覆列表<br>2. 分頁載入（每次最多 5 筆）<br>3. 使用 cursor 機制追蹤分頁位置 | 1. `commentId: String`<br>2. `cursor: Cursor?`（可選） | 1. `replies: [Comment]`<br>2. `pagingInfo: PagingInfo` | PrematchCommentRepository | - |
| **SendChatMessageUseCase** | Domain Layer - UseCase Layer | 1. 發送聊天訊息<br>2. 檢查登入狀態（透過 Main App）<br>3. 檢查 nickname（透過 Main App）<br>4. 若無 nickname 則調用 FComSharedFlow Package 建立 | 1. `chatroomId: String`<br>2. `content: String`<br>3. `messageType: MessageType` | 1. `message: Message` | LiveChatRepository | 1. PersonalPage Package（External）<br>2. FComSharedFlow Package（External） |
| **JoinChatroomUseCase** | Domain Layer - UseCase Layer | 1. 加入聊天室<br>2. 載入歷史訊息<br>3. 將歷史訊息與 WebSocket 訊息合併<br>4. 依 messageNo 去重 | 1. `refId: String` | 1. `chatroomInfo: ChatroomInfo`<br>2. `messages: [Message]` | LiveChatRepository | - |
| **LeaveChatroomUseCase** | Domain Layer - UseCase Layer | 1. 離開聊天室<br>2. 清除快取的訊息<br>3. 執行黑名單檢查與清理（4 小時自動清理） | 1. `chatroomId: String` | - | LiveChatRepository | - |
| **NavigateToProfileUseCase** | Domain Layer - UseCase Layer | 1. 處理跳轉到個人主頁的邏輯<br>2. 透過 PersonalPageAdapter Protocol 執行路由跳轉 | 1. `userId: String` | - | - | PersonalPageAdapter Protocol |
| **BlockUserUseCase** | Domain Layer - UseCase Layer | 1. 處理封鎖用戶的邏輯<br>2. 將該用戶加入黑名單 DB<br>3. WebSocket 重連後同步 blocked user 清單 | 1. `userId: String`<br>2. `eventId: String`<br>3. `timestamp: Date` | - | LiveChatRepository | - |

## Repository Modules

| Repository 名稱 | 層級 | 職責 | 提供的方法 | 使用的 Client | 被使用的 Feature | 備註 |
|----------------|------|------|----------|--------------|----------------|------|
| **PrematchCommentRepository** | Data & Infrastructure Layer - Repository Layer | 1. Domain 資料來源的抽象介面（評論相關）<br>2. 呼叫 Client 取得或更新遠端資料<br>3. 負責將 DTO 轉換為 Domain Model | 1. `getUserInfo() async throws -> UserInfo`<br>2. `getCommentMeta(refId: String) async throws -> CommentMeta`<br>3. `getComments(refId: String, mode: SortMode, cursor: Cursor?) async throws -> ([Comment], PagingInfo)`<br>4. `publishComment(refId: String, content: String, parentId: String?) async throws -> Comment`<br>5. `toggleLike(commentId: String) async throws -> Comment`<br>6. `getReplies(commentId: String, cursor: Cursor?) async throws -> ([Comment], PagingInfo)` | PrematchCommentClient | PrematchCommentFeature | 所有方法都負責 DTO → Domain Model 轉換 |
| **LiveChatRepository** | Data & Infrastructure Layer - Repository Layer | 1. Domain 資料來源的抽象介面（聊天室相關）<br>2. 呼叫 Client 取得或更新遠端資料<br>3. 負責將 DTO 轉換為 Domain Model<br>4. 管理 WebSocket 連線 | 1. `getChatroomInfo(refId: String) async throws -> ChatroomInfo`<br>2. `joinChatroom(chatroomId: String) async throws -> Void`<br>3. `loadHistoricalMessages(chatroomId: String, lastMessageNo: Int) async throws -> [Message]`<br>4. `sendMessage(chatroomId: String, content: String, messageType: MessageType) async throws -> Message`<br>5. `leaveChatroom(chatroomId: String) async throws -> Void`<br>6. `subscribeWebSocket() async throws -> Void`<br>7. `unsubscribeWebSocket() async throws -> Void` | LiveChatClient<br>ChatWebSocketClient | LiveChatFeature | 1. 所有方法都負責 DTO → Domain Model 轉換<br>2. WebSocket 連線管理 |

## Client Modules

| Client 名稱 | 層級 | 技術 | 職責 | 使用的 API | 被使用的 Feature | 備註 |
|------------|------|------|------|----------|----------------|------|
| **PrematchCommentClient** | Data & Infrastructure Layer - Client Layer | HTTP | 1. HTTP 通訊（評論相關）<br>2. Request / Response 編解碼<br>3. 錯誤處理 | PrematchCommentAPI | PrematchCommentFeature | - |
| **LiveChatClient** | Data & Infrastructure Layer - Client Layer | HTTP | 1. HTTP 通訊（聊天室相關）<br>2. Request / Response 編解碼<br>3. 錯誤處理 | ChatAPI | LiveChatFeature | - |
| **ChatWebSocketClient** | Data & Infrastructure Layer - Client Layer | WebSocket | 1. WebSocket 通訊（即時訊息）<br>2. 訂閱 / 取消訂閱<br>3. 訊息接收與發送<br>4. 連線管理（重連、心跳等） | ChatAPI | LiveChatFeature | 1. WebSocket 端點：wss://www.encorebet.net/chat/websocket/web-chat<br>2. 支援重連機制 |

## API Modules

| API 名稱 | 層級 | 職責 | Endpoints | 只能被 | 被使用的 Feature | 備註 |
|---------|------|------|----------|--------|----------------|------|
| **PrematchCommentAPI** | Data & Infrastructure Layer - API Layer | 後端 endpoint 定義（評論相關） | 1. `POST /chat/match/comment/batch/info`<br>2. `GET /chat/match/comment/info/{refId}`<br>3. `GET /chat/match/comment/popular`<br>4. `GET /chat/match/comment/newest`<br>5. `GET /chat/match/comment/replies`<br>6. `POST /chat/match/comment`<br>7. `POST /chat/match/comment/like` | PrematchCommentClient | PrematchCommentFeature | 1. 批量 API 用於批量獲取評論資訊 |
| **ChatAPI** | Data & Infrastructure Layer - API Layer | 後端 endpoint 定義（聊天室相關） | 1. `POST /chat/match/batch/count`<br>2. `GET /chat/match/{refId}`<br>3. `GET /chat/match/backward`<br>4. `POST /chat/match/message`<br>5. `wss://{domain}/chat/websocket/web-chat`（WebSocket） | LiveChatClient<br>ChatWebSocketClient | LiveChatFeature | 1. WebSocket 端點用於即時訊息傳遞<br>2. 僅支援 TEXT 類型的訊息 |

## Shared Modules

| Shared Module 名稱 | 層級 | 職責 | 提供的方法 | 被使用的 Feature | 共用原因 |
|------------------|------|------|----------|----------------|---------|
| **PersonalPage Package（External）** | External Package | 1. 登入流程<br>2. 用戶認證 | 1. `route(to: .personalPage)`<br>2. 登入完成後回跳至原頁面 | 1. PrematchCommentFeature<br>2. LiveChatFeature | 1. 用戶身份認證<br>2. 登入狀態檢查 |
| **FComSharedFlow Package（External）** | External Package | 1. Nickname 建立流程<br>2. 顯示 create nickName pop-up | 1. `CreatNickName API` | 1. PrematchCommentFeature<br>2. LiveChatFeature | 1. Nickname 管理<br>2. 用戶資訊建立 |
| **FactsCenter Package（External）** | External Package | 1. Event Status 訂閱<br>2. Event Status 通知 | 1. `eventStatus(didChange status: Int)`（interface） | PrematchCommentFeature | 1. Event Status 管理<br>2. 賽事狀態同步 |

## 模組收斂說明

### Repository 收斂

- **PrematchCommentRepository**：收斂所有評論相關的讀寫操作（getComments、publishComment、toggleLike、getReplies 等）
- **LiveChatRepository**：收斂所有聊天室相關的讀寫操作（getChatroomInfo、joinChatroom、sendMessage 等）

### Client 收斂

- **PrematchCommentClient**：收斂所有評論相關的 HTTP 通訊
- **LiveChatClient**：收斂所有聊天室相關的 HTTP 通訊
- **ChatWebSocketClient**：獨立於 HTTP Client，專門處理 WebSocket 通訊

### UseCase 收斂

- **ReloadCommentListUseCase**：收斂所有載入留言列表的行為（初始化、刷新、切換標籤），使用 Input Model 的 `triggerType` 和 `mode` 區分行為
- **PublishCommentUseCase**：收斂發送留言和回覆的行為，使用 Input Model 的 `parentId` 區分是留言還是回覆

