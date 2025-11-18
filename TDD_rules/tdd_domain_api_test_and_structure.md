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
