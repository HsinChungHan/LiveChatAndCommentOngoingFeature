# TDD Domain, API, Test & TDD Structure

本文件定義：

- Domain Model / Feature State & Action / UseCase Input & Output
- API Mapping 規範
- Shared Module 規範
- Test & Edge Case 推導規範
- 完整 TDD 文件章節結構（技術設計文件 TDD 的最終產出格式）

本文件需同時符合：

- 《TDD Layers & Responsibilities》
- 《TDD Sequence & Mermaid Rules》
- 《TDD UseCase Consolidation Rules》
- 《TDD Module Consolidation Rules》

---

# 1. Domain Model / State / Action / UseCase IO

每個 Feature 必須定義以下內容：

---

## 1.1 Domain Models（Domain Model Layer）

### 1.1.1 Domain Model 定義

**Domain Model** 是領域模型層的總稱，包含：
- **Entity（實體）**
- **Value Object（值物件）**

**核心原則**：
- 純資料結構，無商業邏輯、無流程控制
- 不依賴 Repository / Client / API
- 不作為 Sequence Diagram participant
- 只描述資料本身（例如 Comment、ChatMessage、UserInfo）

**重要區分**：
- **Domain Model Layer** = 純資料模型層（Entity + Value Object）
- **Domain Layer** = Domain 行為層（Feature + UseCase）
- 兩者**完全不同**

---

### 1.1.2 Entity（實體）定義與規定

#### 定義
Entity 是有唯一識別碼的業務物件，代表領域中可被識別和追蹤的「東西」。

#### 判斷依據
使用 Entity 的情況：
- ✅ 物件有唯一識別碼（ID）
- ✅ 需要追蹤物件的狀態變化
- ✅ 物件的屬性會被修改
- ✅ 業務語意上這是「一個東西」（如：一則評論、一個使用者、一則訊息）
- ✅ 需要透過 ID 來查找或引用這個物件

#### Swift + TCA 實作規定
- **類型**：使用 `struct`（符合 TCA 不可變狀態原則）
- **協議**：實現 `Identifiable`（透過 `id` 屬性）
- **比較**：實現 `Equatable`（透過 `id` 比較）
- **可變性**：屬性可以是 `var`（可變），但更新時建立新實例（TCA 模式）

#### 範例
```swift
struct Comment: Identifiable, Equatable {
    let id: String  // 唯一識別碼
    let content: String
    var likeCount: Int  // 可變屬性
    
    // 透過 id 來比較
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id
    }
}
```

#### 建模原則
- **以業務語意建模**，不以 API schema 建模
- 不要因 API schema 不同就做出多種 Entity
- 同一業務資源應使用單一 Entity

---

### 1.1.3 Value Object（值物件）定義與規定

#### 定義
Value Object 是沒有唯一識別碼，透過值來比較的物件，代表領域中描述性的「值」或「狀態」。

#### 判斷依據
使用 Value Object 的情況：
- ✅ 物件沒有唯一識別碼
- ✅ 只關心物件的「值」，不關心「是哪一個」
- ✅ 物件通常不可變（immutable）
- ✅ 業務語意上這是「描述」或「狀態」（如：排序方式、分頁資訊、游標）
- ✅ 可被多個 Entity 共享使用
- ✅ 兩個物件如果值相同，就視為相同

#### Swift + TCA 實作規定
- **類型**：使用 `struct`
- **協議**：實現 `Equatable`（值比較）
- **可變性**：屬性全部使用 `let`（完全不可變）
- **共享**：可被多個 Feature 共享（放在 SharedValueObjects）

#### 範例
```swift
struct Cursor: Equatable {
    let value: String?  // 完全不可變
    
    // 兩個 Cursor 如果 value 相同，就視為相同
    // Swift 自動實現 Equatable
}
```

#### 建模原則
- 可集中在 `SharedValueObjects` 中
- 多個 Feature 共用的 Value Object 應標明可共享
- 例如：Cursor、PagingInfo、SortOption

---

### 1.1.4 DTO（Data Transfer Object）定義與規定

#### 定義
DTO 是資料傳輸物件，用於在 Client 和 API 之間傳輸資料，代表後端 API 的 Request / Response 結構。

#### 使用場景
- **Request DTO**：Client 發送到 API 的請求資料
- **Response DTO**：API 回傳給 Client 的響應資料
- **WebSocket DTO**：WebSocket 訊息的 payload

#### 規定
- **只能存在於**：Client Layer 和 API Layer 之間
- **不能被使用於**：
  - ❌ Feature Layer
  - ❌ UseCase Layer
  - ❌ Repository Layer（Repository 必須轉換為 Domain Model）
- **轉換責任**：Repository 必須負責所有 DTO → Domain Model 的轉換

#### 命名規範
- Request DTO：`XxxRequestDTO` 或 `XxxRequest`
- Response DTO：`XxxResponseDTO` 或 `XxxResponse`
- WebSocket DTO：`XxxMessageDTO` 或 `XxxMessage`

---

### 1.1.5 Domain Model vs DTO 對照

| 特性 | Domain Model | DTO |
|------|-------------|-----|
| **用途** | 業務領域的資料模型 | API 傳輸的資料結構 |
| **存在位置** | Domain Model Layer | Client Layer ↔ API Layer |
| **可被使用** | Feature、UseCase、Repository | Client、API |
| **不可被使用** | - | Feature、UseCase、Repository |
| **轉換** | - | Repository 負責 DTO → Domain Model |
| **建模依據** | 業務語意 | API schema |
| **Swift 類型** | `struct`（Entity / Value Object） | `struct`（通常） |

---

### 1.1.6 Domain Model 關係規定

#### 關係類型
Domain Model 之間的關係應使用標準 UML 關係類型：

| 關係類型 | UML 符號 | 說明 | 範例 |
|---------|---------|------|------|
| **Association（關聯）** | `--` | 兩個類別之間有關係，但彼此獨立 | Comment -- CommentMeta |
| **Aggregation（聚合）** | `--o` | 弱擁有關係，部分可以脫離整體存在 | （視需求使用） |
| **Composition（組合）** | `*--` | 強擁有關係，部分不能脫離整體存在 | PagingInfo *-- Cursor |
| **Generalization（泛化）** | `--\|>` | 繼承關係 | （視需求使用） |

#### 關係術語
在 Domain Model 關係圖中，可以使用語意化術語來描述關係：
- `references`：引用關係（Association）
- `has author`：擁有作者（Association）
- `belongs to`：屬於（Association）
- `contains`：包含（Composition）

#### 關係圖要求
- 必須包含語意化關係圖（使用業務術語）
- 建議包含標準 UML 關係圖（使用標準符號）
- 必須包含關係說明表格，說明每個關係的：
  - 語意化關係
  - 標準 UML 關係
  - 關係說明
  - 實作方式
  - 方向

---

### 1.1.7 Domain Model 在 TCA 中的使用

#### Feature State 中的 Domain Model
- Feature State 可以保存 Domain Model（Entity 陣列、Value Object）
- Feature State **不能保存 DTO**
- 範例：
  ```swift
  struct PrematchCommentState {
      var comments: [Comment]  // ✅ Entity 陣列
      var pagingInfo: PagingInfo?  // ✅ Value Object
      var cursor: Cursor?  // ✅ Value Object
      // var apiResponse: CommentResponseDTO  // ❌ 禁止
  }
  ```

#### UseCase Input / Output 中的 Domain Model
- UseCase Input 可以包含 Value Object（如 Cursor、SortMode）
- UseCase Input **不可使用 DTO**
- UseCase Output 必須回傳 Domain Model
- 範例：
  ```swift
  struct ReloadCommentListInput {
      let refId: String
      let mode: SortMode  // ✅ Value Object
      let cursor: Cursor?  // ✅ Value Object
      // let requestDTO: CommentRequestDTO  // ❌ 禁止
  }
  
  struct ReloadCommentListOutput {
      let comments: [Comment]  // ✅ Entity 陣列
      let pagingInfo: PagingInfo  // ✅ Value Object
  }
  ```

#### Repository 中的 Domain Model
- Repository 接收和回傳 Domain Model
- Repository 負責 DTO → Domain Model 轉換
- 範例：
  ```swift
  func getComments(refId: String, mode: SortMode) async throws -> [Comment] {
      let dto = try await client.getComments(refId, mode: mode.value)
      return dto.map { Comment(from: $0) }  // DTO → Domain Model
  }
  ```

---

## 1.2 Feature State（TCA）

- 表示 UI 需要的所有狀態：
  - 列表資料
  - loading flag
  - error
  - pagination cursor
  - tab / filter 選擇
  - WebSocket 狀態（若需要）
- State 不能保存 DTO，也不能依賴 Client / Repository / API。

---

## 1.3 Feature Action（TCA）

Action 用於接收：

- 使用者互動（tap / input / select）
- Lifecycle（onAppear / onDisappear）
- 系統事件（WebSocket push message）
- 與 UseCase 的回傳（.response）

Action 僅代表 UI 發生什麼，不包含邏輯。

---

## 1.4 UseCase Input Model

- Feature 呼叫 UseCase 的參數封裝
- 不可使用 DTO（避免耦合）
- 可包含 triggerType / mode / tabType / cursor 等資訊
- 若 UseCase 由多種行為合併而成，Input Model 是區分行為的唯一來源

---

## 1.5 UseCase Output Model

- UseCase 回傳給 Feature 的 Domain 結果
- 可包含：
  - Domain Model（例如 comments）
  - UI 所需的 meta（例如 hasMore、shouldScrollToTop）
- Feature 只能依賴 Output，不可依賴 Repository / DTO

---

## 1.6 DTO → Domain Model Mapping（由 Repository 處理）

- Repository 必須負責所有 DTO → Domain Model 的轉換
- Feature / UseCase 永遠不得使用 DTO 結構
- UseCase 只能拿到 Domain Model 層級資料

---

# 2. API Mapping 規範

每個 API 必須完整記錄以下資訊：

- URL
- HTTP Method
- Request DTO
- Response DTO
- 所屬 UseCase
- 所屬 Feature 或 Shared Feature
- 若為 WebSocket，還需：
  - subscribe/unsubscribe 行為
  - message type / payload schema
- Mapping：DTO → Domain Model
- 呼叫鏈：**UseCase → Repository → Client → API**

⚠️ 注意：  
API 只能被 Client 呼叫。  
不得被 UseCase / Feature 直接使用。

---

# 3. Shared Module 規範

必須標示與解釋以下 Shared Modules：

- **AuthFeature**
- **NicknameFeature**
- **UserProfileFeature**
- **UserInfoRepository**
- **BlacklistRepository**
- 其他可能的跨場景共用模組（如 NotificationSettingRepository）

需要說明：

- 哪些 Feature / UseCase 會使用
- 共用原因（user identity、permission、黑名單、profile data 之類）
- 該 Shared Module 屬於哪一層（Feature / UseCase / Repository）

Shared Module 一律遵守 Domain Layer 或 Data & Infra Layer 規範。

---

# 4. Test Case 與 Edge Case 推導規範

測試案例必須由 mermaid 中的 alt/opt/loop 自動推導。

---

## 4.1 基本測試類型

每個 UseCase 必須包含：

- **Basic Flow**
  - 正常成功流程
- **Branch Flow（alt）**
  - 分支行為（例如 top / newest）
- **Optional Flow（opt）**
  - 部分情況可能發生的流程（例如未登入）
- **Loop Flow**
  - pagination / backward loading / repeated attempts
- **Error Flow**
  - API error（500 / 404 / 423 等）
  - validation error
  - network failure
  - WebSocket error
- **Recover Flow**
  - retry
  - reconnect
  - re-sync
- **Edge Case**
  - cursor 無效
  - 資料全部載完
  - WebSocket 中斷後重連
  - TTL 過期（如 blacklist 4 小時過期）
  - empty state
  - partial update

---

## 4.2 UseCase 測試覆蓋率規則

- 每個 UseCase 至少需要一組完整 Test Scenario
- 關鍵 UseCase（publish, sendMessage, joinChatroom）需包含：
  - 成功
  - error
  - recover
  - edge case

測試案例需完全符合 UseCase Consolidation 後的行為邏輯。

---

# 5. TDD 文件章節（最終固定結構）

以下結構為每份 TDD 的最終標準格式。

---

## 5.1 Overview

- 整體描述 Feature 或 Module 的目的
- 包含 scope / goal / 主要使用者互動

---

## 5.2 Integrated Service-Level Sequence Diagram（ISSD）

- 跨場景、跨 Feature、跨 UseCase 的整合序列圖
- 顯示 Shared Modules、Repository、Client 如何共同運作
- 用於呈現整體系統的 high-level 協作

---

## 5.3 Architecture

- 需包含垂直 Clean Architecture 圖
- 層級必須為：
  - **UI Layer**
  - **Domain Layer（Feature + UseCase）**
  - **Domain Model Layer（Entity）**
  - **Data & Infrastructure Layer（Repository + Client + API）**

- 說明每層的責任與不可違反的依賴方向：

  **UI → Feature → UseCase → Repository → Client → API**

---

## 5.4 Module Responsibility

列出並說明所有模組，**建議使用表格呈現**以便快速查找與比較：

- Feature Modules（Thin Reducer）
- UseCase Modules
- Repository Modules
- Client Modules
- API Modules
- Shared Modules

### 表格欄位建議

**Feature Modules 表格欄位**：
1. 模組名稱
2. 層級
3. 職責
4. 使用的 UseCase
5. 不包含

**UseCase Modules 表格欄位**：
1. UseCase 名稱
2. 層級
3. 職責
4. Input Model
5. Output Model
6. 使用的 Repository
7. 使用的 Shared Feature

**Repository Modules 表格欄位**：
1. Repository 名稱
2. 層級
3. 職責
4. 提供的方法
5. 使用的 Client
6. 被使用的 Feature
7. 備註

**Client Modules 表格欄位**：
1. Client 名稱
2. 層級
3. 技術
4. 職責
5. 使用的 API
6. 被使用的 Feature
7. 備註

**API Modules 表格欄位**：
1. API 名稱
2. 層級
3. 職責
4. Endpoints
5. 只能被
6. 被使用的 Feature
7. 備註

**Shared Modules 表格欄位**：
1. Shared Module 名稱
2. 層級
3. 職責
4. 提供的方法
5. 被使用的 Feature
6. 共用原因

### 表格內容格式規範

**重要規則**：所有在表格的欄位中，若有要分行表示的，都用 number list（數字列表）的方式進行分行。

**範例**：
- ❌ 錯誤：使用 bullet point (`•`) 或 `<br>` 標籤
  ```
  | 屬性 | • `id: String`<br>• `content: String` |
  ```
- ✅ 正確：使用 number list
  ```
  | 屬性 | 1. `id: String`<br>2. `content: String` |
  ```

需套用 Module Consolidation Rules：

- 收斂同 bounded context
- Repository / Client / API 分層正確
- UseCase 按 Domain 行為收斂

---

## 5.5 Module Sequence Diagram（依 View × UseCase）

每個 View 需產生 2–5 張高價值 UseCase 序列圖：

- Data Initialization / Refresh
- Data Interaction（會變動資料或打 API）
- Structural Navigation（會觸發其他 Feature 或 Shared Feature）

需遵守：

- Mermaid 安全規範
- 三大 box（UI / Domain / Data & Infra）
- Note（中文）
- Feature 與 UseCase 不能越層呼叫

---

## 5.6 Domain Model

定義：

- 所有 Entity
- 所有 Value Object
- 若多個 Feature 共用某些 VO（例如 Cursor / PagingInfo），需標明可共享

---

## 5.7 Feature State & Action（TCA）

需明確定義：

- 每個 Feature 的 State 結構
- 所有 Action 及其語意
- 哪些 Action 會觸發哪些 UseCase

---

## 5.8 UseCase Input & Output Model

每個 UseCase 需定義：

- Input Model
- Output Model
- 與 Domain Model、DTO 的關係

---

## 5.9 API Spec & Mapping

需定義：

- URL / Method
- Request DTO / Response DTO
- 所屬 Repository / Client / UseCase
- DTO → Domain Model Mapping 規則

---

## 5.10 Error Handling

每個 UseCase 需記錄：

- 錯誤分類（Validation / Network / Backend）
- UI 呈現方式
- 是否自動 retry / reconnect

---

## 5.11 Test Scenarios

需依照 alt / opt / loop 推導所有測試案例：

- Basic
- Branch
- Optional
- Loop
- Error
- Recover
- Edge Case

---

## 5.12 Risks & Questions

列出所有：

- 未定義的需求
- 不確定的 Backend 行為
- 時序 / 效能 / TTL / retry policy 的風險
- TODO / 需後端確認項

---

## 5.13 Ticket 生成與估時 ⚠️ Optional

根據 TDD 文件自動生成開發 Ticket 並進行開發時間估算。

**詳細規範請參考《TDD Ticket 生成與估時規範》（tdd_ticket_generation_and_estimation.md）**

### 5.13.1 Ticket 生成原則

- 按 Clean Architecture 分層順序生成 Ticket
- 每個 Ticket 對應一個可獨立開發、測試、驗收的模組
- 標註 Ticket 依賴關係

### 5.13.2 估時規則

- 使用 Story Point（Fibonacci 數列）
- 根據模組類型和複雜度評估
- 考慮技術調整因子和業務調整因子
- 根據工程師等級轉換為實際工時

### 5.13.3 輸出結構

```
output/
└── {Feature}/
    └── 12_Tickets/
        ├── README.md                    # Ticket 總覽和索引
        ├── tickets.json                  # Ticket JSON 格式（可選）
        ├── 01_domain_model/
        ├── 02_api/
        ├── 03_client/
        ├── 04_repository/
        ├── 05_usecase/
        ├── 06_feature/
        └── 07_view/
```

---

## 5.14 輸出文件存放規則

### 5.14.1 根目錄結構

所有 TDD 文件必須存放在 `output/` 資料夾下，按以下規則組織：

```
output/
└── {Feature組合名稱}/              # 根據 @feature 標籤命名
    ├── 00_Overview/
    ├── 01_Integrated Service-Level Sequence Diagram/
    ├── 02_Architecture/
    ├── 03_Module Responsibility/
    ├── 04_Domain Model/
    ├── 05. Module Sequence Diagram（模組序列圖）/
    ├── 06_Feature State & Action (TCA)/        # Optional
    ├── 07_UseCase Input & Output Model/        # Optional
    ├── 08_API Spec & Mapping/                  # Optional
    ├── 09_Error Handling/                      # Optional
    ├── 10_Test Scenarios/                      # Optional
    └── 11_Risks & Questions/                   # Optional
```

### 5.14.2 Feature 組合命名規則

| 情況 | 命名規則 | 範例 |
|------|---------|------|
| **單一 Feature** | 直接使用 Feature 名稱 | `PrematchComment` |
| **多個 Feature** | 使用 `&` 連接 | `LiveChat&PrematchComment` |
| **無 @feature 標籤** | 使用預設名稱 | `Feature1`, `Feature2` |

### 5.14.3 章節資料夾命名規則

| 章節 | 資料夾名稱格式 | 範例 |
|------|--------------|------|
| **必需章節** | `{兩位數字}_{章節名稱}` | `00_Overview`<br>`01_Integrated Service-Level Sequence Diagram`<br>`02_Architecture` |
| **可選章節** | `{兩位數字}_{章節名稱}` | `06_Feature State & Action (TCA)`<br>`07_UseCase Input & Output Model` |

**命名規範**：
- 使用兩位數字編號（00, 01, 02...）
- 章節名稱使用英文，可包含空格和括號
- 必需章節：00-05
- 可選章節：06-11

### 5.14.4 章節資料夾內容結構

每個章節資料夾必須包含：

1. **README.md**（統整文件）
   - 說明該章節的目的
   - 列出該章節下的所有文件

2. **具體內容文件**（.md 文件）
   - 命名格式：`{序號}_{描述}.md`
   - 序號：01, 02, 03...（兩位數字）
   - 描述：簡短描述（使用英文或中文）

**範例**：
```
04_Domain Model/
├── README.md
├── 01_domain_model.md
└── 02_domain_model_uml_standard.md
```

### 5.14.5 Module Sequence Diagram 特殊結構

Module Sequence Diagram 章節（05）有特殊的資料夾結構：

```
05. Module Sequence Diagram（模組序列圖）/
├── {Feature1}/
│   └── Module Sequence Diagrams/
│       ├── README.md
│       ├── 01_data_initialization_*.md
│       ├── 02_data_interaction_*.md
│       └── 03_structural_navigation_*.md
├── {Feature2}/
│   └── Module Sequence Diagrams/
│       ├── README.md
│       └── ...
```

**規則**：
- 若只有單一 Feature，直接在 `05. Module Sequence Diagram（模組序列圖）/` 下建立 `Module Sequence Diagrams/` 資料夾
- 若有多個 Feature，為每個 Feature 建立獨立資料夾，每個資料夾下再建立 `Module Sequence Diagrams/` 資料夾

**序列圖文件命名規則**：
- 格式：`{序號}_{類型}_{描述}.md`
- 序號：01, 02, 03...（兩位數字）
- 類型：
  - `data_initialization_refresh` - 資料初始化/刷新
  - `data_interaction` - 資料互動（會變動資料或打 API）
  - `structural_navigation` - 結構導航（會觸發其他 Feature）
- 描述：簡短描述（使用英文）

**範例**：
- `01_data_initialization_refresh.md`
- `02_data_interaction_load_replies.md`
- `03_data_interaction_toggle_like.md`
- `04_data_interaction_publish_comment.md`
- `05_structural_navigation_profile.md`

### 5.14.6 完整輸出結構範例

#### 單一 Feature 範例

```
output/
└── PrematchComment/
    ├── 00_Overview/
    │   ├── README.md
    │   └── 01_overview.md
    ├── 01_Integrated Service-Level Sequence Diagram/
    │   ├── README.md
    │   └── 01_full_integration_flow.md
    ├── 02_Architecture/
    │   ├── README.md
    │   └── 01_clean_architecture_diagram.md
    ├── 03_Module Responsibility/
    │   ├── README.md
    │   └── 01_module_responsibility.md
    ├── 04_Domain Model/
    │   ├── README.md
    │   ├── 01_domain_model.md
    │   └── 02_domain_model_uml_standard.md
    └── 05. Module Sequence Diagram（模組序列圖）/
        └── Module Sequence Diagrams/
            ├── README.md
            ├── 01_data_initialization_refresh.md
            ├── 02_data_interaction_load_replies.md
            └── ...
```

#### 多個 Feature 範例

```
output/
└── LiveChat&PrematchComment/
    ├── 00_Overview/
    │   ├── README.md
    │   └── 01_overview.md
    ├── 01_Integrated Service-Level Sequence Diagram/
    │   ├── README.md
    │   └── 01_full_integration_flow.md
    ├── 02_Architecture/
    │   ├── README.md
    │   └── 01_clean_architecture_diagram.md
    ├── 03_Module Responsibility/
    │   ├── README.md
    │   └── 01_module_responsibility.md
    ├── 04_Domain Model/
    │   ├── README.md
    │   ├── 01_domain_model.md
    │   └── 02_domain_model_uml_standard.md
    ├── 05. Module Sequence Diagram（模組序列圖）/
    │   ├── LiveChat/
    │   │   └── Module Sequence Diagrams/
    │   │       ├── README.md
    │   │       ├── 01_data_initialization_initialize_chatroom.md
    │   │       └── ...
    │   └── PrematchComment/
    │       └── Module Sequence Diagrams/
    │           ├── README.md
    │           ├── 01_data_initialization_refresh.md
    │           └── ...
    ├── 06_Feature State & Action (TCA)/        # Optional
    │   ├── README.md
    │   └── 01_feature_state_action.md
    └── 07_UseCase Input & Output Model/        # Optional
        ├── README.md
        └── 01_usecase_input_output.md
```

### 5.14.7 Input 資料引用規範

**原則**：Output 目錄不應複製 Input 資料，而是透過引用建立關聯。

#### 5.14.7.1 不複製 Input 的原因

1. **單一來源原則（Single Source of Truth）**
   - Input 是原始規格來源
   - Output 是從 Input 生成的衍生文件
   - 複製會造成多個來源，增加維護成本

2. **維護成本**
   - Input 更新時需同步更新 output 下的複本
   - 容易出現版本不一致
   - 增加儲存空間

3. **職責分離**
   - Input：原始規格（業務流程、補充資訊）
   - Output：技術設計文件（TDD）
   - 兩者職責不同，應分離

#### 5.14.7.2 引用方式

**方式 1：在 Overview 中引用（推薦）**

在 `00_Overview/01_overview.md` 中添加「資料來源」章節：

```markdown
## 資料來源

本 TDD 文件基於以下 Input 資料生成：

- **Input 路徑**: `Input/LiveChat&PrematchComment/Mermaid/Prematch Comment/`
- **Flow 列表**:
  - PC-FULL-001: `User 進入 Upcoming Race Page, Prematch Comment Page 與 Top/`
  - PC-SUB-001: `Event Status 訂閱與通知流程/`
```

**方式 2：透過 Flow ID 關聯**

每個序列圖文件包含 Flow 資訊（flow_id、flow_name 等），可透過這些資訊追蹤到對應的 input。

**方式 3：建立對照表（可選）**

在 output 根目錄的 README 中建立 Input-Output 對照表：

```markdown
## Input-Output 對照表

| Flow ID | Flow Name | Input 路徑 | Output 文件 |
|---------|-----------|-----------|------------|
| PC-FULL-001 | 用戶進入 Upcoming Race Page... | `Input/.../User 進入.../` | `05. Module Sequence Diagram/.../01_data_initialization_refresh.md` |
```

#### 5.14.7.3 檢查清單

生成 TDD 文件時，請確認：

- [ ] 未複製 Input 資料到 Output 目錄
- [ ] 在 Overview 中添加資料來源引用
- [ ] Flow 資訊中包含 flow_id，可追蹤到對應的 Input

### 5.14.8 文件命名規範總結

| 文件類型 | 命名格式 | 範例 |
|---------|---------|------|
| **章節資料夾** | `{兩位數字}_{章節名稱}` | `00_Overview`<br>`04_Domain Model` |
| **README 文件** | `README.md` | `README.md` |
| **章節內容文件** | `{兩位數字}_{描述}.md` | `01_domain_model.md`<br>`02_domain_model_uml_standard.md` |
| **序列圖文件** | `{兩位數字}_{類型}_{描述}.md` | `01_data_initialization_refresh.md`<br>`02_data_interaction_load_replies.md` |

### 5.14.9 重要規則

1. **所有文件必須放在 `output/` 資料夾下**
2. **每個章節資料夾必須包含 README.md**
3. **章節編號必須使用兩位數字（00-11）**
4. **文件編號必須使用兩位數字（01, 02, 03...）**
5. **Module Sequence Diagram 章節必須按 Feature 分組**
6. **所有 .md 文件必須使用 UTF-8 編碼**
7. **不應複製 Input 資料到 Output 目錄，應透過引用建立關聯**

---
