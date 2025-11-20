# Client Side RD 工作流程：從 PRD/API Spec 到 TDD 與 Ticket 生成

## 工作流程總覽

```
PM PRD + BE API Spec
    ↓
[階段 1] 需求分析與流程設計
    ↓
[階段 2] 產生 Input 資料（Mermaid + Description + YAML）
    ↓
[階段 3] 生成 TDD 所有章節
    ↓
[階段 4] 生成 Ticket 與估時
    ↓
開發實作
```

---

## 階段 1：需求分析與流程設計

### 1.1 輸入資料

| 資料來源 | 格式 | 說明 |
|---------|------|------|
| **PM PRD** | Markdown / Word / Confluence | 產品需求文件，包含業務需求、使用者故事、功能規格 |
| **BE API Spec** | OpenAPI / Swagger / Markdown | 後端 API 規格，包含 Endpoints、Request/Response Schema |

### 1.2 工作內容

#### 1.2.1 需求理解與分析

**負責人**：Client Side RD（可與 PM、BE 協作）

**工作內容**：
1. 閱讀 PRD，理解業務需求和使用者故事
2. 閱讀 API Spec，理解後端提供的 API 端點和資料結構
3. 識別 Feature 邊界（一個 Feature 對應一個業務功能模組）
4. 識別 Flow 類型：
   - **主流程（Full Flow）**：完整的業務流程，從使用者觸發到完成
   - **子流程（Sub Flow）**：主流程中的特定階段或分支流程

**產出**：
- Feature 列表（如：PrematchComment、LiveChat）
- Flow 列表（每個 Flow 的 flow_id、flow_type、flow_name）

**估時**：
- Junior：2-3 天
- Mid-level：1-2 天
- Senior：0.5-1 天

#### 1.2.2 流程設計（Mermaid Sequence Diagram）

**負責人**：Client Side RD

**工作內容**：
1. 根據 PRD 和 API Spec，設計 Mermaid Sequence Diagram
2. 識別參與者（Participants）：
   - User（actor）
   - View（UI Layer）
   - Feature（Domain Layer）
   - UseCase（Domain Layer）
   - Repository（Data & Infrastructure Layer）
   - Client（Data & Infrastructure Layer）
   - API（Data & Infrastructure Layer）
   - External Package（如需要）
   - Server（後端）
3. 設計互動流程：
   - 使用者觸發行為
   - View → Feature → UseCase → Repository → Client → API → Server
   - 條件分支（alt/opt）
   - 迴圈（loop）
4. 標註 Flow 類型：
   - 使用 `@feature: {FeatureName}` 標註 Feature
   - 使用 `@flow: Full` 或 `@flow: Sub` 標註 Flow 類型

**產出**：
- `mermaid.md`：Mermaid Sequence Diagram 代碼

**估時**：
- Junior：3-5 天（每個 Flow）
- Mid-level：2-3 天（每個 Flow）
- Senior：1-2 天（每個 Flow）

**檢查清單**：
- [ ] 所有 Participants 已識別
- [ ] 互動流程符合 Clean Architecture 分層
- [ ] 條件分支和迴圈已正確標註
- [ ] Flow 類型已標註（@feature、@flow）

---

## 階段 2：產生 Input 資料（Mermaid + Description + YAML）

### 2.1 產生 Description（自然語言敘述）

**負責人**：Client Side RD

**工作內容**：
1. 根據 Mermaid Sequence Diagram，撰寫自然語言敘述
2. 包含以下章節：
   - 流程概述
   - 參與者說明
   - 流程步驟詳述
   - 技術備註
   - 前置條件與限制

**產出**：
- `description.md`：自然語言敘述文件

**估時**：
- Junior：1-2 天（每個 Flow）
- Mid-level：0.5-1 天（每個 Flow）
- Senior：0.5 天（每個 Flow）

**檢查清單**：
- [ ] 流程概述完整
- [ ] 所有參與者已說明
- [ ] 流程步驟清晰
- [ ] 技術備註完整

### 2.2 產生 YAML Flow Spec

**負責人**：Client Side RD（可使用 AI 輔助）

**工作內容**：
1. 根據 `mermaid.md` 和 `description.md`，產生結構化的 YAML 規格檔
2. 包含以下結構：
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
           packages:
             - name: {Package名稱}
               type: {external|internal}
               description: {說明}
           api_endpoints: [...]
           scenarios: [...]
           system_behaviors: [...]
           notes: [...]
   ```

**產出**：
- `flow_spec.yaml`：結構化的 YAML 規格檔

**估時**：
- Junior：2-3 天（每個 Flow，使用 AI 輔助可縮短至 1-2 天）
- Mid-level：1-2 天（每個 Flow，使用 AI 輔助可縮短至 0.5-1 天）
- Senior：0.5-1 天（每個 Flow，使用 AI 輔助可縮短至 0.5 天）

**檢查清單**：
- [ ] Flow ID 和類型正確
- [ ] 主流程和子流程關係正確（parent_flow_id）
- [ ] Package 類型標註正確（external/internal）
- [ ] API Endpoints 完整
- [ ] Scenarios 完整
- [ ] System Behaviors 完整

### 2.3 Input 目錄結構

**標準目錄結構**：
```
Input/
└── {Feature組合名稱}/
    └── Mermaid/
        └── {Feature名稱}/
            ├── README.md              # Feature 說明文件
            └── [流程資料夾]/
                ├── mermaid.md         # Mermaid 流程圖代碼
                ├── description.md     # 自然語言敘述
                └── flow_spec.yaml     # YAML 規格檔
```

**範例**：
```
Input/
└── LiveChat&PrematchComment/
    └── Mermaid/
        └── Prematch Comment/
            ├── README.md
            └── Event Status 訂閱與通知流程/
                ├── mermaid.md
                ├── description.md
                └── flow_spec.yaml
```

---

## 階段 3：生成 TDD 所有章節

### 3.1 輸入資料

- `Input/` 目錄下的所有文件（mermaid.md、description.md、flow_spec.yaml）

### 3.2 工作內容

**負責人**：Client Side RD（可使用 AI 輔助，基於 TDD_rules/ 下的所有規範）

**工作流程**：
1. 讀取 Input 目錄結構
2. 解析每個 Flow 的資料（mermaid.md、description.md、flow_spec.yaml）
3. 識別 Package 層級和跨 Package 通訊
4. 處理 WebSocket 訂閱流程
5. 將 YAML Flow Spec 轉換為 TDD 章節
6. 整合多個 Flow（主流程和子流程）
7. 生成完整的 TDD 文件

### 3.3 TDD 章節生成順序

#### 必要章節（Required）

1. **00_Overview（概述）**
   - Feature 目的、範圍、主要使用者互動
   - 資料來源引用（Input 路徑）

2. **01_Integrated Service-Level Sequence Diagram（整合服務層級序列圖）**
   - 整合主流程和子流程的完整序列圖
   - 使用 3-box 結構（UI Layer、Domain Layer、Data & Infrastructure Layer）

3. **02_Architecture（架構）**
   - Clean Architecture 概覽
   - Feature 架構圖
   - Shared Modules 架構
   - External Package 整合架構

4. **03_Module Responsibility（模組職責）**
   - 所有模組的職責說明（表格呈現）

5. **04_Domain Model（領域模型）**
   - Entity 和 Value Object 定義
   - Domain Model 關係圖（語意化 + 標準 UML）
   - DTO → Domain Model Mapping 規則

6. **05. Module Sequence Diagram（模組序列圖）**
   - 詳細的模組互動序列圖
   - 按功能分類組織（Data Initialization、Data Interaction、Structural Navigation）

#### 可選章節（Optional）

7. **06. Feature State & Action (TCA)** ⚠️ Optional
   - 每個 Feature 的 State 結構定義
   - 所有 Action 及其語意
   - 哪些 Action 會觸發哪些 UseCase

8. **07. UseCase Input & Output Model** ⚠️ Optional
   - 每個 UseCase 的 Input Model 定義
   - 每個 UseCase 的 Output Model 定義
   - 與 Domain Model、DTO 的關係

9. **08_API Spec & Mapping** ⚠️ Optional
   - URL / Method 定義
   - Request DTO / Response DTO 定義
   - 所屬 Repository / Client / UseCase
   - DTO → Domain Model Mapping 規則

10. **09_Error Handling** ⚠️ Optional
    - 每個 UseCase 的錯誤分類（Validation / Network / Backend）
    - UI 呈現方式
    - 是否自動 retry / reconnect

11. **10_Test Scenarios** ⚠️ Optional
    - 依照 alt / opt / loop 推導所有測試案例
    - 包含 Basic、Branch、Optional、Loop、Error、Recover、Edge Case

12. **11_Risks & Questions** ⚠️ Optional
    - 未定義的需求
    - 不確定的 Backend 行為
    - 時序 / 效能 / TTL / retry policy 的風險
    - TODO / 需後端確認項

### 3.4 估時

**使用 AI 輔助生成**：
- Junior：3-5 天（完整 TDD，包含所有章節）
- Mid-level：2-3 天（完整 TDD，包含所有章節）
- Senior：1-2 天（完整 TDD，包含所有章節）

**手動生成**（不建議）：
- Junior：10-15 天
- Mid-level：7-10 天
- Senior：5-7 天

### 3.5 檢查清單

- [ ] 所有必要章節已生成
- [ ] Flow 關係正確（主流程和子流程）
- [ ] Package 類型標註正確（external/internal）
- [ ] 模組職責說明完整
- [ ] Domain Model 定義完整
- [ ] 序列圖符合規範（3-box 結構、Note 精簡原則）
- [ ] 所有章節符合 TDD_rules/ 下的規範

---

## 階段 4：生成 Ticket 與估時

### 4.1 輸入資料

- TDD 文件（特別是 `03_Module Responsibility`、`04_Domain Model`、`05. Module Sequence Diagram`）

### 4.2 工作內容

**負責人**：Client Side RD（可使用 AI 輔助）

**工作流程**：
1. 根據 Clean Architecture 分層，識別所有需要開發的模組
2. 按照依賴順序生成 Ticket：
   - Domain Model Layer（優先）
   - Data & Infrastructure Layer（次優先）
   - Domain Layer（UseCase → Feature）
   - UI Layer（最後）
3. 為每個 Ticket 估算開發時間（Story Point → 實際工時）

### 4.3 Ticket 生成順序

#### 4.3.1 Domain Model Layer（優先）

**Ticket 類型**：
- Entity 定義
- Value Object 定義
- Domain Model 關係定義

**估時基準**：
- Entity：1-2 SP（Junior: 1.5-3 天，Mid: 1-2 天，Senior: 0.5-1 天）
- Value Object：1 SP（Junior: 1.5 天，Mid: 1 天，Senior: 0.5 天）

#### 4.3.2 Data & Infrastructure Layer（次優先）

**Ticket 類型**：
- API 定義
- Client 實作
- Repository 實作

**估時基準**：
- API：1-2 SP（Junior: 1.5-3 天，Mid: 1-2 天，Senior: 0.5-1 天）
- Client：2-3 SP（Junior: 3-4.5 天，Mid: 2-3 天，Senior: 1-1.5 天）
- Repository：2-3 SP（Junior: 3-4.5 天，Mid: 2-3 天，Senior: 1-1.5 天）

#### 4.3.3 Domain Layer（UseCase → Feature）

**Ticket 類型**：
- UseCase 實作
- Feature（TCA Reducer）實作

**估時基準**：
- UseCase：3-5 SP（Junior: 4.5-7.5 天，Mid: 3-5 天，Senior: 1.5-2.5 天）
- Feature：2-3 SP（Junior: 3-4.5 天，Mid: 2-3 天，Senior: 1-1.5 天）

#### 4.3.4 UI Layer（最後）

**Ticket 類型**：
- View 實作
- UI 整合測試

**估時基準**：
- View：3-5 SP（Junior: 4.5-7.5 天，Mid: 3-5 天，Senior: 1.5-2.5 天）

### 4.4 Ticket 內容結構

每個 Ticket 必須包含：
- Ticket ID（唯一識別碼）
- 標題（簡潔描述）
- 類型（UseCase / Repository / Client / API / Feature / View）
- 優先級（P0 / P1 / P2 / P3）
- 所屬 Feature
- 依賴 Ticket
- 描述
- 需求清單
- 驗收條件
- 相關文件連結
- 估時（Story Point + 各等級實際工時）

### 4.5 估時

**使用 AI 輔助生成**：
- Junior：1-2 天（生成所有 Ticket 和估時）
- Mid-level：0.5-1 天（生成所有 Ticket 和估時）
- Senior：0.5 天（生成所有 Ticket 和估時）

**手動生成**（不建議）：
- Junior：3-5 天
- Mid-level：2-3 天
- Senior：1-2 天

### 4.6 檢查清單

- [ ] 所有模組都有對應的 Ticket
- [ ] Ticket 依賴關係正確
- [ ] 估時合理（符合 Story Point 和工程師等級）
- [ ] Ticket 內容完整（描述、需求、驗收條件、相關文件）

---

## 階段 5：開發實作

### 5.1 開發順序

按照 Ticket 的依賴順序進行開發：
1. Domain Model Layer
2. Data & Infrastructure Layer
3. Domain Layer
4. UI Layer

### 5.2 開發檢查

每個 Ticket 完成後，檢查：
- [ ] 符合 TDD 文件中的設計
- [ ] 符合 Clean Architecture 分層
- [ ] Unit Test 覆蓋率達標
- [ ] Integration Test 通過
- [ ] Code Review 通過

---

## 總估時總結

### 完整流程估時（使用 AI 輔助）

| 階段 | Junior | Mid-level | Senior |
|------|--------|-----------|--------|
| 階段 1：需求分析與流程設計 | 5-8 天 | 3-5 天 | 1.5-3 天 |
| 階段 2：產生 Input 資料 | 3-5 天 | 1.5-3 天 | 1-2 天 |
| 階段 3：生成 TDD 所有章節 | 3-5 天 | 2-3 天 | 1-2 天 |
| 階段 4：生成 Ticket 與估時 | 1-2 天 | 0.5-1 天 | 0.5 天 |
| **總計** | **12-20 天** | **7-12 天** | **4-7.5 天** |

### 完整流程估時（手動，不建議）

| 階段 | Junior | Mid-level | Senior |
|------|--------|-----------|--------|
| 階段 1：需求分析與流程設計 | 5-8 天 | 3-5 天 | 1.5-3 天 |
| 階段 2：產生 Input 資料 | 6-10 天 | 4-6 天 | 2-3 天 |
| 階段 3：生成 TDD 所有章節 | 10-15 天 | 7-10 天 | 5-7 天 |
| 階段 4：生成 Ticket 與估時 | 3-5 天 | 2-3 天 | 1-2 天 |
| **總計** | **24-38 天** | **16-24 天** | **9.5-15 天** |

---

## 工具與資源

### 規範文件

所有規範文件位於 `TDD_rules/` 目錄下：
- `tdd_layers_and_responsibilities.md`：分層與職責規範
- `tdd_usecase_consolidation_rules.md`：UseCase 收斂規則
- `tdd_module_consolidation_rules.md`：模組收斂規則
- `tdd_sequence_and_mermaid_rules.md`：序列圖與 Mermaid 規範
- `tdd_domain_api_test_and_structure.md`：Domain Model、API、Test 規範
- `tdd_ticket_generation_and_estimation.md`：Ticket 生成與估時規範
- `tdd_input_processing_rules.md`：Input 資料處理規範
- `tdd_architecture_diagram_rules.md`：架構圖規範

### AI 輔助工具

- Cursor IDE（使用 `.cursorrules` 確保 AI 遵循所有規範）
- 使用 `TDD_rules/` 下的規範文件作為知識庫

---

## 注意事項

1. **單一來源原則**：Input 是原始規格來源，Output 是衍生文件，不應複製 Input 到 Output
2. **規範優先**：所有 TDD 生成必須嚴格遵循 `TDD_rules/` 目錄下的所有規範
3. **AI 輔助**：強烈建議使用 AI 輔助生成，可大幅縮短時間
4. **Code Review**：每個階段完成後應進行 Code Review，確保品質
5. **持續更新**：TDD 文件應隨著需求變更持續更新

---

## 相關文件

- [TDD Input 資料處理規範](./tdd_input_processing_rules.md)
- [TDD Ticket 生成與估時規範](./tdd_ticket_generation_and_estimation.md)
- [TDD Domain, API, Test & TDD Structure](./tdd_domain_api_test_and_structure.md)
- [TDD Sequence & Mermaid Rules](./tdd_sequence_and_mermaid_rules.md)

