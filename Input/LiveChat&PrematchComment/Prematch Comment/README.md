# Mermaid 流程圖與 YAML 規格檔管理規範

## 目錄結構

```
PRDToMermaid/                        # 專案根目錄
├── rules/                           # 規範文件資料夾（專案根目錄）
│   ├── README.md                    # 規範索引（必讀）
│   ├── system_prompt_template.md    # 系統 Prompt 模板（讓 AI 預設遵循規範）
│   ├── yaml_generation_prompt.md    # YAML 產生 Prompt 規範
│   ├── mermaid_yaml_classification_guide.md  # Mermaid 與 YAML 資訊分類指南
│   └── mermaid_to_description_spec.md  # Mermaid 轉自然語言描述規範
├── .cursorrules                     # Cursor 自動讀取的配置文件
└── Input/
    └── LiveChat&PrematchComment/
        └── Mermaid/
            └── Prematch Comment/
                ├── README.md        # 本文件
                └── [流程資料夾]/
                    ├── mermaid.md   # Mermaid 流程圖代碼
                    ├── description.md  # 自然語言敘述
                    └── flow_spec.yaml  # YAML 規格檔
```

## 使用流程

### 1. 準備資料

每個流程需要準備以下文件：
- `mermaid.md`: Mermaid 流程圖代碼
- `description.md`: 對應的自然語言敘述

### 2. 產生 YAML 規格檔

使用專案根目錄 `rules/yaml_generation_prompt.md` 中的 prompt 範本，要求 AI 根據 Mermaid 代碼和自然語言敘述產生 YAML 規格檔。

### 3. YAML 檔案結構

YAML 檔案必須包含以下結構：

```yaml
features:
  {FeatureName}:
    flows:
      - flow_id: {FLOW_ID}
        flow_type: {Full|Sub}
        flow_name: {流程名稱}
        parent_flow_id: {父流程ID|null}
        parent_flow_name: {父流程名稱|null}
        original_annotation: "@flow: {Full|Sub}"
        mermaid_code: |
          [完整的 Mermaid 代碼]
        description: |
          [完整的自然語言敘述]
        api_endpoints: [...]
        notes: [...]
        scenarios: [...]
        user_actions: [...]
        system_behaviors: [...]
```

## 欄位說明

### 識別欄位

| 欄位 | 說明 | 範例 |
|------|------|------|
| `feature` | 功能模組名稱 | `PrematchComment` |
| `flow_id` | 流程唯一識別碼 | `PC-FULL-001`, `PC-SUB-001` |
| `flow_type` | 流程類型 | `Full`（主流程）或 `Sub`（子流程） |
| `flow_name` | 流程名稱 | `用戶進入 Upcoming Race Page, Prematch Comment Page 與 Top` |
| `parent_flow_id` | 父流程 ID | 主流程為 `null`，子流程為父流程的 `flow_id` |
| `parent_flow_name` | 父流程名稱 | 主流程為 `null`，子流程為父流程的 `flow_name` |
| `original_annotation` | 原始註解標記 | `@flow: Full` 或 `@flow: Sub` |

### flow_id 命名規則

- **主流程**：`{FEATURE_PREFIX}-FULL-{序號}`
  - 範例：`PC-FULL-001`（PrematchComment 的第一個主流程）
- **子流程**：`{FEATURE_PREFIX}-SUB-{序號}`
  - 範例：`PC-SUB-001`（PrematchComment 的第一個子流程）

### 補充資訊欄位

| 欄位 | 說明 | 內容類型 |
|------|------|----------|
| `mermaid_code` | Mermaid 流程圖代碼 | 完整代碼（保留原始格式） |
| `description` | 自然語言敘述 | 完整敘述（保留原始格式） |
| `api_endpoints` | API 端點列表 | 結構化 API 資訊 |
| `notes` | 技術備註 | 文字列表 |
| `scenarios` | 情境說明 | 結構化情境資訊 |
| `user_actions` | 用戶操作列表 | 結構化操作資訊 |
| `system_behaviors` | 系統行為列表 | 結構化行為資訊 |

## 範例

### 主流程範例

參考：`User 進入 Upcoming Race Page, Prematch Comment Page 與 Top/flow_spec.yaml`

### 子流程範例

可參考主流程範例的結構，將 `flow_type` 設為 `Sub`，並設定 `parent_flow_id` 和 `parent_flow_name`。

## 關聯性說明

### Feature 與 Flow 的關聯

- 使用 `feature` 作為頂層組織單位
- 每個 `feature` 下可包含多個 `flows`
- 每個 `flow` 透過 `flow_id` 唯一識別

### 主流程與子流程的關聯

- 子流程透過 `parent_flow_id` 和 `parent_flow_name` 關聯到主流程
- 主流程的 `parent_flow_id` 和 `parent_flow_name` 為 `null`

### 補充資訊的關聯

- 所有補充資訊（mermaid_code、description、api_endpoints 等）都屬於特定的 `flow`
- 透過 YAML 的巢狀結構，確保補充資訊與對應的 flow 緊密關聯

## 使用規範文件

### 📌 讓 AI 預設遵循所有規範

**重要**：已建立 `.cursorrules` 配置文件，Cursor 會自動讀取並遵循規範，無需每次手動提醒！

#### ⭐ 方式 1：使用 .cursorrules（最推薦，已自動設定）

專案根目錄已建立 `.cursorrules` 文件，Cursor 會自動讀取並遵循所有規範。**無需任何額外操作**，AI 會自動應用這些規則。

#### 方式 2：使用系統 Prompt 模板（備用方案）

如果需要手動提醒，可以在對話開始時複製並發送專案根目錄 `rules/system_prompt_template.md` 中的內容。

#### 方式 3：簡短引用（備用方案）

```
請遵循專案根目錄 `rules/README.md` 中的所有規範進行操作。
```

### 規範文件說明

#### 規範索引
- **`rules/README.md`**（專案根目錄）：所有規範的索引和說明，建議先閱讀此文件

#### 系統 Prompt 模板
- **`rules/system_prompt_template.md`**（專案根目錄）：讓 AI 預設遵循規範的 Prompt 模板

#### 具體規範文件（位於專案根目錄 `rules/`）

1. **YAML 產生規範**：`rules/yaml_generation_prompt.md`
   - 適用於：產生或更新 YAML 規格檔時
   - 定義 YAML 結構、必要欄位、命名規則等

2. **資訊分類指南**：`rules/mermaid_yaml_classification_guide.md`
   - 適用於：新增或更新業務邏輯時
   - 定義如何判斷資訊應該加入 Mermaid Flow 還是 YAML

3. **描述產生規範**：`rules/mermaid_to_description_spec.md`
   - 適用於：從 Mermaid 產生或更新 description.md 時
   - 定義描述文件的結構和格式規範

### 快速使用

```
請根據以下文件產生 YAML：
- mermaid.md: [文件路徑]
- description.md: [文件路徑]

這是一個[主流程/子流程]，feature 為 [FeatureName]，flow_name 為「[流程名稱]」。
[如果是子流程，請加上：parent_flow_id 為 [父流程ID]，parent_flow_name 為「[父流程名稱]」。]
```

## 新增業務邏輯

當你需要新增業務邏輯時，只需描述新的功能需求，AI 會自動：

1. **判斷資訊分類**：根據專案根目錄 `rules/mermaid_yaml_classification_guide.md` 的規則，自動判斷哪些資訊加入 Mermaid Flow，哪些加入 YAML
2. **更新 Mermaid Flow**：加入時序互動和流程控制結構
3. **更新 YAML**：加入詳細的結構化資訊（API 規格、技術備註、情境說明等）
4. **保持一致性**：確保兩者資訊一致且互補

### 使用範例

```
我在「用戶進入 Prematch Comment Page」這個流程中新增了以下業務邏輯：

[描述你的業務邏輯]

請幫我判斷哪些資訊要加到 mermaid flow，哪些要加到 YAML，並自動更新對應的文件。
```

## 注意事項

1. **保持原始格式**：Mermaid 代碼和自然語言敘述應完整保留，包括所有換行和縮排
2. **提取結構化資訊**：盡可能將自然語言敘述中的資訊提取到對應的結構化欄位中
3. **關聯性驗證**：確保 YAML 中的資訊與原始文件一致
4. **擴展性**：YAML 結構應易於擴展，以支援未來新增的補充資訊類型
5. **資訊分類**：參考專案根目錄 `rules/mermaid_yaml_classification_guide.md` 確保資訊分類正確

