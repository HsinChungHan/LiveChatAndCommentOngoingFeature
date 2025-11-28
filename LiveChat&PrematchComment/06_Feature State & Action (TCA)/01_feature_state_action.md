# Feature State & Action (TCA)

## PrematchCommentFeature

### State

```swift
struct PrematchCommentState: Equatable {
    // 資料狀態
    var comments: [Comment] = []  // Comment Entity 陣列（包含 repliesCount、likedByMe、isIsolated、isDeleted 等欄位）
    var commentMeta: CommentMeta?  // 留言統計資訊（commentCount、betCount 為 String）
    var userInfo: UserInfo?  // 用戶資訊（包含 tierLevel、countryCode）
    var pagingInfo: PagingInfo?
    var cursor: Cursor?
    
    // UI 狀態
    var selectedMode: SortMode = .top  // 預設為 top
    var isLoading: Bool = false
    var error: Error?
    
    // 展開的回覆列表（commentId -> [Comment]）
    var expandedReplies: [String: [Comment]] = [:]
    var replyPagingInfo: [String: PagingInfo] = [:]
    
    // Event Status 相關
    var eventStatus: Int?  // 當前 Event Status
    var shouldClosePage: Bool = false  // 當 event status 變為 match_started 時為 true
}
```

### Action

```swift
enum PrematchCommentAction: Equatable {
    // Lifecycle
    case onAppear(refId: String)
    case onDisappear
    
    // 使用者互動
    case tapRefreshButton
    case tapTab(mode: SortMode)
    case tapLikeButton(commentId: String)
    case tapReplyButton(commentId: String)
    case tapLoadMoreReplies(commentId: String)
    case tapUserName(userId: String)
    case tapInputField
    case tapSendButton(content: String, parentId: String?)
    
    // UseCase 回應
    case reloadCommentListResponse(Result<ReloadCommentListOutput, Error>)
    case publishCommentResponse(Result<PublishCommentOutput, Error>)
    case toggleLikeResponse(Result<ToggleLikeOutput, Error>)
    case loadRepliesResponse(Result<LoadRepliesOutput, Error>)
    case navigateToProfileResponse(Result<Void, Error>)
    
    // 系統事件
    case eventStatusChanged(status: Int)  // 來自 FactsCenter Package
}
```

---

## LiveChatFeature

### State

```swift
struct LiveChatState: Equatable {
    // 資料狀態
    var chatroomInfo: ChatroomInfo?  // 聊天室資訊（包含 onlineCount、betCount、chatRoomType、nickNameAvailable）
    var messages: [Message] = []  // Message Entity 陣列（包含 previousMessageNo、isIsolated、isDeleted、status 等欄位）
    var lastMessageNo: Int?  // 最後訊息編號（用於載入歷史訊息）
    
    // UI 狀態
    var isLoading: Bool = false
    var isLoadingHistory: Bool = false
    var error: Error?
    var isChatroomOpen: Bool = false
    
    // WebSocket 狀態
    var isWebSocketConnected: Bool = false
    var webSocketError: Error?
    
    // 黑名單
    var blockedUserIds: Set<String> = []
    
    // 使用者互動狀態
    var selectedUserId: String?  // 用於顯示操作選單
    var showBlockConfirmation: Bool = false
}
```

### Action

```swift
enum LiveChatAction: Equatable {
    // Lifecycle
    case onAppear(refId: String)
    case onDisappear
    
    // 使用者互動
    case tapJoinChatroom
    case tapLeaveChatroom
    case tapInputField
    case tapSendButton(content: String)
    case tapUserName(userId: String)
    case tapBlockUser(userId: String)
    case confirmBlockUser(userId: String)
    case tapScrollToTop  // 載入歷史訊息
    
    // UseCase 回應
    case joinChatroomResponse(Result<JoinChatroomOutput, Error>)
    case leaveChatroomResponse(Result<Void, Error>)
    case sendMessageResponse(Result<SendChatMessageOutput, Error>)
    case navigateToProfileResponse(Result<Void, Error>)
    case blockUserResponse(Result<Void, Error>)
    
    // WebSocket 事件
    case webSocketConnected
    case webSocketDisconnected
    case webSocketError(Error)
    case webSocketMessageReceived(Message)
    
    // 系統事件
    case loadHistoricalMessagesResponse(Result<[Message], Error>)
}
```

---

## State 設計原則

### 1. 只使用 Domain Model

- ✅ **正確**：`var comments: [Comment]`（Entity 陣列）
- ✅ **正確**：`var pagingInfo: PagingInfo?`（Value Object）
- ❌ **錯誤**：`var apiResponse: CommentResponseDTO`（DTO）

### 2. 不依賴 Client / Repository / API

- State 中不應包含任何 Client、Repository 或 API 的引用
- 所有資料存取都透過 UseCase 處理

### 3. UI 狀態與資料狀態分離

- **資料狀態**：comments、messages、pagingInfo 等
- **UI 狀態**：isLoading、error、selectedMode 等

---

## Action 設計原則

### 1. Action 僅代表事件，不包含邏輯

- ✅ **正確**：`case tapLikeButton(commentId: String)`
- ❌ **錯誤**：`case likeComment(commentId: String, shouldIncrement: Bool)`（包含邏輯判斷）

### 2. 區分使用者互動和系統事件

- **使用者互動**：tap、input、select 等
- **Lifecycle**：onAppear、onDisappear
- **系統事件**：WebSocket 訊息、外部通知等
- **UseCase 回應**：所有 UseCase 執行結果

### 3. UseCase 回應命名規範

- 格式：`{useCaseName}Response(Result<{OutputType}, Error>)`
- 範例：`reloadCommentListResponse(Result<ReloadCommentListOutput, Error>)`

