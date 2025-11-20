# 用戶進入 Upcoming Race Page、Prematch Comment Page 與 Top 流程說明

## 流程概述

本文件描述用戶從進入賽事詳情頁面到使用賽前留言功能的完整流程，包括個人資訊取得、留言顯示、標籤切換、手動刷新等情境。本流程涉及以下參與者：**User（用戶）**、**App（應用程式）** 和 **Server（伺服器）**。

**注意**：關於 Event Status 訂閱與通知的詳細流程，請參考「Event Status 訂閱與通知流程」文件。

---

## 1. 進入頁面與取得個人資訊

當用戶進入 **Race Detail Page（賽事詳情頁面）** 時，應用程式會自動向伺服器發送請求以取得用戶的個人資訊。

- **用戶操作**：進入 Race Detail Page
- **應用程式行為**：向伺服器發送 `GET /{TBD 個人資訊 API}` 請求
  - ⚠️ **注意事項**：需與 Eason 確認實際 API，或確認是否可與 Han 的流程串接
- **伺服器回應**：回傳 `userInfo`（用戶資訊）
- **應用程式處理**：將 `userInfo` 儲存在客戶端（例如暫存在記憶體或 state 中）

---

## 2. 取得賽事留言與投注資訊

在取得用戶個人資訊後，應用程式會進一步取得該賽事的留言統計與投注資訊。

- **應用程式行為**：向伺服器發送 `GET /chat/match/comment/info/{refId}` 請求
- **伺服器回應**：回傳包含 `commentCount`（留言數量）和 `betCount`（投注數量）的資訊

---

## 3. 進入 Prematch Comment Page（預設顯示 Top 標籤）

當用戶進入 **Prematch Comment Page（賽前留言頁面）** 時，系統預設會顯示 **Top** 標籤的內容。

- **用戶操作**：進入 Prematch Comment Page
- **應用程式行為**：
  - 預設標籤為 **Top**（🟢 Default tab is Top）
  - 向伺服器發送 `GET /chat/match/comment/popular` 請求
- **伺服器回應**：回傳按讚數排序的留言列表（comments sorted by like）

---

## 4. 切換標籤（Tab Switching）

用戶可以在 **Top** 和 **Newest** 兩個標籤之間進行切換，以查看不同排序方式的留言。

- **用戶操作**：切換標籤

### 情境 A：切換至 Newest 標籤
- **應用程式判斷**：目前為 Newest tab
- **應用程式行為**：向伺服器發送 `GET /chat/match/comment/newest` 請求
- **伺服器回應**：回傳按時間排序的留言列表（comments sorted by time）

### 情境 B：維持在 Top 標籤
- **應用程式判斷**：使用者維持在 Top tab
- **應用程式行為**：向伺服器發送 `GET /chat/match/comment/popular` 請求
- **伺服器回應**：回傳留言列表

---

## 5. 使用者手動刷新（Manual Refresh）

用戶可以透過點擊「Refresh button（刷新按鈕）」來手動更新留言內容。

- **用戶操作**：點擊「Refresh button」

### 情境 A：目前在 Top 標籤
- **應用程式行為**：向伺服器發送 `GET /chat/match/comment/popular` 請求
- **伺服器回應**：回傳最新的留言列表（按讚數排序）

### 情境 B：目前在 Newest 標籤
- **應用程式行為**：向伺服器發送 `GET /chat/match/comment/newest` 請求
- **伺服器回應**：回傳最新的留言列表（按時間排序）

---

---

## 技術備註

1. **個人資訊 API**：目前 API 路徑為待定（TBD），需與相關人員確認實際端點
2. **資料儲存**：用戶資訊儲存在客戶端，建議使用記憶體或 state 管理
3. **預設行為**：Prematch Comment Page 預設顯示 Top 標籤（按讚數排序）
4. **狀態管理**：應用程式需追蹤當前標籤狀態，以便在刷新時發送正確的 API 請求
5. **Event Status 訂閱與通知**：關於 Event Status 訂閱與通知的詳細流程，請參考「Event Status 訂閱與通知流程」文件

