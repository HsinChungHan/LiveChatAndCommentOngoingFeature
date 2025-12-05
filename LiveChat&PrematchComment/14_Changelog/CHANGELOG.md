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

## 2025-12-04

### ♻️ 重構

- 包裝 shared bets metadata 為 Sendable 類型 [FOOTBALL-9180-9184]
  - **問題**: `[String: Any]` 字典類型在 Swift Concurrency 環境中不符合 `Sendable` 協議，導致編譯警告
  - **解決方案**: 引入 `SharedBetsMetadata` struct 包裝字典，使用 `@unchecked Sendable` 標記
  - **變更**: 
    - 新增 `SharedBetsMetadata` 結構在 `PrematchCommentAPI+RepositoryProtocol.swift`
    - 更新 `publishComment` 方法簽名，使用 `SharedBetsMetadata?` 取代 `[String: Any]?`
    - 在 Repository 層將 metadata 轉回字典後再傳給 API
  - **影響範圍**: 
    - `PrematchCommentAPI+Repository.swift`
    - `PrematchCommentAPI+RepositoryProtocol.swift`
    - `PrematchCommentClient.swift`
    - `PrematchCommentClientProtocol.swift`
  - **完成度**: 100%
  - **Commit**: `1f97afa505`

- 將 WebSocket subscribe 方法改為 nonisolated [FOOTBALL-9180-9184]
  - **問題**: `subscribe(chatroomId:)` 方法在 actor 隔離環境中返回 `AsyncStream` 導致調用方需要 await
  - **解決方案**: 
    - 將 `subscribe` 方法標記為 `nonisolated`，允許同步創建 AsyncStream
    - 提取 actor-isolated 邏輯到新的 `performSubscribe` helper 方法
    - 重構 `addSubscriber` 方法，直接接受 continuation 而非返回 tuple
  - **變更**:
    - `ChatWebSocketClient.swift` - 重構訂閱邏輯
    - `ChatWebSocketClientProtocol.swift` - 更新協議簽名
  - **優點**: 改善併發模型，避免不必要的 actor 隔離在 stream 創建時
  - **完成度**: 100%
  - **Commit**: `163d376ab6`

### 🔧 配置更新

- 更新 gitignore 排除 buildServer.json
  - **目的**: 防止本地 Xcode Build Server 配置被提交到 git
  - **變更**: 在 `.gitignore` 中新增 `buildServer.json` 規則
  - **好處**: 確保本地開發配置在 rebase/merge 時保持不變
  - **檔案**: `.gitignore`
  - **Commit**: `41c38d3195`

- 更新 Xcode 項目配置 [FOOTBALL-9180-9184]
  - **變更**:
    - 新增 MatchChat package 依賴到 FCom target
    - 更新 scheme version 至 1.3 以提升兼容性
  - **檔案**:
    - `FCom.xcodeproj/project.pbxproj`
    - `MatchChat/.swiftpm/xcode/xcshareddata/xcschemes/MatchChat.xcscheme`
  - **Commit**: `c00431ad62`

### 📝 文件更新

- 更新實作狀態追蹤表（implementation_status.md）
  - 持續進行 Data Layer 重構工作
  - 改善 Swift Concurrency 支援

---

## 2025-12-03

### ✅ 完成

- [TDD-022] 實作 ChatWebSocketClient（WebSocket）[FOOTBALL-9183]
  - **檔案**: `MatchChat/Sources/MatchChat/Services/API/ChatWebSocketClient.swift`
  - **變更**: 新增 ChatWebSocketClient actor，實作 WebSocket 通訊
    - `connect()` - 建立 WebSocket 連線
    - `disconnect()` - 斷開 WebSocket 連線
    - `subscribe(chatroomId:)` - 訂閱指定聊天室的訊息（返回 AsyncStream）
    - `unsubscribe(subscriberId:)` - 取消訂閱（支援多訂閱者）
    - `unsubscribeAll(chatroomId:)` - 取消指定聊天室的所有訂閱
    - `sendMessage(chatroomId:text:)` - 發送訊息到指定聊天室
  - **設計**: 
    - 使用 `actor` 確保線程安全
    - 使用 `AsyncStream` 提供訊息流
    - 使用 `SportyStomp` 框架實作 STOMP 協議
    - 實作指數退避重連策略
    - 支援多訂閱者模式
  - **測試**: ⚠️ 待補（Unit Test 和 Integration Test）
  - **完成度**: 95%
  - **Commit**: `09e4ac3ef8`

### 🐛 Bug 修復

- 修復 SportyStomp API 調用錯誤
  - **問題**: 
    - `SportyStomp(host:)` 參數類型錯誤（String vs URL）
    - `subscribe`、`unsubscribe`、`send` 方法參數名稱錯誤
  - **解決方案**: 直接查看 SportyStomp 源碼確認正確的 API 簽名
  - **檔案**: `MatchChat/Sources/MatchChat/Services/API/ChatWebSocketClient.swift`
  - **Commit**: `09e4ac3ef8`

- 修復並發數據競爭警告
  - **問題**: 
    - `nonisolated` delegate 方法中捕獲非 `Sendable` 類型
    - `Any?` 類型在 `@Sendable` 閉包中引起警告
  - **解決方案**: 
    - 移除 `@Sendable` 標記（值類型在 Task 中已安全）
    - 將 `Any?` 轉換為 `String?`
    - 為外部庫 enum 添加 `@unchecked @retroactive Sendable`
  - **檔案**: `MatchChat/Sources/MatchChat/Services/API/ChatWebSocketClient.swift`
  - **Commit**: `09e4ac3ef8`

- 修復 EmptyResponseDTO 處理
  - **問題**: `NSNull?` 無法正確解碼
  - **解決方案**: 使用自定義 `EmptyData` struct 處理 null 回應
  - **檔案**: `MatchChat/Sources/MatchChat/Services/API/Chat/ChatAPI+Repository.swift`
  - **Commit**: `09e4ac3ef8`

### 📝 文件更新

- 更新實作狀態追蹤表（implementation_status.md）
  - 標記 TDD-022 為已完成（95%）
  - 更新完成度統計：3/26 tickets (11.5%)
  - 更新 Client 層統計：3/3 已完成

- 生成 TDD 一致性檢查報告
  - **檔案**: `13_Implementation_Status/TDD-022_ChatWebSocketClient_Consistency_Check.md`
  - **內容**: 詳細檢查實作與 TDD 文件的一致性，識別完成度和缺失項目

- 生成對話統整文檔
  - **檔案**: `16_Cursor_Workflow/daily_summaries/2025-12-03.md`
  - **內容**: 統整今天與 Cursor 的對話，提取重要決策和學習要點

- 更新工作日誌
  - **檔案**: `15_Daily_Logs/2025-12-03.md`
  - **內容**: 記錄今天的工作內容、遇到的問題和解決方案

- 部署 TDD 文檔到 GitHub Pages
  - **結果**: ✅ 成功部署到 gh-pages branch
  - **URL**: https://hsinchunghan.github.io/LiveChatAndCommentOngoingFeature/

### ⚠️ 問題發現

- API Spec 兼容性待驗證
  - **問題**: 需要驗證 `accept-version` 格式、`heart-beat` header、訊息格式
  - **影響**: 可能影響與服務端的兼容性
  - **記錄**: 已在 `ChatWebSocketClient.swift` 中添加 TODO 註解
  - **建議**: 在 Integration Test 中驗證

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
- **完成**: 3
- **進行中**: 0
- **Bug 修復**: 3
- **重構**: 6
- **文件更新**: 5
- **問題發現**: 1

