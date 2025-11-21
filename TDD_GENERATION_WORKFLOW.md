# TDD 自動化生成完整工作流程

本文檔定義從產品需求到最終 TDD 文件的完整流程，以及各角色（PM、BE、Designer）需要提供的文件格式和內容。

---

## 📋 目錄

1. [完整流程總覽](#完整流程總覽)
2. [各角色需提供的文件](#各角色需提供的文件)
3. [Client Side RD 工作流程](#client-side-rd-工作流程)
4. [AI 自動化生成流程](#ai-自動化生成流程)
5. [文件範本與檢查清單](#文件範本與檢查清單)
6. [常見問題與解決方案](#常見問題與解決方案)

---

## 完整流程總覽

```
┌─────────────────────────────────────────────────────────────┐
│ 階段 0：需求收集與文件準備                                   │
│ PM PRD + BE API Spec + Designer UI/UX Spec                  │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ 階段 1：需求分析與流程設計                                   │
│ Client Side RD：理解需求、識別 Feature、設計流程            │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ 階段 2：產生 Input 資料                                      │
│ Client Side RD：Mermaid + Description + YAML                │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ 階段 3：AI 自動化生成 TDD                                    │
│ 基於 TDD_rules/ 規範，自動生成所有 TDD 章節                 │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ 階段 4：生成 Ticket 與估時                                   │
│ 根據 TDD 自動生成開發 Ticket 和估時                         │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ 階段 5：開發實作                                             │
│ 按照 Ticket 順序進行開發                                     │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ 階段 6：同步 Codebase 實作到 TDD                            │
│ 根據實際實作更新 TDD 文件，確保文件與代碼一致                │
└─────────────────────────────────────────────────────────────┘
```

---

## 各角色需提供的文件

### 1. PM（Product Manager）需提供的文件

#### 1.1 PRD（Product Requirements Document）

**推薦文件格式**：
- ✅ **YAML**（推薦）：結構化、易於 AI 解析、版本控制友好
- ✅ **Markdown**：易於閱讀和編輯
- ⚠️ **Word / PDF**：不推薦，難以自動化處理

**為什麼推薦 YAML**：
- ✅ 結構化格式，易於 AI 解析和提取資訊
- ✅ 版本控制友好（Git diff 清晰）
- ✅ 可以自動驗證格式和完整性
- ✅ 易於轉換為其他格式

**必備內容**：

| 章節 | 內容要求 | 範例 |
|------|---------|------|
| **功能概述** | Feature 的目的、目標用戶、使用情境 | "提供賽事前評論功能，讓用戶可以在賽事開始前發表評論和互動" |
| **使用者故事** | User Story 格式，包含角色、行為、目標 | "作為用戶，我想要在賽事開始前發表評論，以便與其他用戶互動" |
| **功能規格** | 詳細的功能描述、操作流程、業務規則 | "用戶可以發表評論、點讚、回覆、查看回覆列表" |
| **使用者流程** | 使用者操作的完整流程（可用流程圖或文字描述） | "進入頁面 → 查看評論列表 → 點擊輸入框 → 輸入評論 → 送出" |
| **業務規則** | 業務邏輯、限制條件、特殊情況 | "未登入用戶需先登入才能發表評論"、"nickname 為必填" |
| **驗收條件** | 功能完成的驗收標準 | "用戶可以成功發表評論並看到自己的評論出現在列表中" |
| **優先級** | 功能的優先級（P0/P1/P2/P3） | P0：核心功能，P1：重要功能，P2：次要功能，P3：可選功能 |

**範例結構**：

```markdown
# PrematchComment Feature PRD

## 1. 功能概述
- **目的**：提供賽事前評論功能
- **目標用戶**：所有註冊用戶
- **使用情境**：用戶在賽事開始前可以發表評論、點讚、回覆

## 2. 使用者故事
- 作為用戶，我想要在賽事開始前發表評論
- 作為用戶，我想要點讚其他用戶的評論
- 作為用戶，我想要回覆其他用戶的評論

## 3. 功能規格
### 3.1 評論列表
- 顯示熱門評論（Top tab）
- 顯示最新評論（Newest tab）
- 支援下拉刷新

### 3.2 發表評論
- 點擊輸入框觸發登入檢查
- 檢查 nickname 是否存在
- 支援發表評論和回覆

## 4. 使用者流程
1. 進入 Race Detail Page
2. 點擊進入 Prematch Comment Page
3. 查看評論列表（預設 Top tab）
4. 切換到 Newest tab
5. 點擊輸入框發表評論
6. 輸入評論內容並送出

## 5. 業務規則
- 未登入用戶需先登入才能發表評論
- 發表評論前需檢查 nickname 是否存在
- 如果沒有 nickname，需先建立 nickname
- 評論列表支援分頁載入（每次最多 5 筆）

## 6. 驗收條件
- [ ] 用戶可以成功發表評論
- [ ] 用戶可以點讚評論
- [ ] 用戶可以回覆評論
- [ ] 評論列表可以正常顯示和刷新
```

#### 1.2 使用者流程圖（可選但建議）

**格式**：Mermaid Flowchart / Figma / Draw.io

**內容**：
- 使用者操作的完整流程
- 決策點和分支
- 錯誤處理流程

---

### 2. BE（Backend Engineer）需提供的文件

#### 2.1 API Spec（API 規格文件）

**推薦文件格式**：
- ✅ **OpenAPI 3.0 (YAML)**（強烈推薦）：標準格式、結構化、易於 AI 解析
- ✅ **OpenAPI 3.0 (JSON)**：與 YAML 等價，但 YAML 更易讀
- ⚠️ **Swagger 2.0**：舊版格式，建議升級到 OpenAPI 3.0
- ⚠️ **Markdown**：不推薦，難以自動化處理

**為什麼推薦 OpenAPI 3.0 YAML**：
- ✅ 業界標準格式，工具支援完善
- ✅ 結構化格式，易於 AI 解析和驗證
- ✅ 可以自動生成 API Client 代碼
- ✅ 版本控制友好

**必備內容**：

| 項目 | 內容要求 | 範例 |
|------|---------|------|
| **Base URL** | API 基礎路徑 | `https://api.example.com/v1` |
| **Endpoints** | 所有 API 端點 | `GET /chat/match/comment/popular` |
| **HTTP Method** | 請求方法 | GET / POST / PUT / DELETE |
| **Request Parameters** | 路徑參數、查詢參數、請求體 | `refId: String`, `cursor: String?` |
| **Request Body Schema** | 請求體結構（JSON Schema） | `{ content: String, parentId: String? }` |
| **Response Schema** | 回應結構（JSON Schema） | `{ comments: [CommentDTO], nextCursor: String? }` |
| **HTTP Status Codes** | 所有可能的狀態碼和對應情況 | `200 OK`, `201 Created`, `400 Bad Request`, `401 Unauthorized`, `500 Internal Server Error` |
| **錯誤回應格式** | 錯誤回應的統一格式 | `{ error: { code: String, message: String } }` |
| **認證方式** | API 認證方式 | Bearer Token / API Key |
| **Rate Limiting** | 速率限制 | 100 requests/minute |
| **WebSocket** | WebSocket 端點和訊息格式（如適用） | `wss://api.example.com/chat/websocket` |

**範例結構（OpenAPI 3.0）**：

```yaml
openapi: 3.0.0
info:
  title: PrematchComment API
  version: 1.0.0

paths:
  /chat/match/comment/popular:
    get:
      summary: 取得熱門評論列表
      parameters:
        - name: refId
          in: path
          required: true
          schema:
            type: string
        - name: cursor
          in: query
          required: false
          schema:
            type: string
      responses:
        '200':
          description: 成功
          content:
            application/json:
              schema:
                type: object
                properties:
                  comments:
                    type: array
                    items:
                      $ref: '#/components/schemas/CommentDTO'
                  nextCursor:
                    type: string
                    nullable: true
        '400':
          description: 請求參數錯誤
        '401':
          description: 未授權
        '500':
          description: 伺服器錯誤

components:
  schemas:
    CommentDTO:
      type: object
      properties:
        id:
          type: string
        content:
          type: string
        authorId:
          type: string
        authorName:
          type: string
        likeCount:
          type: integer
        replyCount:
          type: integer
        createdAt:
          type: string
          format: date-time
```

#### 2.2 WebSocket Spec（如適用）

**必備內容**：
- WebSocket 端點 URL
- 連線方式（認證、參數）
- 訊息格式（訂閱、取消訂閱、接收訊息）
- 事件類型定義
- 錯誤處理

**範例**：

```markdown
# Chat WebSocket API

## 端點
wss://api.example.com/chat/websocket/web-chat

## 連線方式
1. 建立 WebSocket 連線
2. 發送認證訊息（如需要）
3. 訂閱特定頻道

## 訊息格式

### 訂閱訊息
```json
{
  "type": "subscribe",
  "channel": "chatroom:{chatroomId}"
}
```

### 接收訊息
```json
{
  "type": "message",
  "data": {
    "messageId": "msg_123",
    "content": "Hello",
    "authorId": "user_456",
    "timestamp": "2024-01-01T00:00:00Z"
  }
}
```
```

#### 2.3 資料模型說明（可選但建議）

**內容**：
- DTO（Data Transfer Object）的完整定義
- 欄位說明和資料類型
- 必填/選填欄位
- 預設值
- 資料驗證規則

---

### 3. Designer（UI/UX Designer）需提供的文件

#### 3.1 UI/UX Design Spec

**推薦文件格式**：
- ✅ **YAML + Figma**（推薦）：YAML 提供結構化規格，Figma 提供視覺設計稿
- ✅ **JSON + Figma**：與 YAML 等價
- ✅ **Markdown + Figma**：Markdown 提供文字描述，Figma 提供視覺設計稿
- ⚠️ **僅 Figma / Sketch**：不推薦，難以自動化提取結構化資訊

**為什麼推薦 YAML + Figma**：
- ✅ YAML 提供結構化的 UI 規格（狀態、互動、元件），易於 AI 解析
- ✅ Figma 提供視覺設計稿，便於設計師和開發者查看
- ✅ 兩者結合：結構化規格 + 視覺參考
- ✅ 版本控制友好（YAML 可以 Git 追蹤）

**必備內容**：

| 項目 | 內容要求 | 範例 |
|------|---------|------|
| **畫面設計稿** | 所有相關畫面的設計稿 | PrematchComment Page、Comment Input、Reply List |
| **互動流程** | 使用者操作的互動流程 | 點擊輸入框 → 顯示鍵盤 → 輸入評論 → 送出 |
| **狀態定義** | UI 的各種狀態 | Loading、Empty、Error、Success |
| **元件規格** | UI 元件的規格說明 | Button、Input、List、Card |
| **動畫與過渡** | 動畫效果和過渡動畫 | 評論送出後的 highlight 動畫（3 秒） |
| **響應式設計** | 不同螢幕尺寸的適配 | iPhone、iPad、不同解析度 |
| **錯誤狀態設計** | 錯誤訊息的顯示方式 | Toast、Alert、Inline Error |

**範例結構**：

```markdown
# PrematchComment UI/UX Design Spec

## 1. 畫面設計稿
- [Figma 連結]：https://figma.com/...

## 2. 互動流程
### 2.1 發表評論流程
1. 用戶點擊輸入框
2. 鍵盤彈出
3. 用戶輸入評論內容
4. 點擊送出按鈕
5. 顯示 Loading 狀態
6. 評論出現在列表最上方
7. 評論 highlight 3 秒後恢復正常

### 2.2 點讚流程
1. 用戶點擊 Like 按鈕
2. 立即更新 UI（Optimistic UI）
3. Like 數 +1，按鈕變為已點讚狀態
4. 向後端發送請求
5. 如果失敗，回滾 UI 狀態

## 3. 狀態定義
### 3.1 評論列表狀態
- **Loading**：顯示 Loading indicator
- **Empty**：顯示「尚無評論」提示
- **Error**：顯示錯誤訊息和重試按鈕
- **Success**：顯示評論列表

### 3.2 輸入框狀態
- **Normal**：正常輸入狀態
- **Focused**：聚焦狀態（鍵盤彈出）
- **Sending**：發送中狀態（顯示 Loading）
- **Error**：發送失敗狀態（顯示錯誤訊息）

## 4. 元件規格
### 4.1 Comment Card
- 寬度：100%
- 內距：16px
- 圓角：8px
- 陰影：輕微陰影

### 4.2 Like Button
- 尺寸：24x24px
- 未點讚：灰色圖標
- 已點讚：紅色圖標
- 動畫：點擊時有縮放動畫

## 5. 動畫與過渡
- 評論送出後 highlight 動畫：3 秒
- Like 按鈕點擊動畫：0.2 秒縮放
- 列表載入動畫：淡入效果

## 6. 錯誤狀態設計
- **網路錯誤**：Toast 提示「網路連線失敗，請稍後再試」
- **驗證錯誤**：Inline Error 顯示在輸入框下方
- **伺服器錯誤**：Alert 彈窗顯示錯誤訊息
```

#### 3.2 設計系統參考（可選但建議）

**內容**：
- 顏色規範（Primary、Secondary、Error、Success）
- 字體規範（字體大小、字重、行高）
- 間距規範（Spacing、Padding、Margin）
- 元件庫（Button、Input、Card 等）

---

## Client Side RD 工作流程

### 階段 1：需求分析與流程設計

#### 1.1 輸入資料

| 資料來源 | 格式 | 說明 |
|---------|------|------|
| **PM PRD** | Markdown / Word / Confluence | 產品需求文件 |
| **BE API Spec** | OpenAPI / Swagger / Markdown | 後端 API 規格 |
| **Designer UI/UX Spec** | Figma / Sketch / Markdown | UI/UX 設計規格 |

#### 1.2 工作內容

**負責人**：Client Side RD（可與 PM、BE、Designer 協作）

**步驟**：

1. **閱讀並理解所有文件**
   - 閱讀 PRD，理解業務需求和使用者故事
   - 閱讀 API Spec，理解後端提供的 API 端點和資料結構
   - 閱讀 UI/UX Spec，理解使用者互動流程和 UI 狀態

2. **識別 Feature 邊界**
   - 一個 Feature 對應一個業務功能模組
   - 範例：PrematchComment、LiveChat

3. **識別 Flow 類型**
   - **主流程（Full Flow）**：完整的業務流程，從使用者觸發到完成
   - **子流程（Sub Flow）**：主流程中的特定階段或分支流程

4. **設計 Mermaid Sequence Diagram**
   - 根據 PRD、API Spec、UI/UX Spec 設計流程
   - 識別參與者（Participants）
   - 設計互動流程
   - 標註 Flow 類型（`@feature`、`@flow`）

**產出**：
- Feature 列表
- Flow 列表（flow_id、flow_type、flow_name）
- `mermaid.md`：Mermaid Sequence Diagram 代碼

**估時**：
- Junior：5-8 天
- Mid-level：3-5 天
- Senior：1.5-3 天

---

### 階段 2：產生 Input 資料

**工作流程**：

```
Client Side RD 自然語言敘述
    ↓
[AI 工具] 生成 Mermaid Sequence Diagram
    ↓
[AI 工具] 生成 YAML Flow Spec
    ↓
產出：mermaid.md、description.md、flow_spec.yaml
```

#### 2.1 Client Side RD 提供自然語言敘述

**負責人**：Client Side RD

**工作內容**：
1. 根據 PRD、API Spec、UI/UX Spec，用自然語言描述業務流程
2. 敘述應包含：
   - 流程概述（Feature 名稱、Flow 類型、主要目的）
   - 參與者說明（User、View、Feature、UseCase、Repository、Client、API、External Package 等）
   - 流程步驟詳述（使用者操作、系統行為、條件分支）
   - 技術備註（特殊邏輯、限制條件、待確認事項）

**敘述範例**：

```
這是一個 PrematchComment Feature 的主流程（Full Flow），
流程名稱是「User 進入 Upcoming Race Page, Prematch Comment Page 與 Top/Newest 切換」。

參與者包括：
- User（用戶）
- PrematchCommentView（UI Layer）
- PrematchCommentFeature（Domain Layer）
- LoadCommentsUseCase（Domain Layer）
- PrematchCommentRepository（Data & Infrastructure Layer）
- PrematchCommentClient（Data & Infrastructure Layer）
- ChatAPI（Data & Infrastructure Layer）
- Server（後端）

流程步驟：
1. User 進入 Upcoming Race Page
2. User 點擊進入 Prematch Comment Page
3. PrematchCommentView 初始化，預設顯示 Top tab
4. PrematchCommentFeature 觸發 LoadCommentsUseCase
5. LoadCommentsUseCase 調用 PrematchCommentRepository
6. PrematchCommentRepository 調用 PrematchCommentClient
7. PrematchCommentClient 發送 GET /chat/match/comment/popular 請求
8. Server 回應評論列表
9. 評論列表顯示在 PrematchCommentView
10. User 可以切換到 Newest tab，流程類似但使用不同的 API endpoint

技術備註：
- Top tab 使用 GET /chat/match/comment/popular API
- Newest tab 使用 GET /chat/match/comment/newest API
- 兩個 tab 的資料需要分別管理狀態
```

**產出**：自然語言敘述（可直接提供給 AI 工具）

**估時**：
- Junior：0.5-1 天（每個 Flow）
- Mid-level：0.25-0.5 天（每個 Flow）
- Senior：0.25 天（每個 Flow）

#### 2.2 AI 工具生成 Mermaid Sequence Diagram

**負責人**：Client Side RD（使用 AI 工具）

**工作內容**：
1. 將自然語言敘述提供給 AI 工具（如 Cursor、Claude、ChatGPT）
2. 要求 AI 工具根據敘述生成 Mermaid Sequence Diagram
3. AI 工具應遵循以下規範：
   - 使用 `@feature: {FeatureName}` 標註 Feature
   - 使用 `@flow: Full` 或 `@flow: Sub` 標註 Flow 類型
   - 遵循 Clean Architecture 分層（User → View → Feature → UseCase → Repository → Client → API）
   - 使用 `box` 語法分組 Package 層級
   - 使用 `alt`、`opt`、`loop` 語法標註條件分支和迴圈
   - 使用 `note` 語法添加技術備註（中文）

**AI 提示詞範例**：

```
請根據以下自然語言敘述，生成 Mermaid Sequence Diagram。

敘述：
[貼上自然語言敘述]

要求：
1. 使用 Mermaid sequenceDiagram 語法
2. 標註 @feature: PrematchComment 和 @flow: Full
3. 遵循 Clean Architecture 分層
4. 使用 box 語法分組 Package
5. 使用 alt/opt/loop 語法標註條件分支
6. Note 使用中文
7. 包含所有參與者和互動流程
```

**產出**：`mermaid.md`（Mermaid Sequence Diagram 代碼）

**估時**：
- 使用 AI 工具：0.1-0.2 天（每個 Flow，主要是審查和調整）
- 手動生成：1-2 天（每個 Flow，不推薦）

#### 2.3 AI 工具生成 Description（自然語言敘述）

**負責人**：Client Side RD（使用 AI 工具）

**工作內容**：
1. 將生成的 Mermaid Sequence Diagram 提供給 AI 工具
2. 要求 AI 工具根據 Mermaid 代碼生成結構化的自然語言敘述
3. Description 應包含：
   - 流程概述
   - 參與者說明
   - 流程步驟詳述
   - 技術備註
   - 前置條件與限制

**AI 提示詞範例**：

```
請根據以下 Mermaid Sequence Diagram，生成結構化的自然語言敘述。

Mermaid 代碼：
[貼上 mermaid.md 內容]

要求：
1. 包含流程概述、參與者說明、流程步驟詳述、技術備註
2. 使用 Markdown 格式
3. 結構清晰，易於閱讀
```

**產出**：`description.md`（結構化的自然語言敘述）

**估時**：
- 使用 AI 工具：0.1 天（每個 Flow，主要是審查和調整）
- 手動生成：0.5-1 天（每個 Flow，不推薦）

#### 2.4 AI 工具生成 YAML Flow Spec

**負責人**：Client Side RD（使用 AI 工具）

**工作內容**：
1. 將 `mermaid.md`、`description.md`、API Spec 提供給 AI 工具
2. 要求 AI 工具根據這些資料生成結構化的 YAML Flow Spec
3. YAML Flow Spec 應包含：
   - Flow 資訊（flow_id、flow_type、flow_name、parent_flow_id）
   - Mermaid 代碼
   - Description
   - API Endpoints（從 API Spec 提取）
   - Scenarios（從 PRD 提取）
   - User Actions（從 UI/UX Spec 提取）
   - System Behaviors
   - Notes

**AI 提示詞範例**：

```
請根據以下資料，生成 YAML Flow Spec。

資料：
1. Mermaid 代碼：[貼上 mermaid.md 內容]
2. Description：[貼上 description.md 內容]
3. API Spec：[貼上相關的 API Spec 內容]
4. PRD：[貼上相關的 PRD 內容]
5. UI/UX Spec：[貼上相關的 UI/UX Spec 內容]

要求：
1. 遵循 YAML Flow Spec 結構
2. 提取所有 API Endpoints
3. 提取所有 Scenarios
4. 提取所有 User Actions
5. 提取所有 System Behaviors
6. 標註 Package 類型（external/internal）
```

**產出**：`flow_spec.yaml`（結構化的 YAML 規格檔）

**估時**：
- 使用 AI 工具：0.2-0.3 天（每個 Flow，主要是審查和調整）
- 手動生成：1-2 天（每個 Flow，不推薦）

#### 2.5 Input 目錄結構

```
Input/
└── {Feature組合名稱}/
    └── {Feature名稱}/
        ├── README.md              # Feature 說明文件
        └── [流程資料夾]/
            ├── mermaid.md         # Mermaid 流程圖代碼（AI 生成）
            ├── description.md     # 自然語言敘述（AI 生成）
            └── flow_spec.yaml     # YAML 規格檔（AI 生成）
```

#### 2.6 階段 2 完整流程總結

**工作流程**：

1. **Client Side RD** 提供自然語言敘述（基於 PRD、API Spec、UI/UX Spec）
2. **AI 工具** 生成 `mermaid.md`（Mermaid Sequence Diagram）
3. **AI 工具** 生成 `description.md`（結構化的自然語言敘述）
4. **AI 工具** 生成 `flow_spec.yaml`（結構化的 YAML 規格檔）
5. **Client Side RD** 審查和調整所有產出

**總估時**（使用 AI 工具）：
- Junior：0.5-1 天（每個 Flow）
- Mid-level：0.25-0.5 天（每個 Flow）
- Senior：0.25 天（每個 Flow）

**總估時**（手動生成，不推薦）：
- Junior：3-5 天（每個 Flow）
- Mid-level：2-3 天（每個 Flow）
- Senior：1-2 天（每個 Flow）

**檢查清單**：
- [ ] `mermaid.md` 包含 `@feature` 和 `@flow` 標註
- [ ] `mermaid.md` 遵循 Clean Architecture 分層
- [ ] `description.md` 包含完整的流程說明
- [ ] `flow_spec.yaml` 包含完整的 Flow 資訊
- [ ] `flow_spec.yaml` 中的 API Endpoints 正確
- [ ] `flow_spec.yaml` 中的 Package 類型標註正確
- [ ] Flow 關係正確（parent_flow_id）

---

### 階段 3：AI 自動化生成 TDD

#### 3.1 輸入資料

- `Input/` 目錄下的所有文件（mermaid.md、description.md、flow_spec.yaml）
- `TDD_rules/` 目錄下的所有規範文件

#### 3.2 AI 自動化生成流程

**負責人**：Client Side RD（使用 AI 輔助）

**工作流程**：

1. **讀取 Input 資料**
   - 掃描 Input 目錄結構
   - 讀取所有 Flow 的資料（mermaid.md、description.md、flow_spec.yaml）

2. **解析與整合**
   - 解析 Mermaid 代碼，提取 participants 和互動流程
   - 解析 Description，提取業務背景和技術備註
   - 解析 YAML，提取 API Endpoints、Scenarios、User Actions

3. **應用 TDD 規範**
   - 根據 `TDD_rules/` 下的規範文件生成 TDD
   - 遵循 Clean Architecture 分層
   - 遵循模組收斂規則
   - 遵循 UseCase 收斂規則

4. **生成 TDD 章節**
   - 按照規範生成所有必要章節
   - 生成可選章節（如需要）

**產出**：完整的 TDD 文件（位於 `output/` 目錄）

**估時**（使用 AI 輔助）：
- Junior：3-5 天（完整 TDD，包含所有章節）
- Mid-level：2-3 天（完整 TDD，包含所有章節）
- Senior：1-2 天（完整 TDD，包含所有章節）

---

### 階段 4：生成 Ticket 與估時

#### 4.1 輸入資料

- TDD 文件（特別是 `03_Module Responsibility`、`04_Domain Model`、`05. Module Sequence Diagram`）

#### 4.2 工作內容

**負責人**：Client Side RD（使用 AI 輔助）

**工作流程**：
1. 根據 Clean Architecture 分層，識別所有需要開發的模組
2. 按照依賴順序生成 Ticket：
   - Domain Model Layer（優先）
   - Data & Infrastructure Layer（次優先）
   - Domain Layer（UseCase → Feature）
   - UI Layer（最後）
3. 為每個 Ticket 估算開發時間（Story Point → 實際工時）

**產出**：所有開發 Ticket（位於 `output/12_Tickets/` 目錄）

**估時**（使用 AI 輔助）：
- Junior：1-2 天
- Mid-level：0.5-1 天
- Senior：0.5 天

---

## AI 自動化生成流程

### AI 生成 TDD 的完整流程

```
┌─────────────────────────────────────────────────────────────┐
│ 步驟 1：讀取 Input 資料                                      │
│ - 掃描 Input/ 目錄結構                                       │
│ - 讀取 mermaid.md、description.md、flow_spec.yaml           │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ 步驟 2：解析與整合資料                                       │
│ - 解析 Mermaid 代碼（participants、互動流程）               │
│ - 解析 Description（業務背景、技術備註）                    │
│ - 解析 YAML（API Endpoints、Scenarios、User Actions）       │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ 步驟 3：應用 TDD 規範                                       │
│ - 讀取 TDD_rules/ 下的所有規範文件                          │
│ - 應用 Clean Architecture 分層規則                          │
│ - 應用模組收斂規則                                           │
│ - 應用 UseCase 收斂規則                                      │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ 步驟 4：生成 TDD 章節                                       │
│ - 00_Overview                                                │
│ - 01_Integrated Service-Level Sequence Diagram              │
│ - 02_Architecture                                            │
│ - 03_Module Responsibility                                   │
│ - 04_Domain Model                                            │
│ - 05. Module Sequence Diagram                                │
│ - 06-12（可選章節）                                          │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────────────┐
│ 步驟 5：生成 Ticket 與估時                                   │
│ - 按照依賴順序生成 Ticket                                    │
│ - 估算開發時間                                               │
└─────────────────────────────────────────────────────────────┘
```

### AI 提示詞範例

**生成完整 TDD**：

```
請根據 Input/ 目錄下的資料，按照 TDD_rules/ 目錄下的所有規範，生成完整的 TDD 文件。

Input 資料位置：
- Input/LiveChat&PrematchComment/

請包含以下章節：
1. 00_Overview
2. 01_Integrated Service-Level Sequence Diagram
3. 02_Architecture
4. 03_Module Responsibility
5. 04_Domain Model
6. 05. Module Sequence Diagram
7. 06_Feature State & Action (TCA)（可選）
8. 07_UseCase Input & Output Model（可選）
9. 08_API Spec & Mapping（可選）
10. 09_Error Handling（可選）
11. 10_Test Scenarios（可選）
12. 11_Risks & Questions（可選）
13. 12_Tickets（可選）

請確保所有生成內容符合 TDD_rules/ 下的規範。
```

---

## 文件範本與檢查清單

### PM PRD 範本

```markdown
# {Feature名稱} PRD

## 1. 功能概述
- **目的**：[功能目的]
- **目標用戶**：[目標用戶]
- **使用情境**：[使用情境]

## 2. 使用者故事
- 作為 [角色]，我想要 [行為]，以便 [目標]

## 3. 功能規格
### 3.1 [功能點 1]
- [規格說明]

### 3.2 [功能點 2]
- [規格說明]

## 4. 使用者流程
1. [步驟 1]
2. [步驟 2]
3. [步驟 3]

## 5. 業務規則
- [規則 1]
- [規則 2]

## 6. 驗收條件
- [ ] [條件 1]
- [ ] [條件 2]

## 7. 優先級
P0 / P1 / P2 / P3
```

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

### Designer UI/UX Spec 檢查清單

- [ ] 所有相關畫面設計稿完整
- [ ] 互動流程清晰
- [ ] 狀態定義完整（Loading、Empty、Error、Success）
- [ ] 元件規格清楚
- [ ] 動畫與過渡效果說明
- [ ] 響應式設計考慮
- [ ] 錯誤狀態設計完整

### Client Side RD Input 資料檢查清單

- [ ] `mermaid.md` 包含 `@feature` 和 `@flow` 標註
- [ ] `description.md` 包含流程概述、參與者說明、流程步驟
- [ ] `flow_spec.yaml` 包含完整的 Flow 資訊、API Endpoints、Scenarios
- [ ] Flow 關係正確（parent_flow_id）
- [ ] Package 類型標註正確（external/internal）

---

## 常見問題與解決方案

### Q1：PM PRD 不夠詳細怎麼辦？

**解決方案**：
1. 與 PM 協作，補充缺失的資訊
2. 在 `description.md` 中標註「需與 PM 確認」的項目
3. 在 `flow_spec.yaml` 的 `notes` 中記錄待確認事項

### Q2：BE API Spec 不完整怎麼辦？

**解決方案**：
1. 與 BE 協作，補充缺失的 API 資訊
2. 在 `flow_spec.yaml` 的 `api_endpoints` 中標註「TBD」或「待確認」
3. 在 TDD 的 `11_Risks & Questions` 章節中記錄待確認的 API

### Q3：Designer UI/UX Spec 沒有提供怎麼辦？

**解決方案**：
1. 與 Designer 協作，取得設計稿或規格
2. 根據 PRD 和現有設計系統推導 UI 規格
3. 在 `description.md` 中標註「UI 規格待確認」

### Q4：如何確保 AI 生成的 TDD 符合規範？

**解決方案**：
1. 確保 `TDD_rules/` 目錄下的所有規範文件完整
2. 在 AI 提示詞中明確要求遵循所有規範
3. 生成後進行 Code Review，檢查是否符合規範
4. 使用檢查清單驗證 TDD 完整性

### Q5：多個 Feature 如何整合？

**解決方案**：
1. 在 Input 目錄中，將相關 Feature 放在同一個 Feature 組合目錄下
2. 在 `flow_spec.yaml` 中標註 Feature 關係
3. AI 會自動識別並生成整合的 TDD 文件

---

## 總估時總結

### 完整流程估時（使用 AI 輔助）

| 階段 | Junior | Mid-level | Senior |
|------|--------|-----------|--------|
| **階段 0：需求收集** | PM/BE/Designer 提供文件 | PM/BE/Designer 提供文件 | PM/BE/Designer 提供文件 |
| **階段 1：需求分析與流程設計** | 5-8 天 | 3-5 天 | 1.5-3 天 |
| **階段 2：產生 Input 資料（AI 輔助）** | 0.5-1 天 | 0.25-0.5 天 | 0.25 天 |
| **階段 3：AI 生成 TDD** | 3-5 天 | 2-3 天 | 1-2 天 |
| **階段 4：生成 Ticket 與估時** | 1-2 天 | 0.5-1 天 | 0.5 天 |
| **總計** | **9-15 天** | **5.75-9.5 天** | **3-6.75 天** |

### 完整流程估時（手動，不建議）

| 階段 | Junior | Mid-level | Senior |
|------|--------|-----------|--------|
| **階段 0：需求收集** | PM/BE/Designer 提供文件 | PM/BE/Designer 提供文件 | PM/BE/Designer 提供文件 |
| **階段 1：需求分析與流程設計** | 5-8 天 | 3-5 天 | 1.5-3 天 |
| **階段 2：產生 Input 資料（手動，不推薦）** | 3-5 天 | 2-3 天 | 1-2 天 |
| **階段 3：手動生成 TDD** | 10-15 天 | 7-10 天 | 5-7 天 |
| **階段 4：生成 Ticket 與估時** | 3-5 天 | 2-3 天 | 1-2 天 |
| **總計** | **24-38 天** | **16-24 天** | **9.5-15 天** |

---

## 最佳實踐

### 1. 文件準備階段

- ✅ **PM**：提供詳細的 PRD，包含所有業務規則和驗收條件
- ✅ **BE**：提供完整的 API Spec（OpenAPI 格式最佳），包含所有端點和資料結構
- ✅ **Designer**：提供完整的 UI/UX Spec，包含所有狀態和互動流程
- ✅ **Client Side RD**：與各角色協作，確保文件完整

### 2. Input 資料產生階段

- ✅ 確保 `mermaid.md` 符合 Mermaid 語法規範
- ✅ 確保 `description.md` 包含完整的流程說明
- ✅ 確保 `flow_spec.yaml` 包含所有必要的結構化資訊
- ✅ 使用 AI 輔助產生 Input 資料，提高效率

### 3. TDD 生成階段

- ✅ 使用 AI 輔助生成，大幅縮短時間
- ✅ 確保所有生成內容符合 `TDD_rules/` 下的規範
- ✅ 生成後進行 Code Review，確保品質
- ✅ 使用檢查清單驗證 TDD 完整性

### 4. 持續改進

- ✅ 根據實際使用經驗，持續優化規範文件
- ✅ 收集常見問題，更新本文檔
- ✅ 與團隊分享最佳實踐

---

## 相關文件

- [TDD Input 資料處理規範](./TDD_rules/tdd_input_processing_rules.md)
- [TDD Ticket 生成與估時規範](./TDD_rules/tdd_ticket_generation_and_estimation.md)
- [TDD Domain, API, Test & TDD Structure](./TDD_rules/tdd_domain_api_test_and_structure.md)
- [TDD Sequence & Mermaid Rules](./TDD_rules/tdd_sequence_and_mermaid_rules.md)
- [Client Side RD 工作流程](./TDD_rules/tdd_workflow_from_prd_to_tdd.md)

---

## 關鍵成功因素

### 1. 文件完整性

**PM PRD 必須包含**：
- ✅ 完整的使用者故事
- ✅ 詳細的功能規格
- ✅ 清晰的業務規則
- ✅ 明確的驗收條件

**BE API Spec 必須包含**：
- ✅ 所有 API Endpoints 的完整定義
- ✅ Request/Response Schema
- ✅ 錯誤處理機制
- ✅ WebSocket 規格（如適用）

**Designer UI/UX Spec 必須包含**：
- ✅ 所有畫面的設計稿
- ✅ 完整的互動流程
- ✅ 所有 UI 狀態定義
- ✅ 動畫和過渡效果說明

### 2. 協作與溝通

- ✅ **定期同步**：Client Side RD 應與 PM、BE、Designer 定期同步，確保理解一致
- ✅ **及時澄清**：遇到不清楚的地方，應及時與相關角色確認
- ✅ **文件更新**：需求變更時，應及時更新所有相關文件

### 3. AI 輔助使用

- ✅ **規範遵循**：確保 AI 嚴格遵循 `TDD_rules/` 下的所有規範
- ✅ **迭代優化**：根據生成結果，持續優化提示詞和規範
- ✅ **人工審查**：AI 生成的內容必須經過人工審查，確保品質

---

## 文件格式建議總結

### 推薦格式對照表

| 角色 | 推薦格式 | 替代格式 | 不推薦格式 |
|------|---------|---------|-----------|
| **PM** | **YAML** | Markdown | Word / PDF |
| **BE** | **OpenAPI 3.0 (YAML)** | OpenAPI 3.0 (JSON) | Markdown / Word |
| **Designer** | **YAML + Figma** | JSON + Figma / Markdown + Figma | 僅 Figma / Sketch |

### 為什麼選擇結構化格式？

1. **AI 解析效率**
   - 結構化格式（YAML/JSON）易於 AI 解析和提取資訊
   - 非結構化格式（Word/PDF）需要額外的 OCR 或解析步驟

2. **版本控制**
   - YAML/JSON 可以完整追蹤變更（Git diff）
   - Word/PDF 難以追蹤具體變更內容

3. **自動化處理**
   - 可以自動驗證格式和完整性
   - 可以自動轉換為其他格式
   - 可以自動生成文檔

4. **協作效率**
   - 結構化格式易於多人協作和審查
   - 可以建立範本和檢查清單

---

## 附錄：文件範本下載

### PM PRD 範本
- ✅ [PRD_Template.yaml](./templates/PRD_Template.yaml) - YAML 格式（推薦）
- [PRD_Template.md](./templates/PRD_Template.md) - Markdown 格式（待建立）

### BE API Spec 範本
- ✅ **使用 OpenAPI 3.0 標準格式**（參考 [OpenAPI Specification](https://swagger.io/specification/)）
- 範例：參考 `Input/` 目錄下的 `flow_spec.yaml` 中的 `api_endpoints` 結構

### Designer UI/UX Spec 範本
- ✅ [UI_UX_Spec_Template.yaml](./templates/UI_UX_Spec_Template.yaml) - YAML 格式（推薦）
- [UI_UX_Spec_Template.md](./templates/UI_UX_Spec_Template.md) - Markdown 格式（待建立）

### Client Side RD Input 資料範本
- [mermaid_template.md](./templates/mermaid_template.md)（待建立）
- [description_template.md](./templates/description_template.md)（待建立）
- [flow_spec_template.yaml](./templates/flow_spec_template.yaml)（待建立）

---

## 文件格式轉換工具

### PM PRD：Word/PDF → YAML

如果 PM 提供的是 Word 或 PDF 格式，可以使用以下方式轉換：

1. **手動轉換**：根據 YAML 範本手動填寫
2. **AI 輔助轉換**：使用 AI 工具將 Word/PDF 內容轉換為 YAML 格式
3. **建立轉換腳本**：開發自動化腳本（如需要）

### BE API Spec：Markdown → OpenAPI 3.0

如果 BE 提供的是 Markdown 格式的 API Spec，建議：

1. **要求 BE 提供 OpenAPI 3.0 格式**（最佳）
2. **手動轉換**：根據 OpenAPI 3.0 範本手動填寫
3. **使用工具**：使用 [Swagger Editor](https://editor.swagger.io/) 等工具協助轉換

### Designer UI/UX Spec：僅 Figma → YAML + Figma

如果 Designer 只提供 Figma 設計稿，建議：

1. **補充 YAML 規格**：根據 Figma 設計稿，填寫 YAML 規格文件
2. **AI 輔助提取**：使用 AI 工具從 Figma 設計稿中提取結構化資訊
3. **協作填寫**：與 Designer 協作，共同填寫 YAML 規格文件

---

## 快速參考

### 給 PM 的檢查清單

- [ ] PRD 包含功能概述、使用者故事、功能規格
- [ ] 使用者流程清晰完整
- [ ] 業務規則明確
- [ ] 驗收條件具體可測量
- [ ] 優先級已標註

### 給 BE 的檢查清單

- [ ] API Spec 格式標準（OpenAPI 3.0 最佳）
- [ ] 所有 Endpoints 已定義
- [ ] Request/Response Schema 完整
- [ ] 錯誤處理機制清楚
- [ ] WebSocket 規格完整（如適用）

### 給 Designer 的檢查清單

- [ ] 所有相關畫面設計稿完整
- [ ] 互動流程清晰
- [ ] 所有 UI 狀態已定義
- [ ] 動畫和過渡效果已說明
- [ ] 錯誤狀態設計完整

### 給 Client Side RD 的檢查清單

- [ ] 已閱讀並理解所有輸入文件（PRD、API Spec、UI/UX Spec）
- [ ] Input 資料完整（mermaid.md、description.md、flow_spec.yaml）
- [ ] Flow 關係正確（主流程和子流程）
- [ ] TDD 生成符合所有規範
- [ ] Ticket 生成完整且估時合理

---

**最後更新**：2024-11-21  
**版本**：1.0.0

