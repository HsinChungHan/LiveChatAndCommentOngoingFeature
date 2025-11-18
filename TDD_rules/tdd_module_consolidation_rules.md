# TDD Module Consolidation Rules（通用 Module 收斂策略與規則）

本文件定義：  
從 mermaid sequenceDiagram 推導 module 時，如何在 **不破壞三層架構（UI / Domain / Data & Infrastructure）**  
的前提下，進行合理的「收斂 / 合併」，避免過度細分與命名爆炸。

此規範需與：

- 《TDD Layers & Responsibilities》
- 《TDD UseCase Consolidation Rules》
- 《TDD Sequence & Mermaid Rules》

共同使用。

---

# 1. 收斂的總原則

## 1.1 僅在「同一 Layer」內進行收斂（最高原則）

禁止跨 Layer 合併：

- Feature + UseCase（X） → 必須保持 Domain 分層清晰  
- UseCase + Repository（X）  
- Repository + Client（X）  
- Client + API（X）

**每個 Layer 的模組必須獨立存在，不能藉由收斂破壞三層結構。**

---

## 1.2 以 Domain 邊界為主，而不是 API endpoint

錯誤做法：

- 一支 API 生一個 Repository 模組  
- 一支 API 生一個 Client 模組  
- 一支 API endpoint 生一個 UseCase

正確做法：

**以「資源（Resource） + 行為族群」收斂模組。**

例：

- `PrematchComment` 是一個資源  
- `Read / Write Comment` 是一組行為族群  
- `top / newest` 只是 mode，不應拆成多個模組

---

## 1.3 技術型態相同、職責類似 → 優先收斂

例如：

- 多個「讀取 Comment」的 Repository → 合併成 `CommentQueryRepository`
- 多個「寫入 Comment」的 Repository → 合併成 `CommentCommandRepository`

但仍需保持 Single Responsibility。

---

## 1.4 收斂後不得變成「包山包海」

模組可以整併，但：

- 不可混入過多不相關的行為  
- 不可跨 Domain  
- 不得讓邏輯變成不易測試、不易維護的大雜燴

---

# 2. Bounded Context / Domain 維度收斂

## 2.1 同一資源、同一 bounded context → 優先收斂

若模組都操作同一資源（例如 Comment），且：

- URL 前綴一致
- Domain 規則一致
- 回傳資料結構一致

則應收斂：

例：

PrematchCommentMetaRepository
PrematchCommentListRepository


→ **PrematchCommentRepository**

提供：

- `getMeta()`
- `getComments(mode: top|newest)`
- `getReplies(cursor)`
  
---

## 2.2 跨 bounded context 禁止硬收斂

以下視為不同 Domain，不可合併：

- Auth  
- User  
- Profile  
- Payment  
- Chat  
- Comment  
- Blacklist  
- Nickname

即使都是 HTTP GET/POST，也不可合併。

---

# 3. Repository 收斂規則

Repository 是 Domain 資料來源的抽象，是最應進行收斂的 Layer。

---

## 3.1 建議讀寫分離，但可視情況合併

推薦：

- `XxxQueryRepository`（讀）
- `XxxCommandRepository`（寫）

若讀寫量都很小，可收斂為：

- `XxxRepository`

---

## 3.2 避免「每支 API 一個 Repository」

錯誤：

- `GetTopCommentsRepository`
- `GetNewestCommentsRepository`
- `GetRepliesRepository`

正確：

- `CommentQueryRepository.getComments(mode)`
- `CommentQueryRepository.getReplies(cursor)`

---

## 3.3 本地狀態型 Repository 可整併

如：

- `AuthStateRepository`
- `NicknameStateRepository`

→ 可收斂為 `UserSessionStateRepository`。

---

## 3.4 Repository 不可混入跨技術關注點

禁止：

- HTTP + WebSocket 混在同一 Repository

正確拆法：

- `ChatRepository`（HTTP）
- `ChatStreamRepository`（WebSocket）

---

# 4. Client 收斂規則

## 4.1 HTTP Client 依資源收斂

數個針對同一資源的 endpoint → 一個 Client。

例如：

PrematchCommentMetaClient
PrematchCommentListClient
PrematchCommentRepliesClient


→ 可收斂為：

- `PrematchCommentClient`  
或分為：
- `PrematchCommentQueryClient`
- `PrematchCommentCommandClient`

---

## 4.2 WebSocket Client 必須獨立

WebSocket 有 subscribe、unsubscribe、重連、心跳等行為，因此：

- 必須獨立於 HTTP Client
- 命名：`XxxWebSocketClient`

---

## 4.3 Local Storage / Cache Client 可集中

若只是封裝資料存取：

- `LocalStorageClient`
- `LocalUserSessionStateClient`

---

# 5. API 模組收斂規則

API 模組代表「後端 endpoint 定義」，只被 Client 使用。

---

## 5.1 同一 URL 前綴 + 同一資源 → 收斂

例：

GET /chat/match/comment/info/{refId}
GET /chat/match/comment/popular
GET /chat/match/comment/newest


→ `PrematchCommentAPI`

---

## 5.2 不需因 HTTP Method 拆模組

以下錯誤：

- `PrematchCommentGetAPI`
- `PrematchCommentPostAPI`

正確：

- `PrematchCommentAPI`（含多種 method）

---

## 5.3 技術差異明顯的 API 必須拆開

- HTTP → `ChatAPI`
- WebSocket → `ChatWebSocketAPI`

---

# 6. Feature 模組收斂規則（Domain Layer 的一部分）

**Feature 模組是 Feature Layer，不是 UseCase。**  
兩者不能合併。

---

## 6.1 以「使用者目標」切 Feature

例：

- `PrematchCommentFeature`
- `LiveChatFeature`

錯誤：

- `TapLikeButtonFeature`
- `ChangeTabFeature`

---

## 6.2 共享流程應抽成 Shared Feature

如：

- `AuthFeature`
- `NicknameFeature`
- `ProfileFeature`

這些不能塞回每個主 Feature 中。

---

## 6.3 避免 1 Feature = 1 UseCase

若 Feature 與 UseCase 幾乎同步：

→ Feature 拆太細，應收斂。

---

# 7. Domain Module 收斂規則

## 7.1 Domain Entity 以業務語意切分

不要因 API schema 不同就做出多種 Entity。

正確：

- 單一 `Comment` entity
- 或 `Comment` + `CommentThread`

---

## 7.2 Value Object 可集中

如：

- `Cursor`
- `PagingInfo`
- `SortOption`

可集中在 `SharedValueObjects`。

---

# 8. 不應收斂的情況（Hard No）

禁止：

- 跨 Layer 收斂  
- 跨 bounded context 收斂  
- 技術性質差異太大  
- Side-effect 差異巨大  
- 只是為了減少 module 數量硬合併  

---

# 9. 收斂判斷信號（Heuristics）

當發現：

- 名稱只差 `Top` / `Newest` / `Init` / `Refresh`  
- 操作同一 URL 前綴  
- 操作同一資源 ID（refId, matchId）  
- Domain 行為一致（例如都是「載入留言列表」）

→ 應啟動收斂策略：

- 合併 Repository / Client / API  
- 改用 Input / method 區分模式，如：
  - `mode: top|newest`
  - `triggerType: init|refresh|tab`

---

