# 用戶從 In-Site message 跳轉到 Prematch Comment Page 流程說明

## 流程概述

本流程為子流程（Sub Flow），主流程為：**用戶進入 Upcoming Race Page, Prematch Comment Page 與 Top**（flow_id: PC-FULL-001）。

本文件描述用戶收到 In-Site message 後，點擊 message 中的按鈕，跳轉到 Match Detail Page 並打開 Prematch Comment Page 的完整流程。本流程涉及以下參與者：**User（用戶）**、**NotificationCentre Package(external)（通知中心套件）**、**HomeViewController class（首頁視圖控制器類別）**、**Destination class（目標解析類別）** 和 **LiveChat Package（聊天室套件）**。其中 HomeViewController class 和 Destination class 都屬於 **Main App（主應用程式）** 層級，NotificationCentre Package(external) 和 LiveChat Package（internal）為獨立的 Package。

---

## 1. 進入 Messages Page 並點擊按鈕

當用戶收到 In-Site message 後，會進入 NotificationCentre Package(external) 的 Messages Page，並點擊 message 中的按鈕來跳轉到 Prematch Comment Page。

- **用戶操作**：進入 Messages Page
- **用戶操作**：點擊 message 中的 Go To Prematch Comment button

---

## 2. 處理 Deep Link

NotificationCentre Package(external) 會調用 HomeViewController class 的方法來處理 deep link，並透過 Destination class 解析 URL。

- **NotificationCentre Package(external) 行為**：調用 HomeViewController class 的 `notificationCenterDidRequestAction(deepLinkUrl)` 方法
- **傳入參數**：deep link url
- **HomeViewController class 行為**：將 deep link url 傳給 Destination class 進行解析
- **Destination class 行為**：解析 deep link url，解析出 page 與 queryItems（action items）
- **Destination class 回應**：回傳解析結果，包含 page 和 queryItems

---

## 3. 跳轉到 Match Detail Page

解析完成後，HomeViewController class 會通知 NotificationCentre Package(external) 跳轉到 Match Detail Page，並將 queryItems 傳給 NotificationCentre Package(external)。

- **HomeViewController class 行為**：通知 NotificationCentre Package(external) 跳轉到 match detail page
- **NotificationCentre Package(external) 行為**：接收 queryItems（action items）
- **NotificationCentre Package(external) 行為**：執行跳轉到 Match Detail Page

---

## 4. 打開 Prematch Comment Page

NotificationCentre Package(external) 在跳轉到 Match Detail Page 後，會通知 LiveChat Package 打開 Prematch Comment Page。

- **NotificationCentre Package(external) 行為**：通知 LiveChat Package 打開 Prematch Comment page
- **傳入參數**：queryItems（action items）
- **LiveChat Package 行為**：根據 queryItems 打開 Prematch Comment Page
- **LiveChat Package 回應**：顯示 Prematch Comment Page 給用戶

---

## 技術備註

1. **Deep Link 處理**：使用 HomeViewController class 的 `notificationCenterDidRequestAction` 方法來處理 deep link
2. **URL 解析**：透過 Destination class 解析 deep link url，提取 page 和 queryItems（action items）
3. **頁面跳轉**：NotificationCentre Package(external) 負責執行頁面跳轉，從 Messages Page 跳轉到 Match Detail Page
4. **Package 通知**：NotificationCentre Package(external) 在跳轉完成後通知 LiveChat Package 打開 Prematch Comment Page
5. **參數傳遞**：queryItems（action items）會從 Destination class 傳遞到 NotificationCentre Package(external)，再傳遞給 LiveChat Package
6. **架構說明**：HomeViewController class 和 Destination class 都屬於 Main App 層級，NotificationCentre Package(external) 和 LiveChat Package（internal）為獨立的 Package

