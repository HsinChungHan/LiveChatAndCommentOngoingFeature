# Implementation Review Report

> **Review 日期**: 2025-12-03  
> **基準**: TDDs 文件（已更新對齊新 API Spec）  
> **Review 範圍**: MatchChat 下的所有實作

---

## 📋 執行摘要

本次 review 檢查 MatchChat 下的所有實作是否符合最新的 TDDs 文件規範。發現多處不一致，需要修正以對齊 TDD-010、TDD-011、TDD-020、TDD-021、TDD-022。

---

## 🔍 發現的不一致問題

### 1. ChatWebSocketClient.swift

#### ⚠️ 問題 1: Connect Headers 不完整

**TDD-022 要求** (根據 API Spec):
- `Platform: ios`
- `App-Version: {version}`
- `Device-Id: {deviceId}`
- `userId: {userId}`

**實際實作** (第 93-95 行):
```swift
self.webSocketRequestHeaders = [
    "userId": userId
]
```

**問題**: 缺少 `Platform`、`App-Version`、`Device-Id` headers

**應修正為**:
```swift
self.webSocketRequestHeaders = [
    "Platform": "ios",
    "App-Version": AppConfiguration.current.appVersion, // 或實際的版本號
    "Device-Id": DeviceInfo.identifier, // 或實際的 device ID
    "userId": userId
]
```

#### ✅ 其他部分基本一致

- Actor 實作 ✅
- AsyncStream 使用 ✅
- 訂閱管理 ✅
- 重連機制 ✅
- Delegate 處理 ✅

---

### 2. LiveChatClient.swift

#### ❌ 問題 1: 缺少方法

**TDD-021 要求的方法**:
- ✅ `getBatchCount(refIdList: [String])`
- ✅ `getChatroomInfo(refId: String, userId: String?)`
- ✅ `getHistoricalMessages(chatroomId: String, messageNo: Int, length: Int?)`
- ✅ `sendMessage(chatroomId: String, text: String)`
- ❌ `joinChatroom(chatroomId: String)` - **缺少**
- ❌ `leaveChatroom(chatroomId: String)` - **缺少**
- ❌ `bulkLeaveChatroom(chatroomId: String, excludeUserIds: [String]?)` - **缺少**

**實際實作**: 只有前 4 個方法

**應補充**: 3 個缺少的方法（雖然是可選操作，但應在 Client 中提供）

---

### 3. PrematchCommentClient.swift

#### ❌ 問題 1: 方法簽名與 TDD-020 不一致

**TDD-020 要求的方法**:
- ❌ `getBatchCommentInfo(refIdList: [String])` - **缺少**
- ✅ `getCommentMeta(refId: String)` - 存在但可能簽名不一致
- ❌ `getCommentsByPopular(refId: String, pageNum: Int?, pageSize: Int?)` - **缺少**
- ❌ `getCommentsByNewest(refId: String, prevCommentId: Int64?, pageSize: Int?)` - **缺少**
- ❌ `getReplies(parentCommentId: Int64, prevCommentId: Int64?, pageSize: Int?)` - 參數不一致
- ❌ `publishComment(refId: String, content: String, parentId: Int64?, sharedBetsMeta: [String: AnyCodable]?, tagUserId: String?)` - 參數不一致
- ❌ `toggleLike(commentId: Int64)` - 參數類型不一致（String vs Int64）

**實際實作** (第 13-31 行):
```swift
public func getCommentMeta(refId: String) async throws -> PrematchCommentAPI.CommentMetaDataDTO
public func getComments(refId: String, mode: String, cursor: Int?) async throws -> PrematchCommentAPI.CommentPageDTO
public func publishComment(refId: String, content: String, parentId: String?) async throws -> PrematchCommentAPI.CommentDTO
public func toggleLike(commentId: String) async throws -> PrematchCommentAPI.CommentDTO
public func getReplies(commentId: String, cursor: Int?) async throws -> PrematchCommentAPI.CommentPageDTO
```

**問題**:
1. 缺少 `getBatchCommentInfo` 方法
2. `getComments` 應該拆分為 `getCommentsByPopular` 和 `getCommentsByNewest`
3. 參數類型不一致（String vs Int64）
4. 缺少可選參數（sharedBetsMeta, tagUserId, pageSize）

---

### 4. ChatAPI+Endpoint.swift

#### ❌ 問題 1: 缺少 Endpoints

**TDD-011 要求的 Endpoints**:
- ✅ `POST /chat/match/batch/count`
- ✅ `GET /chat/match/{refId}`
- ✅ `GET /chat/match/backward`
- ✅ `POST /chat/match/message`
- ❌ `POST /chat/match/join` - **缺少**
- ❌ `POST /chat/match/leave` - **缺少**
- ❌ `POST /chat/match/leave/bulk` - **缺少**

**實際實作**: 只有前 4 個 endpoints

**應補充**: 3 個缺少的 endpoints

---

### 5. PrematchCommentAPI+Endpoint.swift

#### ❌ 問題 1: Endpoint 定義與 TDD-010 不一致

**TDD-010 要求的 Endpoints**:
- `POST /chat/match/comment/batch/info` → `getBatchCommentInfo(refIdList: [String])`
- `GET /chat/match/comment/info/{refId}` → `getCommentMeta(refId: String)`
- `GET /chat/match/comment/popular` → `getCommentsByPopular(refId: String, pageNum: Int?, pageSize: Int?)`
- `GET /chat/match/comment/newest` → `getCommentsByNewest(refId: String, prevCommentId: Int64?, pageSize: Int?)`
- `GET /chat/match/comment/replies` → `getReplies(parentCommentId: Int64, prevCommentId: Int64?, pageSize: Int?)`
- `POST /chat/match/comment` → `publishComment(...)`
- `POST /chat/match/comment/like` → `toggleLike(commentId: Int64)`

**實際實作** (第 8-12 行):
```swift
case getCommentMeta(refId: String)
case getComments(refId: String, mode: String, cursor: Int?)
case publishComment(refId: String, content: String, parentId: String?)
case toggleLike(commentId: String)
case getReplies(commentId: String, cursor: Int?)
```

**問題**:
1. 缺少 `getBatchCommentInfo` endpoint
2. `getCommentMeta` 的 path 錯誤（應該是 `GET /info/{refId}`，不是 `POST /batch/info`）
3. `getComments` 應該拆分為 `getCommentsByPopular` 和 `getCommentsByNewest`
4. 參數類型不一致（String vs Int64）
5. 參數名稱不一致（commentId vs parentCommentId）

**實際 path 實作** (第 22-24 行):
```swift
case .getCommentMeta:
    return "\(base)/batch/info"  // ❌ 錯誤：應該是 GET /info/{refId}
```

---

### 6. PrematchCommentAPI+Repository.swift

#### ❌ 問題 1: 方法簽名與 TDD-010 不一致

**TDD-010 要求的方法**:
- `getBatchCommentInfo(refIdList: [String]) async throws -> [CommentMetaInfoDTO]`
- `getCommentMeta(refId: String) async throws -> CommentMetaDataDTO`
- `getCommentsByPopular(refId: String, pageNum: Int?, pageSize: Int?) async throws -> [CommentDTO]`
- `getCommentsByNewest(refId: String, prevCommentId: Int64?, pageSize: Int?) async throws -> [CommentDTO]`
- `getReplies(parentCommentId: Int64, prevCommentId: Int64?, pageSize: Int?) async throws -> [CommentDTO]`
- `publishComment(refId: String, content: String, parentId: Int64?, sharedBetsMeta: [String: AnyCodable]?, tagUserId: String?) async throws -> CommentDTO`
- `toggleLike(commentId: Int64) async throws -> CommentDTO?`

**實際實作**: 方法簽名完全不一致

---

## 📝 修正建議

### 高優先級 (P0)

1. ✅ **ChatWebSocketClient**: 補充 Connect Headers（Platform, App-Version, Device-Id） - **已完成**
2. ✅ **LiveChatClient**: 補充 3 個缺少的方法（joinChatroom, leaveChatroom, bulkLeaveChatroom） - **已完成**
3. ⚠️ **PrematchCommentClient**: 完全重寫方法簽名以對齊 TDD-020 - **待修正**
4. ✅ **ChatAPI+Endpoint**: 補充 3 個缺少的 endpoints - **已完成**
5. ⚠️ **PrematchCommentAPI+Endpoint**: 完全重寫以對齊 TDD-010 - **待修正**
6. ⚠️ **PrematchCommentAPI+Repository**: 完全重寫方法簽名以對齊 TDD-010 - **待修正**

### 中優先級 (P1)

7. ✅ 更新相關的 Repository Protocol 定義 - **已完成（ChatAPI）**
8. ⚠️ 更新相關的 Models 定義（如果需要） - **待確認**

---

## 📋 修正進度

### ✅ 已完成的修正

1. **ChatWebSocketClient.swift**:
   - ✅ 補充 Connect Headers（Platform, App-Version, Device-Id）
   - ✅ 更新 init 方法以接受可選的 appVersion 和 deviceId 參數

2. **ChatAPI+Endpoint.swift**:
   - ✅ 補充 `joinChatroom` endpoint
   - ✅ 補充 `leaveChatroom` endpoint
   - ✅ 補充 `bulkLeaveChatroom` endpoint

3. **ChatAPI+Repository.swift**:
   - ✅ 補充 `joinChatroom` 方法
   - ✅ 補充 `leaveChatroom` 方法
   - ✅ 補充 `bulkLeaveChatroom` 方法
   - ✅ 新增 `EmptyResponseDTO` 用於處理 null 回應

4. **ChatAPI+RepositoryProtocol.swift**:
   - ✅ 補充 3 個新方法的 protocol 定義

5. **LiveChatClient.swift**:
   - ✅ 補充 `joinChatroom` 方法
   - ✅ 補充 `leaveChatroom` 方法
   - ✅ 補充 `bulkLeaveChatroom` 方法

6. **TDD-022_ChatWebSocketClient.md**:
   - ✅ 更新 init 方法範例以反映 Connect Headers 的修正

7. **PrematchCommentAPI+Endpoint.swift**:
   - ✅ 完全重寫以對齊 TDD-010
   - ✅ 補充 `getBatchCommentInfo` endpoint（POST /batch/info）
   - ✅ 修正 `getCommentMeta` endpoint（GET /info/{refId}）
   - ✅ 將 `getComments` 拆分為 `getCommentsByPopular` 和 `getCommentsByNewest`
   - ✅ 修正所有參數類型（String vs Int64）
   - ✅ 修正參數名稱（commentId vs parentCommentId）
   - ✅ 更新 `publishComment` 以包含 sharedBetsMeta 和 tagUserId

8. **PrematchCommentAPI+Repository.swift**:
   - ✅ 完全重寫方法簽名以對齊 TDD-010
   - ✅ 新增 Response Wrapper DTOs（BatchCommentInfoResponseDTO, CommentMetaResponseDTO, CommentListResponseDTO, CommentResponseDTO, ToggleLikeResponseDTO）
   - ✅ 更新所有方法實作以使用新的 endpoints

9. **PrematchCommentAPI+RepositoryProtocol.swift**:
   - ✅ 完全重寫 protocol 定義以對齊新的方法簽名

10. **PrematchCommentClient.swift**:
    - ✅ 完全重寫方法簽名以對齊 TDD-020
    - ✅ 補充 `getBatchCommentInfo` 方法
    - ✅ 將 `getComments` 拆分為 `getCommentsByPopular` 和 `getCommentsByNewest`
    - ✅ 更新所有方法參數類型（String vs Int64）
    - ✅ 更新 `publishComment` 以包含 sharedBetsMeta 和 tagUserId
    - ✅ 更新 `toggleLike` 返回類型為可選（可能為 null）

---

## ✅ 修正完成總結

**修正日期**: 2025-12-03

**修正的文件**:
- ✅ `MatchChat/Sources/MatchChat/Services/API/ChatWebSocketClient.swift`
- ✅ `MatchChat/Sources/MatchChat/Services/API/Chat/ChatAPI+Endpoint.swift`
- ✅ `MatchChat/Sources/MatchChat/Services/API/Chat/ChatAPI+Repository.swift`
- ✅ `MatchChat/Sources/MatchChat/Services/API/Chat/ChatAPI+RepositoryProtocol.swift`
- ✅ `MatchChat/Sources/MatchChat/Services/API/LiveChatClient.swift`
- ✅ `MatchChat/Sources/MatchChat/Services/API/PrematchComment/PrematchCommentAPI+Endpoint.swift`
- ✅ `MatchChat/Sources/MatchChat/Services/API/PrematchComment/PrematchCommentAPI+Repository.swift`
- ✅ `MatchChat/Sources/MatchChat/Services/API/PrematchComment/PrematchCommentAPI+RepositoryProtocol.swift`
- ✅ `MatchChat/Sources/MatchChat/Services/API/PrematchCommentClient.swift`
- ✅ `TDDs/.../12_Tickets/03_client/TDD-022_ChatWebSocketClient.md`

**主要修正內容**:
1. ChatWebSocketClient: 補充 Connect Headers（Platform, App-Version, Device-Id）
2. ChatAPI: 補充 3 個缺少的 endpoints（join, leave, leave/bulk）
3. LiveChatClient: 補充 3 個缺少的方法
4. PrematchCommentAPI: 完全重寫以對齊新的 API Spec
5. PrematchCommentClient: 完全重寫以對齊 TDD-020

**驗證結果**:
- ✅ 無 linter 錯誤
- ✅ 所有方法簽名已對齊 TDDs 文件
- ✅ 所有 endpoints 已對齊新的 API Spec

### ✅ 已完成的修正（續）

7. **PrematchCommentAPI+Endpoint.swift**:
   - ✅ 完全重寫以對齊 TDD-010
   - ✅ 補充 `getBatchCommentInfo` endpoint
   - ✅ 修正 `getCommentMeta` endpoint（GET /info/{refId}）
   - ✅ 將 `getComments` 拆分為 `getCommentsByPopular` 和 `getCommentsByNewest`
   - ✅ 修正參數類型（String vs Int64）
   - ✅ 修正參數名稱（commentId vs parentCommentId）

8. **PrematchCommentAPI+Repository.swift**:
   - ✅ 完全重寫方法簽名以對齊 TDD-010
   - ✅ 新增 Response Wrapper DTOs（BatchCommentInfoResponseDTO, CommentMetaResponseDTO, CommentListResponseDTO, CommentResponseDTO, ToggleLikeResponseDTO）

9. **PrematchCommentAPI+RepositoryProtocol.swift**:
   - ✅ 更新 protocol 定義以對齊新的方法簽名

10. **PrematchCommentClient.swift**:
    - ✅ 完全重寫方法簽名以對齊 TDD-020
    - ✅ 補充 `getBatchCommentInfo` 方法
    - ✅ 將 `getComments` 拆分為 `getCommentsByPopular` 和 `getCommentsByNewest`
    - ✅ 更新所有方法參數類型

### ✅ 所有修正已完成

所有 MatchChat 下的實作已對齊最新的 TDDs 文件規範。

---

## ✅ 一致性檢查結果

### 已確認一致的部分

- ✅ ChatWebSocketClient 基本架構（actor, AsyncStream, 訂閱管理）
- ✅ LiveChatClient 基本方法（getBatchCount, getChatroomInfo, getHistoricalMessages, sendMessage）
- ✅ ChatAPI+WebSocket 定義正確
- ✅ CommentDTO 結構已對齊新的 API Spec
- ✅ CommentMetaInfoDTO 和 CommentMetaDataDTO 已正確定義

### 已修正的部分

- ✅ ChatWebSocketClient: Connect Headers 已補充完整
- ✅ LiveChatClient: 已補充 3 個缺少的方法
- ✅ PrematchCommentClient: 方法簽名已完全對齊 TDD-020
- ✅ ChatAPI+Endpoint: 已補充 3 個缺少的 endpoints
- ✅ PrematchCommentAPI+Endpoint: 已完全重寫以對齊 TDD-010
- ✅ PrematchCommentAPI+Repository: 方法簽名已完全對齊 TDD-010
- ✅ PrematchCommentAPI+RepositoryProtocol: 已更新 protocol 定義

---

## 🔗 相關文件

- **TDD-010**: `12_Tickets/02_api/TDD-010_PrematchCommentAPI.md`
- **TDD-011**: `12_Tickets/02_api/TDD-011_ChatAPI.md`
- **TDD-020**: `12_Tickets/03_client/TDD-020_PrematchCommentClient.md`
- **TDD-021**: `12_Tickets/03_client/TDD-021_LiveChatClient.md`
- **TDD-022**: `12_Tickets/03_client/TDD-022_ChatWebSocketClient.md`
- **API Spec**: `08_API Spec & Mapping/01_api_spec.md`

