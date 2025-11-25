# TDD Ticket 生成與估時規範

本文件定義如何從 TDD 文件自動生成開發 Ticket，並根據模組類型和複雜度進行開發時間估算。

---

## 1. Ticket 生成原則

### 1.1 Ticket 分類

根據 Clean Architecture 的分層，Ticket 應按以下順序生成：

1. **Domain Model Layer**（優先）
   - Entity 定義
   - Value Object 定義
   - Domain Model 關係定義

2. **Data & Infrastructure Layer**（次優先）
   - API 定義
   - Client 實作
   - Repository 實作

3. **Domain Layer**（UseCase → Feature）
   - UseCase 實作
   - Feature（TCA Reducer）實作

4. **UI Layer**（最後）
   - View 實作
   - UI 整合測試

### 1.2 Ticket 粒度

每個 Ticket 應對應一個**可獨立開發、測試、驗收**的模組或功能單元：

- ✅ **正確粒度**：
  - 一個 UseCase 的完整實作
  - 一個 Repository 的完整實作
  - 一個 Client 的完整實作
  - 一個 Feature 的完整實作

- ❌ **錯誤粒度**：
  - 一個 UseCase 拆成多個 Ticket（除非真的非常複雜）
  - 多個 UseCase 合併成一個 Ticket（除非它們高度相關且簡單）

### 1.3 Ticket 依賴關係

Ticket 必須標註依賴關係：

- **強依賴**：必須先完成才能開始
- **弱依賴**：可以並行開發，但需要先定義介面

**依賴順序範例**：
```
Domain Model → API → Client → Repository → UseCase → Feature → View
```

---

## 2. Ticket 內容結構

### 2.1 Ticket 基本資訊

每個 Ticket 必須包含：

| 欄位 | 說明 | 範例 |
|------|------|------|
| **Ticket ID** | 唯一識別碼 | `TDD-001` |
| **標題** | 簡潔描述 | `實作 ReloadCommentListUseCase` |
| **類型** | Ticket 類型 | `UseCase` / `Repository` / `Client` / `API` / `Feature` / `View` |
| **優先級** | 開發優先級 | `P0` (最高) / `P1` / `P2` / `P3` |
| **所屬 Feature** | 所屬功能 | `PrematchComment` |
| **依賴 Ticket** | 依賴的 Ticket ID | `TDD-001, TDD-002` |

### 2.1.1 Ticket 中英版本要求

**所有 Ticket 文件必須提供中英雙語版本**，格式如下：

- **標題**：使用 `中文標題 / English Title` 格式
- **表格欄位**：使用 `中文欄位名 / English Field Name` 格式
- **表格值**：如果值包含中文，使用 `中文值 / English Value` 格式
- **段落文字**：使用 `中文段落 / English Paragraph` 格式
- **列表項**：使用 `中文項目 / English Item` 格式

**範例**：

```markdown
## Ticket 資訊 / Ticket Information

| 欄位 / Field | 值 / Value |
|------|-----|
| **標題** / **Title** | 實作 Comment Entity / Implement Comment Entity |
| **類型** / **Type** | Domain Model |
| **估時（Senior iOS Engineer + AI 輔助）** / **Estimation (Senior iOS Engineer + AI Assisted)** | 標準：0.3 天<br/>最嚴厲：0.2 天 / Standard: 0.3 days<br/>Most Stringent: 0.2 days |

## 描述 / Description

定義 Comment Entity Domain Model。 / Define Comment Entity Domain Model。

## 需求 / Requirements

1. 定義 Comment 結構 / Define Comment Structure
2. 實作 Identifiable 和 Equatable / Implement Identifiable and Equatable
```

**注意事項**：
- 技術術語（如 Entity、UseCase、Repository）保持英文不變
- 專有名詞（如 PrematchComment、LiveChat）保持英文不變
- 數字、代碼、路徑等保持原樣

### 2.2 Ticket 詳細內容

#### Domain Model Ticket

```markdown
## 描述
定義 {Entity/ValueObject 名稱} Domain Model。

## 需求
1. 定義 {Entity/ValueObject 名稱} 結構
2. 實作 DTO → Domain Model Mapping
3. 定義相關 Value Object（如有）

## 驗收條件
- [ ] Entity/ValueObject 定義完成
- [ ] DTO Mapping 邏輯實作完成
- [ ] Unit Test 覆蓋率 ≥ 80%

## 相關文件
- Domain Model 定義：`output/{Feature}/04_Domain Model/01_domain_model.md`
```

#### API Ticket

```markdown
## 描述
實作 {API 名稱} API 定義。

## 需求
1. 定義所有 Endpoints（URL、Method、Request/Response DTO）
2. 定義 Error Response 格式
3. 定義 API 文件註解

## 驗收條件
- [ ] 所有 Endpoints 定義完成
- [ ] Request/Response DTO 定義完成
- [ ] API 文件註解完整

## 相關文件
- API Spec：`output/{Feature}/08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`output/{Feature}/03_Module Responsibility/01_module_responsibility.md`
```

#### Client Ticket

```markdown
## 描述
實作 {Client 名稱} Client（{技術類型}）。

## 需求
1. 實作 HTTP/WebSocket 通訊邏輯
2. 實作 Request/Response 編解碼
3. 實作 Error Handling
4. 實作 Retry/Reconnect 邏輯（如需要）

## 驗收條件
- [ ] 所有 API 呼叫實作完成
- [ ] Error Handling 實作完成
- [ ] Unit Test 覆蓋率 ≥ 80%
- [ ] Integration Test 通過

## 相關文件
- API Spec：`output/{Feature}/08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`output/{Feature}/03_Module Responsibility/01_module_responsibility.md`
```

#### Repository Ticket

```markdown
## 描述
實作 {Repository 名稱} Repository。

## 需求
1. 實作 Repository 介面
2. 實作 DTO → Domain Model 轉換
3. 整合 Client 呼叫
4. 實作 Caching 邏輯（如需要）

## 驗收條件
- [ ] Repository 介面實作完成
- [ ] DTO → Domain Model Mapping 實作完成
- [ ] 所有方法 Unit Test 覆蓋率 ≥ 80%
- [ ] Integration Test 通過

## 相關文件
- Module Responsibility：`output/{Feature}/03_Module Responsibility/01_module_responsibility.md`
- Domain Model：`output/{Feature}/04_Domain Model/01_domain_model.md`
```

#### UseCase Ticket

```markdown
## 描述
實作 {UseCase 名稱} UseCase。

## 需求
1. 實作 UseCase 商業邏輯
2. 整合 Repository 呼叫
3. 實作 Input/Output Model 驗證
4. 實作 Error Handling
5. 整合 Shared Feature（如需要）

## 驗收條件
- [ ] UseCase 商業邏輯實作完成
- [ ] 所有 Test Scenarios 通過（Basic / Branch / Error / Edge Case）
- [ ] Unit Test 覆蓋率 ≥ 90%
- [ ] Integration Test 通過

## 相關文件
- UseCase 定義：`output/{Feature}/03_Module Responsibility/01_module_responsibility.md`
- Input/Output Model：`output/{Feature}/08_UseCase Input & Output Model/01_usecase_input_output.md`
- Test Scenarios：`output/{Feature}/10_Test Scenarios/01_test_scenarios.md`
```

#### Feature Ticket

```markdown
## 描述
實作 {Feature 名稱} Feature（TCA Reducer）。

## 需求
1. 定義 State 結構
2. 定義 Action 列舉
3. 實作 Reducer 邏輯
4. 整合 UseCase 呼叫
5. 實作 State 更新邏輯

## 驗收條件
- [ ] State 和 Action 定義完成
- [ ] Reducer 邏輯實作完成
- [ ] 所有 Action → UseCase 映射完成
- [ ] Unit Test 覆蓋率 ≥ 80%

## 相關文件
- Feature State & Action：`output/{Feature}/07_Feature State & Action (TCA)/01_feature_state_action.md`
- Module Responsibility：`output/{Feature}/03_Module Responsibility/01_module_responsibility.md`
```

#### View Ticket

```markdown
## 描述
實作 {View 名稱} View。

## 需求
1. 實作 UI 元件
2. 整合 Feature（TCA）
3. 實作 UI 狀態綁定
4. 實作使用者互動處理
5. 實作 Loading/Error 狀態顯示

## 驗收條件
- [ ] UI 元件實作完成
- [ ] Feature 整合完成
- [ ] 所有使用者互動流程測試通過
- [ ] UI Test 覆蓋率 ≥ 70%

## 相關文件
- Module Sequence Diagram：`output/{Feature}/05. Module Sequence Diagram（模組序列圖）/{Feature}/Module Sequence Diagrams/`
```

---

## 3. 開發時間估算規則

### 3.1 基礎估時單位

- **Story Point**：使用 Fibonacci 數列（1, 2, 3, 5, 8, 13, 21）
- **實際工時**：根據工程師經驗等級轉換

### 3.2 工程師等級定義

| 等級 | 描述 | Story Point → 工時轉換 |
|------|------|----------------------|
| **Junior** | 0-2 年經驗 | 1 SP = 1.5 天 |
| **Mid-level** | 2-5 年經驗 | 1 SP = 1 天 |
| **Senior** | 5+ 年經驗 | 1 SP = 0.5 天 |

### 3.3 模組類型基礎估時

#### Domain Model

| 複雜度 | 描述 | Story Point |
|--------|------|------------|
| **簡單** | 單一 Entity，無複雜關係 | 1 |
| **中等** | 多個 Entity，有 Value Object，有簡單關係 | 2-3 |
| **複雜** | 多個 Entity，複雜關係，需要複雜 Mapping | 5-8 |

**調整因子**：
- +1 SP：需要複雜的 DTO Mapping 邏輯
- +1 SP：需要處理多個 API 來源的資料合併

#### API

| 複雜度 | 描述 | Story Point |
|--------|------|------------|
| **簡單** | 單一 Endpoint，簡單 Request/Response | 1 |
| **中等** | 多個 Endpoint，複雜 Request/Response | 2-3 |
| **複雜** | 多個 Endpoint，複雜驗證邏輯，WebSocket | 5-8 |

**調整因子**：
- +2 SP：WebSocket API
- +1 SP：複雜的 Request/Response 驗證

#### Client

| 複雜度 | 描述 | Story Point |
|--------|------|------------|
| **簡單** | HTTP Client，單一 API，簡單 Error Handling | 2 |
| **中等** | HTTP Client，多個 API，標準 Error Handling | 3-5 |
| **複雜** | WebSocket Client，複雜 Reconnect 邏輯，Retry 機制 | 8-13 |

**調整因子**：
- +3 SP：WebSocket Client
- +2 SP：複雜的 Retry/Reconnect 邏輯
- +1 SP：需要處理多種 Error 類型

#### Repository

| 複雜度 | 描述 | Story Point |
|--------|------|------------|
| **簡單** | 單一 Client，簡單 DTO Mapping | 2 |
| **中等** | 多個 Client，複雜 DTO Mapping，簡單 Caching | 3-5 |
| **複雜** | 多個 Client，複雜資料合併，複雜 Caching 策略 | 8-13 |

**調整因子**：
- +2 SP：需要整合多個 Client
- +2 SP：複雜的 Caching 策略
- +1 SP：需要處理資料同步問題

#### UseCase

| 複雜度 | 描述 | Story Point |
|--------|------|------------|
| **簡單** | 單一 Repository，簡單商業邏輯 | 3 |
| **中等** | 多個 Repository，標準商業邏輯，簡單驗證 | 5-8 |
| **複雜** | 多個 Repository，複雜商業邏輯，複雜驗證，整合 Shared Feature | 13-21 |

**調整因子**：
- +3 SP：需要整合多個 Shared Feature
- +2 SP：複雜的商業邏輯（如分頁、排序、過濾）
- +2 SP：複雜的驗證邏輯
- +1 SP：需要處理多種 Error 情況

#### Feature

| 複雜度 | 描述 | Story Point |
|--------|------|------------|
| **簡單** | 單一 UseCase，簡單 State，簡單 Action | 2 |
| **中等** | 多個 UseCase，標準 State，標準 Action | 3-5 |
| **複雜** | 多個 UseCase，複雜 State，複雜 Action，複雜狀態管理 | 8-13 |

**調整因子**：
- +2 SP：需要處理複雜的狀態同步
- +1 SP：需要處理多種 UI 狀態（Loading、Error、Success）

#### View

| 複雜度 | 描述 | Story Point |
|--------|------|------------|
| **簡單** | 簡單 UI，單一 Feature，基本互動 | 3 |
| **中等** | 標準 UI，單一 Feature，標準互動 | 5-8 |
| **複雜** | 複雜 UI，多個 Feature，複雜互動，複雜狀態顯示 | 13-21 |

**調整因子**：
- +3 SP：複雜的 UI 動畫或過渡效果
- +2 SP：需要整合多個 Feature
- +2 SP：複雜的列表或分頁 UI
- +1 SP：需要處理多種 Loading/Error 狀態

### 3.4 複雜度判斷標準

#### 簡單（Simple）
- 單一職責
- 無複雜邏輯
- 無複雜依賴
- 標準實作模式

#### 中等（Medium）
- 多個職責但清晰
- 有標準商業邏輯
- 有標準依賴
- 需要一些設計考量

#### 複雜（Complex）
- 多個職責且交錯
- 複雜商業邏輯
- 複雜依賴關係
- 需要特殊設計模式

### 3.5 估時調整因子

#### 技術調整因子

| 技術 | 調整 |
|------|------|
| **WebSocket** | +3 SP |
| **複雜 Caching** | +2 SP |
| **複雜 Error Handling** | +1 SP |
| **複雜 Retry/Reconnect** | +2 SP |

#### 業務調整因子

| 業務複雜度 | 調整 |
|-----------|------|
| **需要整合多個 Shared Feature** | +2 SP |
| **複雜的資料合併邏輯** | +2 SP |
| **複雜的驗證邏輯** | +1 SP |
| **需要處理多種 Edge Case** | +1 SP |

#### 測試調整因子

| 測試要求 | 調整 |
|---------|------|
| **Unit Test 覆蓋率 ≥ 90%** | +1 SP |
| **需要 Integration Test** | +1 SP |
| **需要 UI Test** | +2 SP |

---

## 4. Ticket 生成流程

### 4.1 輸入來源

Ticket 生成應從以下 TDD 文件提取資訊：

1. **Module Responsibility** (`03_Module Responsibility/01_module_responsibility.md`)
   - 提取所有模組（Feature、UseCase、Repository、Client、API）
   - 提取模組職責和依賴關係

2. **Domain Model** (`04_Domain Model/01_domain_model.md`)
   - 提取所有 Entity 和 Value Object
   - 提取 DTO → Domain Model Mapping 規則

3. **Module Sequence Diagram** (`05. Module Sequence Diagram（模組序列圖）/`)
   - 提取 UseCase 執行流程
   - 提取模組互動關係

4. **Feature State & Action** (`07_Feature State & Action (TCA)/01_feature_state_action.md`)
   - 提取 Feature 的 State 和 Action 定義

5. **UseCase Input & Output Model** (`08_UseCase Input & Output Model/01_usecase_input_output.md`)
   - 提取 UseCase 的 Input/Output Model

### 4.2 生成順序

1. **解析 TDD 文件** → 提取所有模組
2. **建立依賴圖** → 確定開發順序
3. **評估複雜度** → 根據規則評估每個模組
4. **生成 Ticket** → 根據模板生成 Ticket 內容
5. **計算估時** → 根據複雜度和調整因子計算 Story Point

### 4.3 輸出格式

Ticket 應輸出為：

- **Markdown 格式**：`output/{Feature}/12_Tickets/{ticket_id}_{module_name}.md`
  - **必須提供中英雙語版本**：所有標題、表格、段落、列表都應包含中英文對照
  - 格式：`中文內容 / English Content`
- **JSON 格式**（可選）：`output/{Feature}/12_Tickets/tickets.json`

### 4.3.1 中英版本生成規則

1. **自動生成**：使用 `scripts/create_bilingual_tickets.py` 腳本自動為所有 Ticket 文件生成中英版本
2. **翻譯原則**：
   - 技術術語保持英文（Entity、UseCase、Repository 等）
   - 專有名詞保持英文（PrematchComment、LiveChat 等）
   - 動詞和描述性文字需要翻譯（實作 → Implement、定義 → Define）
3. **格式要求**：
   - 使用 `/` 分隔中英文
   - 保持原有 Markdown 格式
   - 表格欄位和值都需要中英對照

---

## 5. 估時範例

### 5.1 簡單 UseCase 範例

**ReloadCommentListUseCase**

- **基礎估時**：中等 UseCase = 5 SP
- **調整因子**：
  - 單一 Repository：無調整
  - 需要處理 triggerType 和 mode：+1 SP
  - 標準 Error Handling：無調整
- **總估時**：6 SP
- **Mid-level 工程師**：6 天

### 5.2 複雜 UseCase 範例

**SendChatMessageUseCase**

- **基礎估時**：複雜 UseCase = 13 SP
- **調整因子**：
  - 需要整合 AuthFeature：+2 SP
  - 需要整合 NicknameFeature：+2 SP
  - 需要處理多種 Error 情況：+1 SP
- **總估時**：18 SP
- **Mid-level 工程師**：18 天

### 5.3 WebSocket Client 範例

**ChatWebSocketClient**

- **基礎估時**：複雜 Client = 8 SP
- **調整因子**：
  - WebSocket：+3 SP
  - 複雜 Reconnect 邏輯：+2 SP
  - 需要處理多種 Message 類型：+1 SP
- **總估時**：14 SP
- **Mid-level 工程師**：14 天

---

## 6. 注意事項

1. **估時僅供參考**：實際開發時間可能因工程師經驗、專案複雜度、技術債務等因素而有所不同
2. **需要定期調整**：根據實際開發情況，應定期調整估時規則
3. **考慮並行開發**：某些 Ticket 可以並行開發，應在 Ticket 中標註
4. **考慮風險緩衝**：建議在總估時基礎上增加 20-30% 的緩衝時間

---

## 7. Ticket 輸出結構

```
output/
└── {Feature}/
    └── 12_Tickets/
        ├── README.md                    # Ticket 總覽和索引
        ├── tickets.json                  # Ticket JSON 格式（可選）
        ├── 01_domain_model/
        │   ├── TDD-001_Comment_Entity.md
        │   ├── TDD-002_CommentMeta_Entity.md
        │   └── ...
        ├── 02_api/
        │   ├── TDD-010_PrematchCommentAPI.md
        │   └── ...
        ├── 03_client/
        │   ├── TDD-020_PrematchCommentClient.md
        │   └── ...
        ├── 04_repository/
        │   ├── TDD-030_PrematchCommentRepository.md
        │   └── ...
        ├── 05_usecase/
        │   ├── TDD-040_ReloadCommentListUseCase.md
        │   ├── TDD-041_LoadCommentRepliesUseCase.md
        │   └── ...
        ├── 06_feature/
        │   ├── TDD-050_PrematchCommentFeature.md
        │   └── ...
        └── 07_view/
            ├── TDD-060_PrematchCommentView.md
            └── ...
```

