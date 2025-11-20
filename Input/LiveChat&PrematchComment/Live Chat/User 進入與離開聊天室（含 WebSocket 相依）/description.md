# 用戶進入與離開聊天室（含 WebSocket 相依）流程說明

## 流程概述

本文件描述用戶在 Live Detail Page 中進入與離開聊天室的完整流程，包括 WebSocket 訂閱、聊天室 ID 取得、加入聊天室、載入歷史訊息、離開聊天室以及取消訂閱等情境。本流程涉及三個主要參與者：**User（用戶）**、**LiveChat Package（聊天室套件）** 和 **Chat API Server（聊天 API 伺服器）**。

---

## 1. 進入頁面與 WebSocket 訂閱

當用戶進入 **Live Detail Page（直播詳情頁面）** 時，LiveChat Package 會自動建立 WebSocket 連線以接收即時訊息。

- **用戶操作**：進入 Live Detail Page
- **LiveChat Package 行為**：透過 WebSocket 訂閱聊天服務
  - WebSocket 端點：`wss://www.encorebet.net/chat/websocket/web-chat`
  - 訂閱方式：`(subscribe)`

---

## 2. 取得聊天室 ID 與最後訊息編號

在建立 WebSocket 連線後，LiveChat Package 會向伺服器請求該賽事的聊天室資訊。

- **LiveChat Package 行為**：向伺服器發送 `GET /chat/match/{refId}` 請求
- **伺服器回應**：回傳包含 `chatroomId`（聊天室 ID）和 `lastMessageNo`（最後訊息編號）的資訊

### 情境 A：成功取得 chatroomId
- **LiveChat Package 處理**：儲存 `chatroomId` 與 `lastMessageNo` 供後續使用

### 情境 B：無法取得 chatroomId
- **LiveChat Package 處理**：隱藏 Live Chat Bar（用戶無法開啟聊天室）

---

## 3. 使用者開啟聊天視窗

當用戶點擊「Join the chat」按鈕時，LiveChat Package 會加入聊天室並載入歷史訊息。

- **用戶操作**：點擊「Join the chat（開啟 Chatroom）」
- **LiveChat Package 行為**：向伺服器發送 `POST /chat/match/join` 請求以加入聊天室

---

## 4. 載入歷史訊息

加入聊天室後，LiveChat Package 會透過 backward API 載入舊訊息，並與 WebSocket 接收的訊息合併顯示。

- **LiveChat Package 行為**：向伺服器發送 `POST /chat/match/backward { chatroomId, lastMessageNo }` 請求
- **伺服器回應**：返回 `historicalMessages`（歷史訊息）
- **LiveChat Package 處理**：
  - 將 `historicalMessages` 與 `websocketMessages`（WebSocket 接收的訊息）合併
  - 依 `messageNo`（訊息編號）去重後顯示

---

## 5. 使用者關閉聊天視窗

當用戶點擊聊天室外部置灰區域或聊天室 bar 時，LiveChat Package 會離開聊天室並清除快取。

- **用戶操作**：點擊聊天室外部置灰區域或 bar（關閉 Chatroom）
- **LiveChat Package 行為**：
  - 向伺服器發送 `POST /chat/match/leave` 請求以離開聊天室
  - 清除 cache 的 messages（快取的訊息）

---

## 6. 使用者離開 Live Detail Page

當用戶離開 Live Detail Page 時，LiveChat Package 會取消 WebSocket 訂閱以釋放資源。

- **用戶操作**：離開 Live Detail Page
- **LiveChat Package 行為**：取消 WebSocket 訂閱 `(unsubscribe)`

---

## 技術備註

1. **WebSocket 連線**：LiveChat Package 在進入 Live Detail Page 時自動建立 WebSocket 連線，離開頁面時自動取消訂閱
2. **聊天室 ID 取得**：如果無法取得 `chatroomId`，系統會隱藏 Live Chat Bar，用戶將無法開啟聊天室
3. **訊息合併邏輯**：歷史訊息與即時訊息會依 `messageNo` 去重，確保不會重複顯示
4. **快取管理**：離開聊天室時會清除快取的訊息，下次進入時會重新載入
5. **WebSocket 端點**：`wss://www.encorebet.net/chat/websocket/web-chat`

