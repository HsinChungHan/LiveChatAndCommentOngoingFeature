# 用戶點擊用戶名稱 → 跳轉個人主頁流程說明

## 流程概述

本流程為子流程（Sub Flow），主流程為：**用戶進入 Upcoming Race Page, Prematch Comment Page 與 Top**（flow_id: PC-FULL-001）。

本文件描述用戶點擊留言中的用戶名稱或頭像時，跳轉到該用戶個人主頁的流程。本流程涉及以下參與者：**User（用戶）** 和 **Main App（主應用程式）**。

---

## 1. 點擊用戶名稱或頭像

當用戶點擊留言中的用戶名稱或頭像時，Main App 會透過 UIViewController+routeToDestination 的 route 方法跳轉到該用戶的個人主頁。

- **用戶操作**：點擊使用者名稱及 Avatar
- **Main App 行為**：調用 `UIViewController+routeToDestination.route(to destination: .personal)` 方法
- **Main App 處理**：透過 routeToDestination 跳轉到 User Profile Page
- **Main App 行為**：顯示該使用者的個人主頁畫面

---

## 技術備註

1. **路由跳轉**：使用 UIViewController+routeToDestination 的 `route(to destination: .personal)` 方法進行跳轉
2. **本地處理**：所有跳轉邏輯都在 Main App 端處理，不需要額外的 API 請求
3. **路由機制**：透過 routeToDestination extension 提供的路由機制，統一管理頁面跳轉邏輯

