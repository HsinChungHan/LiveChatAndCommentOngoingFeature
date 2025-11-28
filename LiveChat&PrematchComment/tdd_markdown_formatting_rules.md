# TDD Markdown 格式規範

本文檔定義所有 TDD 相關 Markdown 文件的格式規範，確保文件在 GitHub Pages、MkDocs 等平台上正確渲染。

---

## 核心原則

**所有 TDD 相關的 Markdown 文件都必須遵循本規範，確保格式一致性和正確渲染。**

---

## 1. 列表格式規範

### 1.1 編號列表與項目列表之間的斷行

**規則**：編號列表項目之間必須有空行，編號列表和嵌套的項目列表之間也必須有空行。

**正確格式**：

```markdown
**工作內容**：

1. 第一項內容

2. 第二項內容：
   - 子項目 1
   - 子項目 2

3. 第三項內容
```

**錯誤格式**：

```markdown
**工作內容**：
1. 第一項內容
2. 第二項內容：
   - 子項目 1
   - 子項目 2
3. 第三項內容
```

### 1.2 項目列表格式

**規則**：項目列表使用 `-` 符號，項目之間不需要空行（除非是不同段落）。

**正確格式**：

```markdown
**必備內容**：

- 項目 1
- 項目 2
- 項目 3
```

**錯誤格式**：

```markdown
**必備內容**：
- 項目 1
- 項目 2
- 項目 3
```

---

## 2. 標題與內容組織規範

### 2.1 主要主題使用標題層級

**規則**：主要主題應使用標題層級（`####`、`#####` 等），而不是編號列表中的粗體文字。

**正確格式**：

```markdown
### 為什麼選擇結構化格式？

#### AI 解析效率

- 結構化格式（YAML/JSON）易於 AI 解析和提取資訊
- 非結構化格式（Word/PDF）需要額外的 OCR 或解析步驟

#### 版本控制

- YAML/JSON 可以完整追蹤變更（Git diff）
- Word/PDF 難以追蹤具體變更內容
```

**錯誤格式**：

```markdown
### 為什麼選擇結構化格式？

1. **AI 解析效率**
   - 結構化格式（YAML/JSON）易於 AI 解析和提取資訊
   - 非結構化格式（Word/PDF）需要額外的 OCR 或解析步驟

2. **版本控制**
   - YAML/JSON 可以完整追蹤變更（Git diff）
   - Word/PDF 難以追蹤具體變更內容
```

### 2.2 標題後必須有空行

**規則**：所有標題（包括粗體標題如 `**工作內容**`、`**必備內容**` 等）後面必須有空行，然後才是內容。

**正確格式**：

```markdown
#### 1.2 工作內容

**負責人**：Client Side RD

**工作內容**：

1. 第一項工作

2. 第二項工作
```

**錯誤格式**：

```markdown
#### 1.2 工作內容

**負責人**：Client Side RD

**工作內容**：
1. 第一項工作
2. 第二項工作
```

---

## 3. 檢查清單格式規範

### 3.1 檢查清單語法

**規則**：檢查清單使用 `- [ ]` 格式（未勾選）或 `- [x]` 格式（已勾選）。

**正確格式**：

```markdown
### BE API Spec 檢查清單

- [ ] 所有 API Endpoints 已定義
- [ ] HTTP Method 正確（GET / POST / PUT / DELETE）
- [ ] Request Parameters 完整
- [x] Response Schema 完整（已完成）
```

**錯誤格式**：

```markdown
### BE API Spec 檢查清單

[] 所有 API Endpoints 已定義
[] HTTP Method 正確
```

### 3.2 檢查清單標題後的空行

**規則**：檢查清單標題後必須有空行。

**正確格式**：

```markdown
### BE API Spec 檢查清單

- [ ] 所有 API Endpoints 已定義
- [ ] HTTP Method 正確
```

**錯誤格式**：

```markdown
### BE API Spec 檢查清單
- [ ] 所有 API Endpoints 已定義
- [ ] HTTP Method 正確
```

---

## 4. 流程說明格式規範

### 4.1 階段標題使用標題層級

**規則**：流程中的階段標題應使用標題層級（`####`），階段下的步驟使用編號列表。

**正確格式**：

```markdown
### 流程說明

#### 階段 0：需求收集與文件準備

1. PM 提供 PRD
2. BE 提供 API Spec
3. Designer 提供 UI/UX Spec

#### 階段 1：需求分析與流程設計

1. Client Side RD 理解需求
2. 識別 Feature 邊界
3. 設計流程
```

**錯誤格式**：

```markdown
### 流程說明

1. **階段 0：需求收集與文件準備**
   - PM 提供 PRD
   - BE 提供 API Spec
   - Designer 提供 UI/UX Spec

2. **階段 1：需求分析與流程設計**
   - Client Side RD 理解需求
   - 識別 Feature 邊界
   - 設計流程
```

---

## 5. 工作內容格式規範

### 5.1 工作內容標題後的空行

**規則**：`**工作內容**`、`**工作流程**`、`**步驟**` 等標題後必須有空行。

**正確格式**：

```markdown
**工作內容**：

1. 第一項工作

2. 第二項工作：
   - 子項目 1
   - 子項目 2
```

**錯誤格式**：

```markdown
**工作內容**：
1. 第一項工作
2. 第二項工作：
   - 子項目 1
   - 子項目 2
```

### 5.2 工作步驟使用標題層級

**規則**：主要工作步驟應使用標題層級（`#####`），子步驟使用編號列表或項目列表。

**正確格式**：

```markdown
#### 1.2 工作內容

**負責人**：Client Side RD

##### 1. 閱讀並理解所有文件

1. 閱讀 PRD，理解業務需求和使用者故事
2. 閱讀 API Spec，理解後端提供的 API 端點和資料結構
3. 閱讀 UI/UX Spec，理解使用者互動流程和 UI 狀態

##### 2. 識別 Feature 邊界

1. 一個 Feature 對應一個業務功能模組
2. 範例：PrematchComment、LiveChat
```

**錯誤格式**：

```markdown
#### 1.2 工作內容

**負責人**：Client Side RD

**步驟**：

1. **閱讀並理解所有文件**
   - 閱讀 PRD，理解業務需求和使用者故事
   - 閱讀 API Spec，理解後端提供的 API 端點和資料結構

2. **識別 Feature 邊界**
   - 一個 Feature 對應一個業務功能模組
   - 範例：PrematchComment、LiveChat
```

---

## 6. MkDocs 配置要求

### 6.1 任務列表擴展

**規則**：MkDocs 配置中必須啟用 `pymdownx.tasklist` 擴展以正確渲染檢查清單。

**正確配置**：

```yaml
markdown_extensions:
  - pymdownx.tasklist:
      custom_checkbox: true
```

---

## 7. 常見格式錯誤檢查清單

在生成或修改 Markdown 文件時，請檢查以下項目：

- [ ] 所有標題（包括粗體標題）後面都有空行
- [ ] 編號列表項目之間有空行
- [ ] 編號列表和嵌套的項目列表之間有空行
- [ ] 主要主題使用標題層級，而不是編號列表中的粗體文字
- [ ] 檢查清單使用 `- [ ]` 格式
- [ ] 檢查清單標題後有空行
- [ ] 流程階段使用標題層級（`####`）
- [ ] 工作步驟使用標題層級（`#####`）

---

## 8. 範例對照

### 8.1 完整範例：工作內容格式

**正確格式**：

```markdown
#### 1.2 工作內容

**負責人**：Client Side RD（可與 PM、BE、Designer 協作）

##### 1. 閱讀並理解所有文件

1. 閱讀 PRD，理解業務需求和使用者故事
2. 閱讀 API Spec，理解後端提供的 API 端點和資料結構
3. 閱讀 UI/UX Spec，理解使用者互動流程和 UI 狀態

##### 2. 識別 Feature 邊界

1. 一個 Feature 對應一個業務功能模組
2. 範例：PrematchComment、LiveChat

**產出**：

- Feature 列表
- Flow 列表（flow_id、flow_type、flow_name）
- `mermaid.md`：Mermaid Sequence Diagram 代碼
```

### 8.2 完整範例：檢查清單格式

**正確格式**：

```markdown
### BE API Spec 檢查清單

- [ ] 所有 API Endpoints 已定義
- [ ] HTTP Method 正確（GET / POST / PUT / DELETE）
- [ ] Request Parameters 完整（路徑參數、查詢參數、請求體）
- [ ] Request Body Schema 完整（JSON Schema）
- [ ] Response Schema 完整（JSON Schema）
- [ ] HTTP Status Codes 完整（200, 201, 400, 401, 500 等）
- [ ] 錯誤回應格式統一
- [ ] 認證方式說明清楚
- [ ] WebSocket 規格完整（如適用）
- [ ] Rate Limiting 說明（如適用）
```

---

## 9. 工具與驗證

### 9.1 Markdown 驗證工具

建議使用以下工具驗證 Markdown 格式：

- **MkDocs 本地預覽**：`mkdocs serve` 檢查渲染效果
- **GitHub 預覽**：在 GitHub 上查看文件預覽
- **Markdown Linter**：使用 `markdownlint` 檢查格式問題

### 9.2 自動化檢查

在 CI/CD 流程中可以加入 Markdown 格式檢查：

```yaml
- name: Check Markdown format
  run: |
    # 檢查標題後是否有空行
    # 檢查列表格式
    # 檢查檢查清單格式
```

---

## 10. 更新記錄

- **2024-11-21**：初始版本，統整所有 Markdown 格式規範

---

**最後更新**：2024-11-21  
**版本**：1.0.0

