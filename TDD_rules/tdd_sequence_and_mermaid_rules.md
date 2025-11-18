# TDD Sequence & Mermaid Rules

本文件定義：

- 各 View 如何拆出 Use Case 序列圖（View-Level 規範）
- sequenceDiagram 的分層、顏色、Notes 與 User actor 規範
- Mermaid sequenceDiagram 的「安全輸出規範」，確保 mermaid.live 能正常渲染

---

## 1. View-Level Use Case 序列圖產生規範（價值導向）

### 1.1 每個 View 至少應有三類序列圖（若有該行為）

1. **Data Initialization / Refresh**
   - 畫面初始化載入（進入畫面時）
   - 使用者手動 Refresh / Retry

2. **Data Interaction**
   - 任何會變動 Domain 狀態或呼叫 API / WebSocket 的操作  
   - 如：送出留言、載入分頁資料、送出聊天訊息、變更按讚狀態

3. **Structural Navigation**
   - 涉及權限 / Auth / Nickname / Profile 等 Shared Feature 的檢查  
   - 如：點擊使用者 → Profile

若某 View 完全不包含該行為，可省略對應序列圖。

---

### 1.2 必須進行合併的 Use Cases（避免圖量過多）

以下情境應合併為一張圖並使用 `alt`：

- Initial load / Pull-to-refresh（皆屬「載入資料」）
- 多種資料更新流程類似（如 top / newest）
- 多種 Navigation 行為但前置檢查一致

---

### 1.3 可以省略的序列圖

- 純前端 UI 行為，不涉及後端或 Domain 狀態
- 與既有序列圖 90% 相同（可用註記描述差異）
- 純 Domain 計算邏輯（以文字或 test spec 描述）

---

### 1.4 每個 View 理想序列圖數量

建議維持：**2～5 張**  
若涉及 Pagination、WebSocket 或多組 Shared Feature，可能略增。

---

### 1.5 序列圖 Participant 規範

需包含：

- User（actor，小人符號，不屬任何 Layer）
- View
- Feature
- UseCase
- Repository
- Client（HTTP / WebSocket）
- API（後端 endpoint）
- Shared Feature（如 AuthFeature）

資料流固定：

**User → View → Feature → UseCase → Repository → Client → API**

禁止越層呼叫。

---

## 2. Mermaid sequenceDiagram 圖產生與安全輸出規範

所有由系統產生的 Mermaid 序列圖必須遵守以下規則，以避免渲染錯誤。

---

### 2.1 通用限制（mermaid.live 友善）

- 不使用 `classDef`、`class`
- 不使用 `<br/>`、`\n` 手動換行
- 不使用未轉義特殊字元
- 所有 participant ID 必須唯一
- 所有 `box` 宣告必須在任何箭頭訊息之前完成

---

## 2.2 box 使用與分層佈局規則

### 2.2.1 禁止使用巢狀 box（No Nested Box）

- 任何 `box` 內不得再放置另一個 `box`
- 所有 box 必須平行展開
- `box` 內只能包含：
  - `participant`
  - `participant actor`（但 User 不能被放入任何 box）

---

### 2.2.2 Feature Layer 與 UseCase Layer 必須在同一個 box 中

- **Domain Layer**（取代原 Application Layer 名稱）  
  必須使用**單一個 box**包含：
  - Feature participants  
  - UseCase participants  

不得拆解成獨立 box。

---

### 2.2.3 Repository / Client / API 必須在同一個 box 中

- **Data & Infrastructure Layer**  
  使用**單一 box**包含：
  - 所有 Repository participants  
  - 所有 Client participants  
  - 所有 API participants  

不得拆成三個 box。

---

### 2.2.4 Layer box 配置（sequenceDiagram 專用）

在序列圖中僅能使用三個 box：

---

#### **1. User actor（獨立於所有 box 之外）**
- 使用 `actor User`
- **不得放入任何 box**
- 必須置於最左側，在所有 box 之前宣告

---

#### **2. UI Layer（需背景填滿色）**
- 顏色：`rgb(207,232,255)`（淡藍）
- 內含 View participants
- **不包含 User actor**

---

#### **3. Domain Layer（Feature + UseCase，需背景填滿色）**
- 顏色：`rgb(255,250,205)`（淡金色）
- 內含 Feature 與 UseCase participants

---

#### **4. Data & Infrastructure Layer（Repository + Client + API，需背景填滿色）**
- 顏色：`rgb(240,240,240)`（淡灰）
- 內含 Repository / Client / API participants
- **重要：同一組的 Repository、Client、API 必須相鄰排列**
  - 例如：`PrematchCommentRepository`、`PrematchCommentClient`、`PrematchCommentAPI` 應該連續出現
  - 而非所有 Repository 在一起、所有 Client 在一起、所有 API 在一起
- 排列順序建議：按資源分組，每組內為 Repository → Client → API

---

### 註：
flowchart（架構圖）仍允許 Feature / UseCase / Repository / Client / API 各自不同顏色；  
唯 **sequenceDiagram 必須遵守三大 box + 獨立 User actor**，且禁止巢狀。

---

## 2.3 User actor 規範

- 使用 `actor User`
- 顯示小人圖示
- User **不得放入任何 box**
- User 必須置於最左側

---

## 2.4 Note 規範（UI / Feature Layer）

---

### 2.4.0 Note 語言規範（新增）

- 所有 Note 的文字內容必須使用 **中文**。
- 除必要技術名詞外（如 refId、cursor、loadUserInfo），不可混用英文。
- 文案需精簡，描述明確，不使用長段落。
- 仍須遵守 Note 安全字元規範（不得含冒號、尖括號、花括號、分號等）。

範例（正確）：

Note right of View: 使用者進入頁面觸發載入流程
Note right of Feature: Feature 收到載入動作後呼叫 UseCase


範例（錯誤）：

Note right of View: User taps refresh
Note right of Feature: delegates to use case


---

### 2.4.1 Note 安全內容規則

- Note 文案不得包含 `:`（除了語法的第一個冒號）
- Note 文案不得包含：
  - `;`
  - `{ }`
  - `< >`
  - `|`
  - emoji
  - Markdown 特殊字元（`**`, `__`, `~~`）

建議使用中文短句敘述行為，不使用表達式或程式碼片段。

---

### 2.4.2 UI Layer Notes

- 位置：`Note right of View`
- 用途包含：
  - 描述 User 觸發行為
  - 描述 View 派送 Feature action
  - 描述 UI loading 或狀態更新

---

### 2.4.3 Feature Layer Notes

- 位置：`Note right of Feature`
- 用途包含：
  - 描述 Feature 接收 action
  - 描述 Feature 呼叫 UseCase
  - 描述 Feature 更新 state（需為純 UI orchestration）

---

## 2.5 box 宣告順序

必須在所有箭頭訊息之前完成 box 宣告。

建議順序：

1. `title`
2. `actor User`（獨立於所有 box 之外）
3. UI Layer box
4. Domain Layer box
5. Data & Infrastructure Layer box
6. 所有 participants（User 已在步驟 2 宣告，此處宣告其他 participants）
7. 互動箭頭  
8. Notes（中文）

**注意：User actor 必須在所有 box 之前宣告，且不屬於任何 box。**

---

## 2.6 避免使用易壞解析的特殊字元

以下字元不可出現在序列圖任何欄位：

- `{ }`
- `< >`
- `|`
- emoji
- Markdown 格式字元（如 `**`, `_`, `~~`）

模式差異需以純文字描述：

- 正確：`comments top mode`
- 不建議：`comments (top)`

---

## 2.7 Title 規則（純文字強制）

- title 必須放在序列圖最上方
- Title 僅能使用純文字
- 不得包含：
  - `[]`
  - `""`
  - 特殊符號（如箭頭 `→`）
  - emoji
  - HTML

建議格式：

title PrematchComment Full Prematch Comment 主流程 RaceDetailView InitialLoad

---
