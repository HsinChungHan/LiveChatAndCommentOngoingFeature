# TDD Layers & Responsibilities

本文件定義 TDD 中所有 Layer 的職責與依賴方向，是所有規範檔案中的**最高優先級**規則。

---

## 1. Mermaid 抽象層級

從使用者提供的 mermaid sequenceDiagram 中，你必須抽取出以下角色與層級：

- User interaction（User 必須以 actor 小人呈現，不屬任何 Layer）
- View（UI）
- Feature（TCA Reducer）
- UseCase（商業邏輯）
- Domain Models（純實體，不作為 participant）
- Repository
- Client（HTTP / WebSocket / gRPC / Storage）
- API（後端 Endpoint）
- Shared Modules（Auth、Profile、Nickname、UserInfo、Blacklist 等）

所有流程必須抽象化為固定依賴序列：

**User → View → Feature → UseCase → Repository → Client → API**

絕對禁止越層呼叫。

---

## 2. 各 Layer 職責定義（新版命名）

### 2.1 UI Layer（View）

- 接收 user action
- 顯示 UI
- 觸發 Feature Action
- 不可包含商業邏輯
- 可在序列圖中添加 Note（內容需為中文）：
  - 範例：  
    - `Note right of View: 使用者觸發重新整理`  
    - `Note right of View: UI 發出載入列表的 Action`

---

### 2.2 Domain Layer（Feature + UseCase）

> 原先的 Application Layer（Feature+UseCase）正式改名為 **Domain Layer**。

#### 🔹 Feature Layer（Thin Reducer）

- UI orchestration（將 UI event 轉成 Action）
- 將 Action 轉為 UseCase Input
- 呼叫 UseCase
- 接收 UseCase Output 更新 State
- 不含商業邏輯
- 在序列圖中可添加 Note（需為中文）：
  - `Note right of Feature: Feature 收到載入動作`
  - `Note right of Feature: Feature 呼叫對應 UseCase`
  - `Note right of Feature: Feature 更新狀態為載入中`

#### 🔹 UseCase Layer（Business Logic）

- 所有商業邏輯唯一來源
- 執行 Domain 行為（例如重新載入列表、送出留言、送出聊天訊息）
- 負責驗證與流程控制
- 整合多個 Repository
- 處理跨 Feature 的共用邏輯（例如 Auth、Nickname、Permission）
- 回傳 Domain Model 或純 Result 給 Feature
- 在序列圖中，以 participant（淡金色）呈現

#### 🔹 Domain Layer（大框）

在 sequenceDiagram 中：

- Feature + UseCase 必須被同一個大框包含
- 大框名稱為：**Domain Layer**
- 顏色建議：`rgb(245,245,245)`（作為背景填滿）

> 注意：這裡的「Domain Layer」是指 **Domain 行為層（Feature+UseCase）**，與純資料模型層（Domain Model Layer）不同。

---

### 2.3 Domain Model Layer（Entity）

- 純 Domain Entity / Value Object
- 不包含流程控制或商業邏輯
- 不依賴 Repository / API / Client
- **不作為 sequenceDiagram 的 participant**（不畫出來）

此層專注描述資料結構與基本不變條件。

---

### 2.4 Repository Layer

- Domain 資料來源的抽象介面
- 呼叫 Client，取得或更新遠端 / 本地資料
- 負責將 DTO 轉換為 Domain Model
- 不處理商業邏輯（例如權限 / 驗證流程）
- 必須包含在 Data & Infrastructure Layer 大框中

---

### 2.5 Client Layer

- 負責所有技術通訊：
  - HTTP
  - WebSocket
  - gRPC
  - Local Storage / DB 等
- 負責 request / response / payload 的編解碼
- 不包含 Domain 商業邏輯
- 必須包含在 Data & Infrastructure Layer 大框中

---

### 2.6 API Layer（Infrastructure）

- 代表後端 endpoint 或外部服務
- 定義 URL / HTTP method / payload 形狀
- 只能被 Client 呼叫：
  - UseCase / Feature 不得直接依賴 API
- 必須包含在 Data & Infrastructure Layer 大框中

---

### 2.7 Data & Infrastructure Layer（大框）

- Repository / Client / API 三層必須包在同一個大框中：
  - 名稱：**Data & Infrastructure Layer**
  - 顏色建議：`rgb(240,240,240)`（背景填滿）
- 禁止將 Repository / Client / API 各自拆成多個獨立 box。

---

## 3. 依賴方向（最高優先級規則）

依賴方向嚴格限制為：

**UI → Feature → UseCase → Repository → Client → API**

以下行為一律禁止：

- Feature 直接呼叫 Repository 或 Client
- UseCase 依賴 UI / View / Feature
- Repository 依賴 UI / Feature / UseCase
- Client 直接被 View / Feature 使用
- API 被 UseCase / Feature 直接呼叫

所有架構圖、序列圖與模組清單，都必須完全符合以上依賴方向。

---

## 4. 與其他規範檔案的對應

- 本檔案為所有規則中的**最高優先層級**。
- 若其他檔案（例如 sequence 規範、module 收斂規範）在 Layer 命名或依賴方向上與本檔案有衝突，以本檔案為準。
- 尤其是：
  - sequenceDiagram 中的三個 box：**UI / Domain / Data & Infrastructure**
  - Domain Layer = Feature + UseCase
  - Domain Model Layer = 純 Entity（不畫 participant）
