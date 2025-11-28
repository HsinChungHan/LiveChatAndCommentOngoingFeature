# API Spec & Mapping

## PrematchCommentAPI

### POST /chat/match/comment/batch/info

**所屬 UseCase**：ReloadCommentListUseCase（批量獲取評論資訊）

**HTTP Method**：POST

**URL**：`/chat/match/comment/batch/info`

**Request DTO**：
```swift
struct BatchCommentInfoRequestDTO: Codable {
    let refIdList: [String]
}
```

**Response DTO**：
```swift
struct BatchCommentInfoResponseDTO: Codable {
    let bizCode: Int
    let innerMsg: String?
    let message: String?
    let data: [CommentMetaInfoDTO]
}

struct CommentMetaInfoDTO: Codable {
    let refId: String
    let commentCount: String
    let betCount: String
}
```

**Mapping**：
```swift
extension CommentMeta {
    init(from dto: CommentMetaInfoDTO) {
        self.id = dto.refId
        self.commentCount = Int(dto.commentCount) ?? 0
        self.betCount = dto.betCount
        self.refId = dto.refId
    }
}
```

**呼叫鏈**：ReloadCommentListUseCase → PrematchCommentRepository → PrematchCommentClient → PrematchCommentAPI

---

### GET /chat/match/comment/info/{refId}

**所屬 UseCase**：ReloadCommentListUseCase（初始化時）

**HTTP Method**：GET

**URL**：`/chat/match/comment/info/{refId}`

**Request**：
- Path Parameter：`refId: String`

**Response DTO**：
```swift
struct CommentMetaResponseDTO: Codable {
    let bizCode: Int
    let innerMsg: String?
    let message: String?
    let data: CommentMetaDataDTO
}

struct CommentMetaDataDTO: Codable {
    let refId: String
    let commentCount: String
    let betCount: String
}
```

**Mapping**：
```swift
extension CommentMeta {
    init(from dto: CommentMetaDataDTO) {
        self.id = dto.refId
        self.commentCount = Int(dto.commentCount) ?? 0
        self.betCount = dto.betCount
        self.refId = dto.refId
    }
}
```

**呼叫鏈**：ReloadCommentListUseCase → PrematchCommentRepository → PrematchCommentClient → PrematchCommentAPI

---

### GET /chat/match/comment/popular

**所屬 UseCase**：ReloadCommentListUseCase（mode = .top）

**HTTP Method**：GET

**URL**：`/chat/match/comment/popular`

**Request**：
- Query Parameter：`refId: String`
- Query Parameter：`pageNum: Int?`（可選，預設 1，用於分頁）
- Query Parameter：`pageSize: Int?`（可選，預設 10，每頁返回的評論數）

**Response DTO**：
```swift
struct CommentListResponseDTO: Codable {
    let bizCode: Int
    let innerMsg: String?
    let message: String?
    let data: [CommentDTO]
}

struct CommentDTO: Codable {
    let id: Int64
    let parentId: Int64  // 0 表示第一層評論
    let sharedBetsMeta: String?  // 共享投注資訊（自訂 JSON 格式）
    let userId: String
    let userNickname: String
    let userTierLevel: String
    let userAvatar: String
    let countryCode: String
    let comment: String
    let isIsolated: Bool
    let isDeleted: Bool
    let likedCount: Int
    let repliesCount: Int
    let likedByMe: Bool
    let createTime: Int64  // 時間戳
    let tagUserId: String?
    let tagUserNickname: String?
}
```

**Mapping**：
```swift
extension Comment {
    init(from dto: CommentDTO) {
        self.id = "\(dto.id)"
        self.content = dto.comment
        self.likeCount = dto.likedCount
        self.authorId = dto.userId
        self.authorNickname = dto.userNickname
        self.parentId = dto.parentId == 0 ? nil : "\(dto.parentId)"
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(dto.createTime) / 1000)
        self.refId = ""  // 需要從 UseCase 層傳入
        self.repliesCount = dto.repliesCount
        self.likedByMe = dto.likedByMe
        self.isIsolated = dto.isIsolated
        self.isDeleted = dto.isDeleted
    }
}
```

**呼叫鏈**：ReloadCommentListUseCase → PrematchCommentRepository → PrematchCommentClient → PrematchCommentAPI

---

### GET /chat/match/comment/newest

**所屬 UseCase**：ReloadCommentListUseCase（mode = .newest）

**HTTP Method**：GET

**URL**：`/chat/match/comment/newest`

**Request**：
- Query Parameter：`refId: String`
- Query Parameter：`prevCommentId: Int64?`（可選，上一個評論的 ID，用於分頁）
- Query Parameter：`pageSize: Int?`（可選，預設 10，每頁返回的評論數）

**Response DTO**：同 `GET /chat/match/comment/popular`

**Mapping**：同 `GET /chat/match/comment/popular`

**呼叫鏈**：ReloadCommentListUseCase → PrematchCommentRepository → PrematchCommentClient → PrematchCommentAPI

---

### POST /chat/match/comment

**所屬 UseCase**：PublishCommentUseCase

**HTTP Method**：POST

**URL**：`/chat/match/comment`

**Request DTO**：
```swift
struct PublishCommentRequestDTO: Codable {
    let refId: String
    let parentCommentId: Int64?  // 可選，父評論 ID（如果是回覆）
    let sharedBetsMeta: [String: AnyCodable]?  // 可選，共享投注資訊（自訂 JSON 格式）
    let comment: String
    let tagUserId: String?  // 可選，被標記的用戶 ID
}
```

**Response DTO**：
```swift
struct CommentResponseDTO: Codable {
    let bizCode: Int
    let innerMsg: String?
    let message: String?
    let data: CommentDTO  // 同 CommentDTO 結構
}
```

**Mapping**：
```swift
extension Comment {
    init(from dto: CommentDTO) {
        // 同 GET /chat/match/comment/popular 的 Mapping
    }
}
```

**呼叫鏈**：PublishCommentUseCase → PrematchCommentRepository → PrematchCommentClient → PrematchCommentAPI

---

### POST /chat/match/comment/like

**所屬 UseCase**：ToggleLikeUseCase

**HTTP Method**：POST

**URL**：`/chat/match/comment/like`

**Request DTO**：
```swift
struct ToggleLikeRequestDTO: Codable {
    let commentId: Int64?
}
```

**Response DTO**：同 `POST /chat/match/comment` 的 Response

**Mapping**：同 `POST /chat/match/comment`

**呼叫鏈**：ToggleLikeUseCase → PrematchCommentRepository → PrematchCommentClient → PrematchCommentAPI

---

### GET /chat/match/comment/replies

**所屬 UseCase**：LoadRepliesUseCase

**HTTP Method**：GET

**URL**：`/chat/match/comment/replies`

**Request**：
- Query Parameter：`parentCommentId: Int64`（父評論 ID，第一層評論的 ID）
- Query Parameter：`prevCommentId: Int64?`（可選，上一個評論的 ID，用於分頁）
- Query Parameter：`pageSize: Int?`（可選，預設 5，每頁返回的回覆數）

**Response DTO**：同 `GET /chat/match/comment/popular`

**Mapping**：同 `GET /chat/match/comment/popular`

**呼叫鏈**：LoadRepliesUseCase → PrematchCommentRepository → PrematchCommentClient → PrematchCommentAPI

---

## ChatAPI

### POST /chat/match/batch/count

**所屬 UseCase**：JoinChatroomUseCase（批量獲取聊天室計數）

**HTTP Method**：POST

**URL**：`/chat/match/batch/count`

**Request DTO**：
```swift
struct BatchChatRoomCountRequestDTO: Codable {
    let refIdList: [String]
}
```

**Response DTO**：
```swift
struct BatchChatRoomCountResponseDTO: Codable {
    let bizCode: Int
    let innerMsg: String?
    let message: String?
    let data: [ChatRoomCountDTO]
}

struct ChatRoomCountDTO: Codable {
    let refId: String
    let onlineCount: String
    let betCount: String
}
```

**Mapping**：
```swift
extension ChatroomInfo {
    init(from dto: ChatRoomCountDTO) {
        self.id = dto.refId  // 使用 refId 作為 id
        self.chatroomId = ""  // 批量 API 不返回 chatroomId
        self.lastMessageNo = 0  // 批量 API 不返回 lastMessageNo
        self.refId = dto.refId
        self.onlineCount = Int(dto.onlineCount) ?? 0
        self.betCount = dto.betCount
        self.chatRoomType = 10  // 預設為 GROUP
        self.nickNameAvailable = nil  // 批量 API 不返回此欄位
    }
}
```

**呼叫鏈**：JoinChatroomUseCase → LiveChatRepository → LiveChatClient → ChatAPI

---

### GET /chat/match/{refId}

**所屬 UseCase**：JoinChatroomUseCase

**HTTP Method**：GET

**URL**：`/chat/match/{refId}`

**Description**：獲取或創建聊天室 ID。如果聊天室不存在則創建。

**Request**：
- Path Parameter：`refId: String`（事件 ID，全域唯一，重複的 ID 將返回相同的聊天室 ID）
- Query Parameter：`userId: String?`（可選，用於檢查用戶的暱稱是否存在。如果未提供，nickNameAvailable 在回應中始終為 true）

**Response DTO**：
```swift
struct ChatroomInfoResponseDTO: Codable {
    let bizCode: Int
    let innerMsg: String?
    let message: String?
    let data: ChatroomInfoDataDTO
}

struct ChatroomInfoDataDTO: Codable {
    let id: Int
    let chatRoomId: String
    let chatRoomType: Int  // 目前僅使用 GROUP(10)
    let lastMessageNo: Int
    let createTime: String  // ISO 8601 格式，例如："2025-02-12T09:31:36.000+00:00"
    let updateTime: String?
    let creatorUserId: String
    let name: String?  // 聊天室名稱
    let avatarUrl: String?  // 頭像 URL
    let evatorUrl: String?
    let bizUserId: String
    let refId: String
    let onlineCount: String
    let betCount: String
    let nickNameAvailable: Bool?  // 暱稱是否可用
}
```

**Mapping**：
```swift
extension ChatroomInfo {
    init(from dto: ChatroomInfoDataDTO) {
        self.id = dto.chatRoomId
        self.chatroomId = dto.chatRoomId
        self.lastMessageNo = dto.lastMessageNo
        self.refId = dto.refId
        self.onlineCount = Int(dto.onlineCount) ?? 0
        self.betCount = dto.betCount
        self.chatRoomType = dto.chatRoomType
        self.nickNameAvailable = dto.nickNameAvailable
    }
}
```

**呼叫鏈**：JoinChatroomUseCase → LiveChatRepository → LiveChatClient → ChatAPI

---

### GET /chat/match/backward

**所屬 UseCase**：JoinChatroomUseCase（獲取歷史消息）

**HTTP Method**：GET

**URL**：`/chat/match/backward`

**Request**：
- Query Parameter：`chatRoomId: String`
- Query Parameter：`messageNo: Int`（Previous messageNo，可從 Step 1 API 的 lastMessageNo 取得）
- Query Parameter：`length: Int?`（可選，預設 20，最大值 500）

**Response DTO**：
```swift
struct MessageListResponseDTO: Codable {
    let bizCode: Int
    let innerMsg: String?
    let message: String?
    let data: [MessageDTO]
}

struct MessageDTO: Codable {
    let chatRoomId: String
    let chatRoomType: Int?
    let messageNo: Int
    let previousMessageNo: Int
    let postUserId: String
    let jsonBody: MessageBodyDTO
    let sharedBetsMeta: String?
    let status: Int
    let isIsolated: Bool
    let isDeleted: Bool
    let createTime: Int64
    let userInfo: UserInfoDTO
}

struct MessageBodyDTO: Codable {
    let text: String?  // TEXT 消息的內容
}

struct UserInfoDTO: Codable {
    let nickname: String
    let avatar: String
    let country: String
    let tierLevel: String?  // 注意：apiFlow.md 中使用 "tieLevel"，但實際可能是 "tierLevel"
}
```

**Mapping**：
```swift
extension Message {
    init(from dto: MessageDTO) {
        self.id = "\(dto.messageNo)"
        self.content = dto.jsonBody.text ?? ""
        self.messageNo = dto.messageNo
        self.previousMessageNo = dto.previousMessageNo
        self.authorId = dto.postUserId
        self.authorNickname = dto.userInfo.nickname
        self.messageType = .text  // 僅支援 TEXT 類型
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(dto.createTime) / 1000)
        self.chatroomId = dto.chatRoomId
        self.isIsolated = dto.isIsolated
        self.isDeleted = dto.isDeleted
        self.status = dto.status
    }
}
```

**呼叫鏈**：JoinChatroomUseCase → LiveChatRepository → LiveChatClient → ChatAPI

---

### POST /chat/match/message

**所屬 UseCase**：SendChatMessageUseCase

**HTTP Method**：POST

**URL**：`/chat/match/message`

**Request Headers**：
- `accessToken: String`（可選，優先級高於 Cookie）
- `Cookie: String`（必須包含 accessToken 欄位）
- `countryCode: String`

**Request DTO**：
```swift
struct SendMessageRequestDTO: Codable {
    let text: String  // TEXT 消息內容
    let messageType: String  // 固定為 "TEXT"
    let chatRoomId: String
}
```

**Response DTO**：
```swift
struct SendMessageResponseDTO: Codable {
    let bizCode: Int
    let innerMsg: String?
    let message: String?
    let data: MessageResponseDataDTO
}

struct MessageResponseDataDTO: Codable {
    let msgType: Int  // 1 表示 TEXT
    let userId: String?
    let messageNo: Int?
    let previousMessageNo: Int?
    let jsonBody: MessageBodyWrapperDTO
    let sharedBetsMeta: String?
    let isIsolated: Bool
    let status: Int
}

struct MessageBodyWrapperDTO: Codable {
    let postUserId: String
    let userInfo: UserInfoDTO
    let messageNo: Int
    let isDeleted: Bool
    let createTime: Int64
    let previousMessageNo: Int
    let chatRoomId: String
    let chatRoomType: Int
    let jsonBody: MessageBodyDTO  // 僅包含 text 欄位
    let sharedBetsMeta: String?
    let isIsolated: Bool
    let status: Int
}
```

**Mapping**：
```swift
extension Message {
    init(from dto: MessageResponseDataDTO) {
        self.id = dto.jsonBody.messageNo.map { "\($0)" } ?? ""
        self.content = dto.jsonBody.jsonBody.text ?? ""
        self.messageNo = dto.jsonBody.messageNo
        self.previousMessageNo = dto.jsonBody.previousMessageNo
        self.authorId = dto.jsonBody.postUserId
        self.authorNickname = dto.jsonBody.userInfo.nickname
        self.messageType = .text  // 僅支援 TEXT 類型
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(dto.jsonBody.createTime) / 1000)
        self.chatroomId = dto.jsonBody.chatRoomId
        self.isIsolated = dto.jsonBody.isIsolated
        self.isDeleted = dto.jsonBody.isDeleted
        self.status = dto.jsonBody.status
    }
}
```

**呼叫鏈**：SendChatMessageUseCase → LiveChatRepository → LiveChatClient → ChatAPI

---

### WebSocket: wss://{domain}/chat/websocket/web-chat

**所屬 UseCase**：JoinChatroomUseCase（訂閱）、LeaveChatroomUseCase（取消訂閱）

**Protocol**：WebSocket

**URL**：`wss://{domain}/chat/websocket/web-chat`

**Connect Message**：
```
CONNECT
accept-version:1,2,1,1,1.0
heart-beat:4000,4000
```

**Subscribe Message**：
- 連線後發送 SUBSCRIBE 訊息訂閱特定聊天室
- Destination 格式：`/topic/chat_room.{chatRoomId}`

**Subscribe Message Format**：
```
SUBSCRIBE
id:sub-1
destination:/topic/chat_room.{chatRoomId}
```

**Example**：
```
SUBSCRIBE
id:sub-1
destination:/topic/chat_room.25B0107060721room0000175
```

**Receive Message Format**：
```
MESSAGE
subscription:sub-1
destination:/topic/chat_room.{chatRoomId}
message-id:{message-id}
redelivered:false
content-type:application/json
content-length:{length}

{"type":"MESSAGE","data":{...}}
```

**Message Type**：
```swift
struct WebSocketMessageDTO: Codable {
    let type: String  // "MESSAGE"
    let data: MessageResponseDataDTO  // 與 POST /chat/match/message 的 Response 格式相同
}
```

**注意**：WebSocket 接收到的訊息格式與 HTTP API 的 `MessageResponseDataDTO` 相同，但僅包含 TEXT 類型的消息。

**Unsubscribe**：
- 關閉 WebSocket 連線即取消訂閱

**Mapping**：
```swift
extension Message {
    init(from dto: MessageDTO) {
        // 同 HTTP API 的 Mapping
    }
}
```

**呼叫鏈**：JoinChatroomUseCase → LiveChatRepository → ChatWebSocketClient → ChatAPI

---

## Mapping 原則

### 1. Repository 負責所有 Mapping

- 所有 DTO → Domain Model 的轉換都在 Repository 層完成
- UseCase 和 Feature 永遠不接觸 DTO

### 2. 使用 Extension 實作 Mapping

- 為每個 Domain Model 建立 `init(from dto: DTO)` extension
- 保持 Domain Model 的純淨性

### 3. 處理可選值和預設值

- 日期字串轉換失敗時使用當前時間
- Optional 欄位正確處理 nil 情況

### 4. 保持 Mapping 邏輯簡單

- 避免複雜的業務邏輯
- 複雜轉換應在 UseCase 層處理

