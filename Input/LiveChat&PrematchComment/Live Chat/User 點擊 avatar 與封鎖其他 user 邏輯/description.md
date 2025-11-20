# 用戶點擊 avatar 與封鎖其他 user 邏輯流程說明

## 流程概述

本流程為子流程（Sub Flow），主流程為：**用戶進入與離開聊天室（含 WebSocket 相依）**（flow_id: LC-FULL-001）。

本文件描述用戶在聊天室中點擊其他用戶名稱或頭像時的完整流程，包括顯示操作選單、跳轉個人主頁、封鎖用戶以及黑名單管理等功能。本流程涉及以下參與者：**User（用戶）**、**LiveChat Package（聊天室套件）**、**Main App（主應用程式）** 和 **Chat API Server（聊天 API 伺服器）**。

---

## 1. 點擊使用者名稱

當用戶點擊聊天室中其他用戶的名稱時，LiveChat Package 會顯示操作選單。

- **用戶操作**：點擊使用者名稱
- **LiveChat Package 行為**：顯示底部彈窗（含「個人主頁」「Block this user」）

---

## 2. 操作選單選擇

用戶可以從操作選單中選擇跳轉個人主頁或封鎖該用戶。

### 情境 A：跳轉個人主頁

當用戶選擇「Go to Profile」時，LiveChat Package 會調用 Main App 的路由方法跳轉到該用戶的個人主頁。

- **用戶操作**：點擊 Go to Profile
- **LiveChat Package 行為**：調用 Main App 的 `UIViewController+routeToDestination.route(to destination: .personal)` 方法
- **Main App 處理**：透過 routeToDestination 跳轉到 User Profile Page
- **Main App 行為**：顯示該使用者的個人主頁畫面

---

### 情境 B：封鎖使用者

當用戶選擇「Block this user」時，LiveChat Package 會引導用戶確認封鎖操作，然後將該用戶加入黑名單。

#### 2.1 確認封鎖

- **用戶操作**：點擊 Block this user
- **LiveChat Package 行為**：顯示確認彈窗
- **用戶操作**：點擊確認封鎖

#### 2.2 加入黑名單

- **LiveChat Package 行為**：將該 User 加入黑名單 DB (userID, eventID, timestamp)

#### 2.3 WebSocket 同步

- **LiveChat Package 行為**：websocket 重連後同步 blocked user 清單

---

## 3. 關閉聊天室與黑名單清理

當用戶關閉聊天室時，LiveChat Package 會執行黑名單檢查與清理邏輯。

- **用戶操作**：關閉聊天室（退出 Chatroom）
- **LiveChat Package 行為**：執行黑名單檢查與清理

---

## 4. 四小時清除邏輯

LiveChat Package 會檢查黑名單紀錄的加入時間，如果超過 4 小時則自動移除。

- **LiveChat Package 行為**：比較黑名單紀錄的加入時間與當前時間
- **LiveChat Package 行為**：若超過 4 小時 → 自動移除黑名單紀錄

---

## 技術備註

1. **個人主頁跳轉**：使用 UIViewController+routeToDestination 的 `route(to destination: .personal)` 方法進行跳轉，透過 routeToDestination extension 提供的路由機制，統一管理頁面跳轉邏輯
2. **黑名單資料結構**：黑名單資料包含 userID、eventID 和 timestamp
3. **WebSocket 同步**：封鎖用戶後，會在 WebSocket 重連時同步 blocked user 清單
4. **自動清理機制**：系統會在用戶關閉聊天室時檢查黑名單，超過 4 小時的紀錄會自動移除
5. **時間判斷邏輯**：使用「現在時間 - 加入時間 > 4 小時」來判斷是否超過 4 小時

