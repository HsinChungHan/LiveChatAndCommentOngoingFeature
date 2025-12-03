# 變更日誌

本文件記錄所有與 MatchChat (LiveChat & PrematchComment) feature 相關的變更。

## 格式說明

每個變更記錄包含：
- **日期**：變更日期
- **類型**：變更類型（完成/進行中/Bug 修復/重構/文件更新/問題發現）
- **Ticket ID**：相關的 TDD Ticket
- **描述**：變更的詳細描述
- **檔案**：相關的實作檔案
- **連結**：Git commit 連結（如果有的話）

---

## 2025-12-02

### ✅ 完成

- [TDD-021] 實作 LiveChatClient（HTTP）[FOOTBALL-9182]
  - **檔案**: `MatchChat/Sources/MatchChat/Services/API/LiveChatClient.swift`
  - **變更**: 新增 LiveChatClient struct，包含 4 個 HTTP API 方法
    - `getBatchCount(refIdList:)` - 批量獲取聊天室數量
    - `getChatroomInfo(refId:userId:)` - 獲取聊天室資訊
    - `getHistoricalMessages(chatroomId:messageNo:length:)` - 獲取歷史訊息
    - `sendMessage(chatroomId:text:)` - 發送訊息
  - **設計**: 整合 `ChatAPI.ChatRepository`，支援依賴注入
  - **測試**: ⚠️ 待補（Unit Test 和 Integration Test）
  - **Commit**: `198f313a0a`

- [TDD-020] 實作 PrematchCommentClient（HTTP）[FOOTBALL-9181]
  - **檔案**: `MatchChat/Sources/MatchChat/Services/API/PrematchCommentClient.swift`
  - **變更**: 新增 PrematchCommentClient struct，包含 5 個 HTTP API 方法
    - `getCommentMeta(refId:)` - 獲取評論統計資訊
    - `getComments(refId:mode:cursor:)` - 獲取評論列表
    - `publishComment(refId:content:parentId:)` - 發送評論或回覆
    - `toggleLike(commentId:)` - 切換 Like 狀態
    - `getReplies(commentId:cursor:)` - 獲取回覆列表
  - **設計**: 整合 `PrematchCommentAPI.PrematchCommentRepository`，支援依賴注入
  - **測試**: ⚠️ 待補（Unit Test 和 Integration Test）
  - **Commit**: `b40e7fec84`

### 📝 文件更新

- 更新實作狀態追蹤表（implementation_status.md）
  - 標記 TDD-020 和 TDD-021 為已完成
  - 更新完成度統計：2/26 tickets (7.7%)
  - 更新 Client 層統計：2/3 已完成

---

## 2025-01-XX

### 📝 初始化
- 建立變更日誌文件
- 建立實作狀態追蹤文件
- 建立工作日誌模板

---

## 範例格式

### 2025-01-XX

#### ✅ 完成
- [TDD-001] 實作 Comment Entity
  - **檔案**: `MatchChat/Sources/Domain/Entities/Comment.swift`
  - **變更**: 新增 Comment entity，包含 id, content, authorId, createdAt 等欄位
  - **測試**: ✅ 通過所有單元測試
  - **連結**: [Commit](https://github.com/...)

#### 🚧 進行中
- [TDD-002] 實作 CommentMeta Entity
  - **進度**: 50%
  - **待完成**: 實作 Value Objects 相關邏輯
  - **預計完成**: 明天

#### 🐛 Bug 修復
- 修復 Comment Entity 的 Equatable 實作問題
  - **問題**: Equatable conformance 有誤
  - **解決方案**: 使用 @Equatable macro
  - **檔案**: `MatchChat/Sources/Domain/Entities/Comment.swift`

#### ♻️ 重構
- 重構 Domain Model 的命名空間結構
  - **變更**: 統一使用 MatchChat namespace
  - **影響檔案**: 所有 Domain Model 檔案

#### 📝 文件更新
- 更新 TDD-001 的實作狀態
- 更新 implementation_status.md

#### ⚠️ 問題發現
- 發現 API 規格與 TDD 有差異
  - **問題**: API 回傳的欄位名稱與 TDD 定義不同
  - **影響**: 需要調整 DTO mapping
  - **記錄**: 已記錄在 `11_Risks & Questions/01_risks_questions.md`

---

## 統計

### 總變更數
- **完成**: 2
- **進行中**: 0
- **Bug 修復**: 0
- **重構**: 0
- **文件更新**: 2
- **問題發現**: 0

