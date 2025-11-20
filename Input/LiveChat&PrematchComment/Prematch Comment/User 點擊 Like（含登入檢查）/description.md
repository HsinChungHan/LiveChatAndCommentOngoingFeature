# 用戶點擊 Like（含登入檢查）流程說明

## 流程概述

本流程為子流程（Sub Flow），主流程為：**用戶進入 Upcoming Race Page, Prematch Comment Page 與 Top**（flow_id: PC-FULL-001）。

本文件描述用戶點擊留言 Like 按鈕時的完整流程，包括登入檢查、Optimistic UI 更新以及 Like 狀態同步等功能。本流程涉及以下參與者：**User（用戶）**、**PrematchComment Package（賽前留言套件）**、**Main App（主應用程式）**、**PersonalPage Package(external)（個人頁面套件）** 和 **Chat API Server（聊天 API 伺服器）**。其中 PrematchComment Package（internal）、Main App、PersonalPage Package(external) 和 FComSharedFlow Package(external) 都屬於 **App（應用程式）** 層級。

---

## 1. 點擊 Like 按鈕

當用戶點擊留言的 Like 按鈕時，PrematchComment Package 會先檢查用戶是否已登入。

- **用戶操作**：點擊 Like 按鈕
- **PrematchComment Package 行為**：點擊 Like 按鈕時觸發登入檢查
- **PrematchComment Package 行為**：調用 Main App 的 `APICoordinator.shared.accountManager` 檢查登入狀態

---

## 2. 登入檢查

PrematchComment Package 會檢查用戶是否已登入，未登入用戶會被導向登入流程。

### 情境 A：使用者已登入
- **Main App 回應**：已登入
- **PrematchComment Package 處理**：通過登入檢查
- **PrematchComment Package 行為**：繼續執行 Like 操作

### 情境 B：使用者未登入
- **Main App 回應**：未登入
- **PrematchComment Package 行為**：調用 Main App 的 `route(to: .personalPage)` 跳轉到 PersonalPage
- **Main App 行為**：跳轉到 PersonalPage
- **PersonalPage Package(external) 行為**：完成 user 登入流程
- **PersonalPage Package(external) 回應**：登入成功（回跳至原頁面）

---

## 3. Optimistic UI 更新

通過登入檢查後，PrematchComment Package 會立即更新畫面上的 Like 數，提供即時回饋。

- **PrematchComment Package 行為**：立即更新畫面上的 Like 數（Optimistic UI）
- **PrematchComment Package 行為**：顯示已點讚狀態 + Like +1

---

## 4. 同步 Like 狀態

PrematchComment Package 會向伺服器發送 Like 請求，同步 Like 狀態。

- **PrematchComment Package 行為**：向伺服器發送 `POST /chat/match/comment/like { commentId }` 請求
- **伺服器回應**：`200 OK`（更新成功）

---

## 技術備註

1. **登入檢查**：點擊 Like 按鈕時，PrematchComment Package 會調用 Main App 的 `APICoordinator.shared.accountManager` 檢查登入狀態，未登入用戶會被導向 PersonalPage 完成登入流程
2. **Optimistic UI**：使用 Optimistic UI 模式，立即更新畫面，提供更好的用戶體驗
3. **API 端點**：使用 `POST /chat/match/comment/like` API 來同步 Like 狀態
4. **狀態同步**：即使使用 Optimistic UI，仍會向伺服器同步狀態，確保資料一致性
5. **Package 架構**：PrematchComment Package（internal）、Main App、PersonalPage Package(external) 和 FComSharedFlow Package(external) 都屬於 App 層級
