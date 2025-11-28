# LiveChat & PrematchComment Feature 組合概述

## 功能描述

本 Feature 組合包含兩個主要功能模組：

1. **LiveChat（即時聊天室）**：提供賽事進行中的即時聊天功能
2. **PrematchComment（賽前留言）**：提供賽事開始前的留言討論功能

## 主要使用者互動

### LiveChat 功能

1. **進入與離開聊天室**
   - 用戶進入 Live Detail Page 時自動建立 WebSocket 連線
   - 取得聊天室 ID 與最後訊息編號
   - 加入聊天室並載入歷史訊息
   - 離開聊天室時清除快取並取消 WebSocket 訂閱

2. **發送聊天訊息**
   - 登入檢查
   - Nickname 檢查與建立
   - 發送訊息並顯示在聊天室中

3. **用戶互動**
   - 點擊用戶名稱顯示操作選單
   - 跳轉個人主頁
   - 封鎖其他用戶（含黑名單管理）

4. **訊息傳遞與滾動加載**
   - WebSocket 即時接收訊息
   - 歷史訊息與即時訊息合併顯示
   - 分頁載入舊訊息

### PrematchComment 功能

1. **進入頁面與載入留言**
   - 進入 Race Detail Page 時取得個人資訊
   - 取得賽事留言統計資訊
   - 進入 Prematch Comment Page 時預設顯示 Top 標籤（按讚數排序）
   - 支援切換 Top / Newest 標籤
   - 手動刷新留言列表

2. **Event Status 訂閱與通知**
   - FactsCenter Package（外部）訂閱 Event Status
   - 當 Event Status 變更為 match_started 時自動關閉 Prematch Comment Page

3. **發送留言與回覆**
   - 登入檢查
   - Nickname 檢查與建立
   - 發送留言或回覆

4. **查看回覆**
   - 點擊回覆數量載入回覆列表
   - 分頁載入回覆（每次最多 5 筆）
   - 顯示「Show more replies」按鈕

5. **互動功能**
   - 點擊 Like 按鈕（含登入檢查）
   - Optimistic UI 更新
   - 點擊用戶名稱跳轉個人主頁

## Scope

### 包含的功能

- ✅ 即時聊天室功能（WebSocket）
- ✅ 賽前留言功能（HTTP API）
- ✅ 登入與 Nickname 檢查流程
- ✅ 用戶互動功能（個人主頁跳轉、封鎖用戶）
- ✅ Event Status 訂閱與通知
- ✅ 分頁載入機制
- ✅ 黑名單管理（4 小時自動清理）

### 不包含的功能

- ❌ 個人主頁的詳細實作（由 PersonalPage Package 負責）
- ❌ Nickname 建立的詳細實作（由 FComSharedFlow Package 負責）
- ❌ Event Status 訂閱的詳細實作（由 FactsCenter Package 負責）
- ❌ 登入流程的詳細實作（由 PersonalPage Package 負責）

## 技術架構

### 分層架構

本 Feature 組合遵循 Clean Architecture 分層：

1. **UI Layer**：View 層，負責使用者介面
2. **Domain Layer**：Feature + UseCase 層，負責業務邏輯
3. **Data & Infrastructure Layer**：Repository + Client + API 層，負責資料存取
4. **Domain Model Layer**：Entity + Value Object 層，純資料模型

### 外部依賴

- **FactsCenter Package（External）**：Event Status 訂閱與通知
- **PersonalPage Package（External）**：登入流程
- **FComSharedFlow Package（External）**：Nickname 建立流程
- **Main App**：路由跳轉、登入狀態檢查、Nickname 檢查

### 技術特點

- **WebSocket**：即時聊天訊息傳遞
- **HTTP API**：留言、回覆、Like 等操作
- **Optimistic UI**：Like 功能使用 Optimistic UI 提供即時回饋
- **分頁載入**：回覆列表使用游標（cursor）機制分頁載入
- **黑名單管理**：本地儲存，4 小時自動清理

## 主要流程

### LiveChat 主流程

- **LC-FULL-001**：用戶進入與離開聊天室（含 WebSocket 相依）
  - LC-SUB-001：用戶留 comment 時登入與 nickname 檢查
  - LC-SUB-002：用戶點擊 avatar 與封鎖其他 user 邏輯
  - LC-SUB-003：聊天室訊息傳遞與滾動加載

### PrematchComment 主流程

- **PC-FULL-001**：用戶進入 Upcoming Race Page, Prematch Comment Page 與 Top
  - PC-SUB-001：Event Status 訂閱與通知流程
  - PC-SUB-002：用戶發 Comment - Reply（含登入與 nickname 檢查）
  - PC-SUB-003：用戶查看 replies（含分頁載入）
  - PC-SUB-004：用戶點擊 Like（含登入檢查）
  - PC-SUB-005：用戶點擊用戶名稱 → 跳轉個人主頁

## 目標

提供完整的賽事聊天與留言功能，支援：

1. **即時互動**：透過 WebSocket 提供即時聊天體驗
2. **留言討論**：支援留言、回覆、Like 等互動功能
3. **用戶管理**：登入檢查、Nickname 管理、黑名單功能
4. **狀態同步**：Event Status 變更時自動處理頁面狀態

