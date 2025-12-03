# API Spec Review Report

> **Review 日期**: 2025-12-03  
> **基準文件**: `08_API Spec & Mapping/01_api_spec.md`  
> **Review 範圍**: 所有 TDDs 文件與新 API Spec 的一致性檢查

---

## 📋 執行摘要

本次 review 以更新後的 `01_api_spec.md` 為基準，檢查其他 TDD 文件的一致性。新 API Spec 基於實際的 API 文檔（FComAPI_Documentation.md 和 LiveChat_API_Documentation.md），並應用了過濾規則。

---

## 🔍 發現的不一致問題

### 1. TDD-010: PrematchCommentAPI

#### ❌ 問題 1: Endpoint 定義不一致

**新 API Spec 中的 Endpoints**:
- `POST /chat/match/comment/batch/info` (批量獲取)
- `GET /chat/match/comment/info/{refId}` (單個獲取)
- `GET /chat/match/comment/popular` (熱度排序)
- `GET /chat/match/comment/newest` (最新排序)
- `GET /chat/match/comment/replies` (回覆列表)
- `POST /chat/match/comment` (發佈評論)
- `POST /chat/match/comment/like` (點讚)

**TDD-010 中的 Endpoint 定義問題**:

1. **`getCommentMeta` endpoint 定義錯誤**:
   - **TDD-010 Code Example** (第 86-87 行):
     ```swift
     case .getCommentMeta:
         return "\(base)/batch/info"
     ```
   - **問題**: 
     - Method 定義為 `GET` (第 101 行)，但實際 API 是 `POST`
     - 參數定義為 `refId: String` (第 119 行)，但實際 API 需要 `refIdList: [String]`
   - **應修正為**:
     ```swift
     case .getBatchCommentInfo(let refIdList):
         return "\(base)/batch/info"
     // Method: POST
     // Parameters: ["refIdList": refIdList]
     ```

2. **`getComments` endpoint 定義不完整**:
   - **TDD-010 Code Example** (第 88-89 行):
     ```swift
     case .getComments:
         return "\(base)/info/{refId}"
     ```
   - **問題**: 
     - 新 API Spec 中有三個不同的 endpoints：
       - `GET /chat/match/comment/info/{refId}` (獲取單個評論資訊)
       - `GET /chat/match/comment/popular` (熱度排序)
       - `GET /chat/match/comment/newest` (最新排序)
     - TDD-010 只定義了一個 `getComments`，無法區分這三個不同的 API
   - **應修正為**: 需要定義三個不同的 endpoints

3. **`getReplies` endpoint 參數不一致**:
   - **TDD-010 Code Example** (第 135-140 行):
     ```swift
     case .getReplies(let commentId, let cursor):
         var params: [String: Any] = ["commentId": commentId]
     ```
   - **新 API Spec**: `GET /chat/match/comment/replies` 使用 `parentCommentId` 作為 query parameter
   - **應修正為**: 參數名稱應為 `parentCommentId` 而非 `commentId`

#### ❌ 問題 2: DTO 結構不一致

**新 API Spec 中的 CommentDTO**:
```swift
struct CommentDTO: Codable {
    let id: Int64
    let parentId: Int64  // 0 表示第一層評論
    let sharedBetsMeta: String?  // 共享投注資訊（自訂 JSON 格式）
    let userId: String
    let userNickname: String
    let userTierLevel: String
    let userAvatar: String
    let countryCode: String
    let comment: String  // 注意：欄位名稱是 "comment" 而非 "content"
    let isIsolated: Bool
    let isDeleted: Bool
    let likedCount: Int
    let repliesCount: Int
    let likedByMe: Bool
    let createTime: Int64  // 時間戳（毫秒）
    let tagUserId: String?
    let tagUserNickname: String?
}
```

**TDD-010 Code Example 中的 CommentDTO** (第 152-184 行):
```swift
public struct CommentDTO: Decodable, Sendable {
    public let id: Int64
    public let content: String  // ❌ 應為 "comment"
    public let likeCount: Int  // ❌ 應為 "likedCount"
    public let authorId: String  // ❌ 應為 "userId"
    public let authorNickname: String?  // ❌ 應為 "userNickname"
    public let parentId: Int64
    public let createdAt: Int64  // ❌ 應為 "createTime"
    // ❌ 缺少: sharedBetsMeta, userTierLevel, userAvatar, countryCode, tagUserId, tagUserNickname
}
```

**應修正**: DTO 結構需要完全對齊新 API Spec 的 Response Example。

---

### 2. TDD-011: ChatAPI

#### ❌ 問題 1: 缺少 Endpoints

**新 API Spec 中的 Endpoints**:
- `POST /chat/match/batch/count` ✅
- `GET /chat/match/{refId}` ✅
- `GET /chat/match/backward` ✅
- `POST /chat/match/message` ✅
- `POST /chat/match/join` ❌ **缺少**
- `POST /chat/match/leave` ❌ **缺少**
- `POST /chat/match/leave/bulk` ❌ **缺少**
- `wss://{domain}/chat/websocket/web-chat` ✅

**TDD-011 中列出的 Endpoints** (第 35-39 行):
- `POST /chat/match/batch/count` ✅
- `GET /chat/match/{refId}` ✅
- `GET /chat/match/backward` ✅
- `POST /chat/match/message` ✅
- `wss://{domain}/chat/websocket/web-chat` ✅

**缺少的 Endpoints**:
- `POST /chat/match/join` (可選操作)
- `POST /chat/match/leave` (可選操作)
- `POST /chat/match/leave/bulk` (批量強制離開)

**建議**: 雖然這些是可選操作，但應在 TDD-011 中列出，或在相關 UseCase tickets 中說明。

#### ❌ 問題 2: WebSocket 訊息格式說明不完整

**新 API Spec 中的 WebSocket 規格**:
- 詳細的 Connect Headers (Platform, App-Version, Device-Id, userId)
- Subscribe Headers (x-queue-name)
- Unsubscribe Format
- Message Types (msgType: 1=TEXT, 4=JSON, 5=GIF)
- 完整的 Response Example

**TDD-011 中的說明**: 僅提到 "定義 WebSocket 端點和訊息格式"，但沒有詳細規格。

**建議**: 應在 TDD-011 中補充 WebSocket 的詳細規格，或明確引用 API Spec 文件。

---

### 3. TDD-020: PrematchCommentClient

#### ❌ 問題 1: 方法定義不完整

**新 API Spec 中的 API**:
- `POST /chat/match/comment/batch/info` → `getBatchCommentInfo(refIdList: [String])`
- `GET /chat/match/comment/info/{refId}` → `getCommentMeta(refId: String)`
- `GET /chat/match/comment/popular` → `getComments(refId: String, mode: "popular", pageNum: Int?, pageSize: Int?)`
- `GET /chat/match/comment/newest` → `getComments(refId: String, mode: "newest", prevCommentId: Int64?, pageSize: Int?)`
- `GET /chat/match/comment/replies` → `getReplies(parentCommentId: Int64, prevCommentId: Int64?, pageSize: Int?)`
- `POST /chat/match/comment` → `publishComment(refId: String, content: String, parentId: Int64?, ...)`
- `POST /chat/match/comment/like` → `toggleLike(commentId: Int64)`

**TDD-020 Code Example 中的方法** (第 51-59 行):
```swift
public func getCommentMeta(refId: String) async throws -> PrematchCommentAPI.CommentMetaDTO
public func getComments(refId: String, mode: String, cursor: Int?) async throws -> PrematchCommentAPI.CommentPageDTO
// 其他方法...
```

**問題**:
1. 缺少 `getBatchCommentInfo` 方法（對應 `POST /chat/match/comment/batch/info`）
2. `getComments` 的參數定義不完整：
   - `mode = "popular"` 時需要 `pageNum: Int?`
   - `mode = "newest"` 時需要 `prevCommentId: Int64?`
3. `getReplies` 的參數應為 `parentCommentId: Int64` 而非 `commentId: String`
4. `publishComment` 的參數應包含 `tagUserId: String?` 和 `sharedBetsMeta`
5. `toggleLike` 的參數應為 `commentId: Int64` 而非 `String`

**建議**: 更新 TDD-020 的方法定義以對齊新 API Spec。

---

### 4. TDD-021: LiveChatClient

#### ❌ 問題 1: 方法定義不完整

**新 API Spec 中的 API**:
- `POST /chat/match/batch/count` → `getBatchCount(refIdList: [String])`
- `GET /chat/match/{refId}` → `getChatroomInfo(refId: String, userId: String?)`
- `GET /chat/match/backward` → `getHistoricalMessages(chatroomId: String, messageNo: Int, length: Int?)`
- `POST /chat/match/message` → `sendMessage(chatroomId: String, text: String)`
- `POST /chat/match/join` → `joinChatroom(chatroomId: String)` ❌ **缺少**
- `POST /chat/match/leave` → `leaveChatroom(chatroomId: String)` ❌ **缺少**
- `POST /chat/match/leave/bulk` → `bulkLeaveChatroom(chatroomId: String, excludeUserIds: [String]?)` ❌ **缺少**

**TDD-021 Code Example 中的方法** (第 51-56 行):
```swift
public func getChatroomInfo(refId: String) async throws -> ChatAPI.ChatroomInfoDTO
// 其他方法...
```

**問題**:
1. 缺少 `getBatchCount` 方法（對應 `POST /chat/match/batch/count`）
2. `getChatroomInfo` 缺少可選的 `userId` 參數
3. 缺少 `joinChatroom`、`leaveChatroom`、`bulkLeaveChatroom` 方法

**建議**: 更新 TDD-021 的方法定義以對齊新 API Spec。

---

### 5. Domain Model 定義

#### ✅ 基本一致

**新 API Spec 中的 Response DTO** 與 **Domain Model** 的 Mapping 邏輯基本一致，但需要注意：

1. **CommentDTO 欄位對應**:
   - API: `comment` → Domain: `content` ✅
   - API: `userId` → Domain: `authorId` ✅
   - API: `userNickname` → Domain: `authorNickname` ✅
   - API: `likedCount` → Domain: `likeCount` ✅
   - API: `createTime` (Int64 毫秒) → Domain: `createdAt` (Date) ✅

2. **MessageDTO 欄位對應**:
   - API: `jsonBody.text` → Domain: `content` ✅
   - API: `postUserId` → Domain: `authorId` ✅
   - API: `userInfo.nickname` → Domain: `authorNickname` ✅
   - API: `createTime` (Int64 毫秒) → Domain: `createdAt` (Date) ✅

**建議**: Domain Model 定義與新 API Spec 的 Mapping 邏輯一致，無需修改。

---

### 6. UseCase Input & Output Model

#### ⚠️ 需要檢查參數對應

**新 API Spec 中的 Request 參數** 與 **UseCase Input** 需要對應檢查：

1. **ReloadCommentListUseCase**:
   - UseCase Input: `mode: SortMode` (top / newest)
   - API Spec: 
     - `mode = "top"` → `GET /chat/match/comment/popular?pageNum=...`
     - `mode = "newest"` → `GET /chat/match/comment/newest?prevCommentId=...`
   - **問題**: UseCase 的 `cursor` 參數需要對應到不同的 API 參數：
     - `popular` 模式使用 `pageNum`
     - `newest` 模式使用 `prevCommentId`

2. **LoadRepliesUseCase**:
   - UseCase Input: `commentId: String`
   - API Spec: `GET /chat/match/comment/replies?parentCommentId=...`
   - **問題**: 參數名稱不一致（`commentId` vs `parentCommentId`）

**建議**: 檢查 UseCase Input & Output Model 文件，確認參數對應關係。

---

## 📝 建議修正清單

### 高優先級 (P0) - ✅ 已完成

1. ✅ **TDD-010**: 修正 `getCommentMeta` endpoint 定義（Method 和參數）
2. ✅ **TDD-010**: 將 `getComments` 拆分為三個獨立的 endpoints
3. ✅ **TDD-010**: 更新 `CommentDTO` 結構以對齊新 API Spec
4. ✅ **TDD-011**: 補充缺少的 endpoints（join, leave, leave/bulk）
5. ✅ **TDD-020**: 補充 `getBatchCommentInfo` 方法
6. ✅ **TDD-020**: 更新方法參數定義以對齊新 API Spec
7. ✅ **TDD-021**: 補充 `getBatchCount` 方法
8. ✅ **TDD-021**: 補充 `joinChatroom`、`leaveChatroom`、`bulkLeaveChatroom` 方法

### 中優先級 (P1) - ✅ 已完成

9. ✅ **TDD-011**: 補充 WebSocket 詳細規格說明
10. ⚠️ **UseCase Input & Output Model**: 檢查並更新參數對應關係（需要進一步確認）

### 低優先級 (P2) - ✅ 已完成

11. ✅ 更新相關文件的 "相關文件" 連結，確保指向正確的 API Spec 路徑

---

## ✅ 一致性檢查結果

### 已確認一致的部分

- ✅ Domain Model 定義與新 API Spec 的 Mapping 邏輯一致
- ✅ 基本架構設計（Clean Architecture、Module Responsibility）與新 API Spec 一致
- ✅ WebSocket 基本設計與新 API Spec 一致（TDD-022）

### 已修正的部分

- ✅ TDD-010: PrematchCommentAPI endpoint 定義和方法參數已更新
- ✅ TDD-011: ChatAPI 已補充缺少的 endpoints 和 WebSocket 詳細規格
- ✅ TDD-020: PrematchCommentClient 方法定義已完整更新
- ✅ TDD-021: LiveChatClient 方法定義已完整更新
- ✅ 相關文件的 "相關文件" 連結已更新

### 需要進一步確認的部分

- ⚠️ UseCase Input & Output Model: 參數對應關係需要確認（建議在實作時驗證）

---

## 🔗 相關文件

- **基準文件**: `08_API Spec & Mapping/01_api_spec.md`
- **API 文檔來源**: 
  - `Input/LiveChat&PrematchComment/API Docs/FComAPI_Documentation.md`
  - `Input/LiveChat&PrematchComment/API Docs/LiveChat_API_Documentation.md`
- **需要更新的 Tickets**:
  - TDD-010: PrematchCommentAPI
  - TDD-011: ChatAPI
  - TDD-020: PrematchCommentClient
  - TDD-021: LiveChatClient

---

## 📌 下一步行動

1. ✅ 更新 TDD-010 和 TDD-011 的 endpoint 定義（已完成）
2. ✅ 更新 TDD-020 和 TDD-021 的方法定義（已完成）
3. ⚠️ 檢查並更新 UseCase Input & Output Model（建議在實作時驗證）
4. ✅ 重新驗證所有相關文件的引用連結（已完成）

## 📋 修正摘要

**修正日期**: 2025-12-03

**已修正的文件**:
- ✅ `12_Tickets/02_api/TDD-010_PrematchCommentAPI.md`
- ✅ `12_Tickets/02_api/TDD-011_ChatAPI.md`
- ✅ `12_Tickets/03_client/TDD-020_PrematchCommentClient.md`
- ✅ `12_Tickets/03_client/TDD-021_LiveChatClient.md`

**主要修正內容**:
1. TDD-010: 完全重寫 endpoint 定義，對齊新 API Spec 的 7 個 endpoints
2. TDD-010: 更新 CommentDTO 結構，包含所有新 API Spec 的欄位
3. TDD-011: 補充 3 個缺少的 endpoints（join, leave, leave/bulk）
4. TDD-011: 補充 WebSocket 詳細規格說明和程式碼範例
5. TDD-020: 更新所有方法定義，對齊新的 Repository 方法簽名
6. TDD-021: 補充所有缺少的方法，包括可選操作的 endpoints
7. 更新所有相關文件的連結路徑

