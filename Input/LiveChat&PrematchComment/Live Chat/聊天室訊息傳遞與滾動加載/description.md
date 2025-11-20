# 聊天室訊息傳遞與滾動加載流程說明

## 流程概述

本流程為子流程（Sub Flow），主流程為：**用戶進入與離開聊天室（含 WebSocket 相依）**（flow_id: LC-FULL-001）。

本文件描述聊天室中訊息傳遞與滾動加載的完整流程，包括登入檢查、nickname 檢查、留言送出以及錯誤處理等情境。本流程涉及以下參與者：**User（用戶）**、**LiveChat Package（聊天室套件）**、**Main App（主應用程式）**、**PersonalPage Package(external)（個人頁面套件）**、**FComSharedFlow Package(external)（共享流程套件）** 和 **Server（伺服器）**。其中 LiveChat Package（internal）、Main App、PersonalPage Package(external) 和 FComSharedFlow Package(external) 都屬於 **App（應用程式）** 層級。

---

## 1. 點擊輸入框與登入檢查

當用戶點擊輸入框準備輸入留言時，LiveChat Package 會先檢查用戶是否已登入。

- **用戶操作**：點擊輸入框（準備輸入 Chat）
- **LiveChat Package 行為**：點擊輸入框時觸發登入檢查
- **LiveChat Package 行為**：調用 Main App 的 `APICoordinator.shared.accountManager` 檢查登入狀態

### 情境 A：使用者已登入
- **Main App 回應**：已登入
- **LiveChat Package 處理**：已登入，允許輸入留言

### 情境 B：使用者未登入
- **Main App 回應**：未登入
- **LiveChat Package 行為**：調用 Main App 的 `route(to: .personalPage)` 跳轉到 PersonalPage
- **Main App 行為**：跳轉到 PersonalPage
- **PersonalPage Package(external) 行為**：完成 user 登入流程
- **PersonalPage Package(external) 回應**：登入成功（回跳至原頁面）
- **LiveChat Package 處理**：登入完成後可再次點擊輸入框繼續流程

---

## 2. 輸入並送出留言

當用戶輸入並送出留言時，LiveChat Package 會先透過 Main App 檢查用戶是否有 nickname，然後送出留言。

- **用戶操作**：輸入並送出 Chat
- **LiveChat Package 行為**：送出前檢查 client 端 nickname 是否存在
- **LiveChat Package 行為**：調用 Main App 的 `APICoordinator.shared.accountManager.currentMetadata?.nickname` 檢查 nickname

---

## 3. 留言送出處理（有 nickname）

如果用戶已有 nickname，LiveChat Package 會直接送出留言。

- **Main App 回應**：nickname 存在
- **LiveChat Package 處理**：已有 nickname，直接送出 Chat
- **LiveChat Package 行為**：向伺服器發送 `POST /chat/match/comment { refId, content, parentId? }` 請求

### 情境 A：留言成功
- **伺服器回應**：`201 Created`（回傳 comment 資料）
- **LiveChat Package 行為**：顯示新留言

### 情境 B：留言失敗
- **伺服器回應**：`4xx/5xx Error`（留言失敗）
- **LiveChat Package 行為**：顯示錯誤 Toast（留言失敗）

---

## 4. 留言送出處理（無 nickname）

如果用戶沒有 nickname，LiveChat Package 會調用 FComSharedFlow Package 的 CreatNickName API 來建立 nickname，然後再送出留言。

- **Main App 回應**：nickname 不存在
- **LiveChat Package 處理**：需使用 FComSharedFlow Package 建立 nickname

### 4.1 建立 nickname
- **LiveChat Package 行為**：調用 FComSharedFlow Package(external) 提供的 CreatNickName API
- **FComSharedFlow Package(external) 行為**：在 App 上顯示 create nickName pop-up
- **用戶操作**：使用者輸入 nickname
- **FComSharedFlow Package(external) 處理**：FComSharedFlow Package(external) 建立 nickname
- **FComSharedFlow Package(external) 回應**：nickname 建立成功

### 4.2 送出留言
- **LiveChat Package 行為**：向伺服器發送 `POST /chat/{matchId}/message { content, messageType: TEXT }` 請求

### 情境 A：留言成功
- **伺服器回應**：`201 Created`
- **LiveChat Package 行為**：顯示 Chat 在最新的位置，並 highlight 3 秒

### 情境 B：留言失敗
- **伺服器回應**：`4xx/5xx Error`（留言失敗）
- **LiveChat Package 行為**：顯示錯誤 Toast（留言失敗）

---

## 技術備註

1. **登入檢查**：點擊輸入框時，LiveChat Package 會調用 Main App 的 `APICoordinator.shared.accountManager` 檢查登入狀態，未登入用戶會被導向 PersonalPage 完成登入流程
2. **Nickname 檢查**：送出留言前，LiveChat Package 會調用 Main App 的 `APICoordinator.shared.accountManager.currentMetadata?.nickname` 檢查 nickname 是否存在
3. **Nickname 建立**：如果沒有 nickname，LiveChat Package 會調用 FComSharedFlow Package(external) 提供的 CreatNickName API，由 FComSharedFlow Package(external) 顯示 pop-up 並建立 nickname
4. **API 差異**：有 nickname 時使用 `POST /chat/match/comment`，無 nickname 時使用 `POST /chat/{matchId}/message`
5. **錯誤處理**：留言失敗時會顯示錯誤 Toast 提示用戶
6. **視覺回饋**：留言成功後會顯示在最新位置，並 highlight 3 秒
7. **Package 架構**：LiveChat Package（internal）、Main App、PersonalPage Package(external) 和 FComSharedFlow Package(external) 都屬於 App 層級
