# UseCase Input & Output Model

## PrematchComment UseCases

### ReloadCommentListUseCase

#### Input

```swift
struct ReloadCommentListInput: Equatable {
    let refId: String
    let triggerType: TriggerType  // init / refresh / switch
    let mode: SortMode  // top / newest
    let cursor: Cursor?  // 可選，用於分頁
}

enum TriggerType: String, Equatable {
    case init  // 初始化載入
    case refresh  // 手動刷新
    case switch  // 切換標籤
}
```

#### Output

```swift
struct ReloadCommentListOutput: Equatable {
    let comments: [Comment]
    let pagingInfo: PagingInfo?
}
```

---

### PublishCommentUseCase

#### Input

```swift
struct PublishCommentInput: Equatable {
    let refId: String
    let content: String
    let parentId: String?  // 可選，用於回覆
}
```

#### Output

```swift
struct PublishCommentOutput: Equatable {
    let comment: Comment
}
```

---

### ToggleLikeUseCase

#### Input

```swift
struct ToggleLikeInput: Equatable {
    let commentId: String
}
```

#### Output

```swift
struct ToggleLikeOutput: Equatable {
    let comment: Comment  // 更新後的 Comment
}
```

---

### LoadRepliesUseCase

#### Input

```swift
struct LoadRepliesInput: Equatable {
    let commentId: String
    let cursor: Cursor?  // 可選，用於分頁
}
```

#### Output

```swift
struct LoadRepliesOutput: Equatable {
    let replies: [Comment]
    let pagingInfo: PagingInfo
}
```

---

### NavigateToProfileUseCase

#### Input

```swift
struct NavigateToProfileInput: Equatable {
    let userId: String
}
```

#### Output

```swift
struct NavigateToProfileOutput: Equatable {
    // 無回傳值，路由跳轉成功即可
}
```

---

## LiveChat UseCases

### SendChatMessageUseCase

#### Input

```swift
struct SendChatMessageInput: Equatable {
    let chatroomId: String
    let content: String
    let messageType: MessageType
}

enum MessageType: String, Equatable {
    case text
    // 未來可擴展其他類型
}
```

#### Output

```swift
struct SendChatMessageOutput: Equatable {
    let message: Message
}
```

---

### JoinChatroomUseCase

#### Input

```swift
struct JoinChatroomInput: Equatable {
    let refId: String
}
```

#### Output

```swift
struct JoinChatroomOutput: Equatable {
    let chatroomInfo: ChatroomInfo
    let messages: [Message]  // 歷史訊息
}
```

---

### LeaveChatroomUseCase

#### Input

```swift
struct LeaveChatroomInput: Equatable {
    let chatroomId: String
}
```

#### Output

```swift
struct LeaveChatroomOutput: Equatable {
    // 無回傳值，離開成功即可
}
```

---

### BlockUserUseCase

#### Input

```swift
struct BlockUserInput: Equatable {
    let userId: String
    let eventId: String
    let timestamp: Date
}
```

#### Output

```swift
struct BlockUserOutput: Equatable {
    // 無回傳值，封鎖成功即可
}
```

---

## Input/Output Model 設計原則

### 1. 只使用 Domain Model

- ✅ **正確**：`let comments: [Comment]`（Entity 陣列）
- ✅ **正確**：`let mode: SortMode`（Value Object）
- ✅ **正確**：`let cursor: Cursor?`（Value Object）
- ❌ **錯誤**：`let requestDTO: CommentRequestDTO`（DTO）

### 2. Input Model 表達所有可變因素

- 使用 `triggerType` 區分不同的觸發方式（init / refresh / switch）
- 使用 `mode` 區分不同的排序方式（top / newest）
- 使用 `cursor` 處理分頁

### 3. Output Model 貼近 UI 所需

- 包含 Domain Model（如 comments、messages）
- 包含 UI 所需的 meta（如 pagingInfo、hasMore）
- 不包含 DTO 或技術細節

### 4. 可選參數使用 Optional

- 分頁相關參數使用 `Cursor?`
- 回覆相關參數使用 `parentId: String?`

