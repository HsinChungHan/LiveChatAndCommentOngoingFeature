# TDD UseCase Consolidation Rules（UseCase 收斂策略 – 通用規則）

本文件定義從 mermaid sequenceDiagram 推導 UseCase 時的「收斂策略」。  
其目標是避免：

- UseCase 過度細分  
- UseCase 數量爆炸  
- 序列圖不必要的重複  

並且仍保持：

- **單一職責（Single Responsibility）**
- **依賴方向：UI → Feature → UseCase → Repository → Client → API**
- **Domain Layer（Feature + UseCase）邏輯清晰、可管理、可測試**

> 所有規則皆為「通用 Domain 開發」而設計，不依賴特定領域（如聊天室、留言、交易、購物車等）。

---

## 1. 以「Domain 行為」為切分依據，而不是「UI 行為」

### 1.1 不以 UI 事件或畫面元件命名 UseCase

以下拆法被視為錯誤或過度依 UI 綁定：

- `InitLoadUseCase`
- `RefreshButtonUseCase`
- `TabSwitchUseCase`
- `PullToRefreshUseCase`

因為這些只是 UI「觸發方式」不同，但 Domain 行為相同。

### 1.2 UseCase 應代表 Domain 行為本身

正確示例（通用 Domain 動詞）：

- `ReloadListUseCase`
- `SubmitFormUseCase`
- `UpdateItemStateUseCase`
- `ToggleFlagUseCase`
- `ExecuteActionUseCase`
- `LoadDetailsUseCase`
- `ValidateUserSessionUseCase`
- `ProcessTransactionUseCase`

> 原則：UseCase 名稱應表達「做了什麼」，而不是「怎麼被觸發」。

---

## 2. 同一資源、同一技術行為 → 必須合併

以下三項若皆相同，就不應拆成多個 UseCase：

1. 操作的「Domain 資源」相同（例如同一 List、同一 Item、同一 Record）。  
2. 行為型態相同（都是「讀取資料」或都是「修改資料」）。  
3. 意圖一致，但 UI 的觸發方式不同（init、切換、refresh、retry…）。

### 2.1 使用 Input Model 表達差異，而非拆 UseCase

UseCase Input 可包含：

- `triggerType`（init / refresh / switch / retry）
- `mode`（排序方式、來源）
- `filterType`
- `contextInfo`（選中的項目、所屬場景）
- pagination 資訊（cursor / page / limit）

> UseCase 以 Input Model 決定流程，而不是用「UI 動作名稱」區分。

---

## 3. 可收斂的典型通用情境

以下為「各領域皆通用」的收斂案例。

### 3.1 多種資料載入行為

常見於任何產品（電商、社交、直播、後台管理等）：

- 初次載入
- 手動重新整理
- 切換篩選
- 切換排序
- 分頁 / 載入更多

只要目的都是「載入同一項 Domain Data」，就應合併為：

- `ReloadListUseCase`
- 或 `LoadDataUseCase`

由 Input Model 控制行為差異。

---

### 3.2 多種提交行為

通用例子：

- 送出主內容 / 子內容
- 更新部分欄位
- 編輯 vs 新增（僅差 input 是否有 id）

可合併為泛化的：

- `SubmitDataUseCase`
- `UpdateEntityUseCase`
- `CreateOrUpdateEntityUseCase`

透過 Input Model 表達：

- 是否為新增（id = null）
- 是否為子項目（parentId）
- 修改哪些欄位（patch 欄位）

---

### 3.3 多種狀態切換行為

例如：

- 點讚 / 取消點讚  
- 加入收藏 / 移除收藏  
- 追蹤 / 取消追蹤  
- 開啟 / 關閉某功能  

可收斂為：

- `ToggleStateUseCase`
- `ModifyFlagUseCase`

由 Input Model 帶入：

- `isEnabled` / `targetState`
- target item id

---

### 3.4 資源初始化流程（非常通用）

例如：

- 初始化 Session
- 初始化設定
- 初始化使用者資訊
- 初始化應用程式設定

可以集中於：

- `InitializeContextUseCase`

同樣使用 Input Model 控制細節。

---

## 4. 不應收斂的情況（通用領域）

以下情況請務必保持獨立 UseCase：

### 4.1 Domain 規則不同

若兩段流程需要：

- 不同的驗證邏輯
- 不同的前後條件
- 不同的風險控管文化（如金融交易 vs 內容編輯）

則必須獨立 UseCase。

---

### 4.2 副作用 Side-effect 不同

若某行為會：

- 寫入額外資源
- 觸發通知
- 發送事件（如 WebSocket、MQ、Push）
- 變更上下文狀態

即使使用相同 API，也需拆成不同 UseCase。

---

### 4.3 跨 bounded context（最重要）

跨 Domain boundary 時不得合併：

- 使用者 Domain vs 設定 Domain
- 商品 Domain vs 訂單 Domain
- 帳號 Domain vs 內容 Domain

---

### 4.4 技術模型不同（HTTP vs WS vs 本地儲存）

- HTTP API  
- WebSocket  
- Local Storage  
- Background Task  
- Timer-based polling  

這些都是不同技術語意 → 不應合併為一個 UseCase。

---

## 5. Input / Output 設計原則（通用）

### 5.1 Input Model 必須表達所有可變因素

通用欄位類型：

- triggerType
- mode
- filterType
- sortType
- pagination（cursor / page / limit）
- resourceId / parentId
- contextInfo（畫面上下文）

### 5.2 Output Model 必須貼近 UI 所需

常見 Output：

- 資料（Domain Model）
- 是否還能繼續載入（hasMore）
- 更新後的狀態（例如已更新的 entity）
- 必要的 UI Meta（如是否顯示更多）

---

## 6. Feature 與 UseCase 的合作邊界（通用）

### 6.1 Feature 負責：

- 接收 UI 行為
- 決定要呼叫哪個 UseCase
- 準備 UseCase Input
- 更新 Feature State

### 6.2 UseCase 負責：

- 執行 Domain 行為
- 整合 Repository / Client
- 回傳 Output 給 Feature
- 完全獨立於 UI 與 Feature 型別

---

## 7. 與 mermaid alt / opt / loop 的通用對應

### 7.1 alt / opt

- 若分支邏輯本質相同 → 合併成一個 UseCase，用 Input Flag 區分  
- 若分支本質不同 → 拆成多個 UseCase

### 7.2 loop

代表「同一 UseCase 重複呼叫」  
例如：

- 分頁
- 不斷輪詢
- 反覆重試

而不是多個 UseCase。

---

## 8. 通用命名規則（跨領域皆適用）

好的 UseCase 名稱應使用「動作 + Domain 語意」：

- `LoadDataUseCase`
- `ReloadListUseCase`
- `SubmitFormUseCase`
- `UpdateEntityUseCase`
- `ToggleStateUseCase`
- `InitializeContextUseCase`

壞命名（依 UI 綁定），應避免：

- `ClickTabUseCase`
- `PullToRefreshUseCase`
- `TapButtonUseCase`

因為它們無法表達 Domain 行為。

---

> 本文件為純通用規則，適用於任何領域。  
> 搭配《TDD Module Consolidation Rules》可形成完整的 Domain Layer 設計流程。
