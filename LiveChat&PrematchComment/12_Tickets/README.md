# Tickets

本目錄包含所有開發 Ticket 和估時資訊。

## 文件列表

### 開發計劃
- `20_工作日開發計劃.md`：單一 Senior iOS Engineer + AI 輔助，20 個工作日完成計劃

### Jira 整合
Jira 整合相關的腳本、資料庫和文檔已移至專案根目錄的 `jira_integration/` 資料夾。

### Domain Model
- `01_domain_model/TDD-001_Comment_Entity.md`
- `01_domain_model/TDD-002_CommentMeta_Entity.md`
- `01_domain_model/TDD-003_UserInfo_Entity.md`
- `01_domain_model/TDD-004_Message_Entity.md`
- `01_domain_model/TDD-005_ChatroomInfo_Entity.md`
- `01_domain_model/TDD-006_ValueObjects.md`

### API
- `02_api/TDD-010_PrematchCommentAPI.md`
- `02_api/TDD-011_ChatAPI.md`

### Client
- `03_client/TDD-020_PrematchCommentClient.md`
- `03_client/TDD-021_LiveChatClient.md`
- `03_client/TDD-022_ChatWebSocketClient.md`

### Repository
- `04_repository/TDD-030_PrematchCommentRepository.md`
- `04_repository/TDD-031_LiveChatRepository.md`

### UseCase
- `05_usecase/TDD-040_ReloadCommentListUseCase.md`
- `05_usecase/TDD-041_PublishCommentUseCase.md`
- `05_usecase/TDD-042_ToggleLikeUseCase.md`
- `05_usecase/TDD-043_LoadRepliesUseCase.md`
- `05_usecase/TDD-044_NavigateToProfileUseCase.md`
- `05_usecase/TDD-045_SendChatMessageUseCase.md`
- `05_usecase/TDD-046_JoinChatroomUseCase.md`
- `05_usecase/TDD-047_LeaveChatroomUseCase.md`
- `05_usecase/TDD-048_BlockUserUseCase.md`

### Feature
- `06_feature/TDD-050_PrematchCommentFeature.md`
- `06_feature/TDD-051_LiveChatFeature.md`

### View
- `07_view/TDD-060_PrematchCommentView.md`
- `07_view/TDD-061_LiveDetailView.md`

## Ticket 開發時間表

本開發計劃從 **2025-11-27** 開始，共 **20 個工作日**，已排除 **2025-12-18（週四）** 請假日。

### 完整時間表

| Ticket ID | 標題 | 開始日期 | 結束日期 | 持續時間（天） |
|-----------|------|----------|----------|--------------|
| TDD-001 | 實作 Comment Entity | 2025-11-27 | 2025-11-28 | 0.3 |
| TDD-002 | 實作 CommentMeta Entity | 2025-11-27 | 2025-11-28 | 0.3 |
| TDD-003 | 實作 UserInfo Entity | 2025-11-27 | 2025-11-28 | 0.3 |
| TDD-004 | 實作 Message Entity | 2025-11-28 | 2025-12-01 | 0.3 |
| TDD-005 | 實作 ChatroomInfo Entity | 2025-11-28 | 2025-12-01 | 0.3 |
| TDD-006 | 實作 Value Objects（SortMode、Cursor、PagingInfo） | 2025-11-28 | 2025-12-01 | 1.0 |
| TDD-010 | 實作 PrematchCommentAPI 定義 | 2025-12-01 | 2025-12-02 | 1.0 |
| TDD-011 | 實作 ChatAPI 定義 | 2025-12-01 | 2025-12-03 | 2.0 |
| TDD-021 | 實作 LiveChatClient（HTTP） | 2025-12-02 | 2025-12-03 | 1.0 |
| TDD-020 | 實作 PrematchCommentClient（HTTP） | 2025-12-02 | 2025-12-04 | 2.0 |
| TDD-030 | 實作 PrematchCommentRepository | 2025-12-04 | 2025-12-08 | 2.0 |
| TDD-022 | 實作 ChatWebSocketClient（WebSocket） | 2025-12-03 | 2025-12-10 | 5.0 |
| TDD-031 | 實作 LiveChatRepository | 2025-12-05 | 2025-12-10 | 3.0 |
| TDD-040 | 實作 ReloadCommentListUseCase | 2025-12-08 | 2025-12-10 | 2.0 |
| TDD-042 | 實作 ToggleLikeUseCase | 2025-12-10 | 2025-12-12 | 2.0 |
| TDD-043 | 實作 LoadRepliesUseCase | 2025-12-10 | 2025-12-12 | 2.0 |
| TDD-044 | 實作 NavigateToProfileUseCase | 2025-12-11 | 2025-12-12 | 1.0 |
| TDD-041 | 實作 PublishCommentUseCase | 2025-12-09 | 2025-12-16 | 5.0 |
| TDD-048 | 實作 BlockUserUseCase | 2025-12-15 | 2025-12-16 | 1.0 |
| TDD-047 | 實作 LeaveChatroomUseCase | 2025-12-15 | 2025-12-17 | 2.0 |
| TDD-045 | 實作 SendChatMessageUseCase | 2025-12-11 | 2025-12-19 | 5.0 |
| TDD-046 | 實作 JoinChatroomUseCase | 2025-12-12 | 2025-12-22 | 5.0 |
| TDD-050 | 實作 PrematchCommentFeature（TCA Reducer） | 2025-12-16 | 2025-12-22 | 3.0 |
| TDD-051 | 實作 LiveChatFeature（TCA Reducer） | 2025-12-16 | 2025-12-24 | 5.0 |
| TDD-060 | 實作 PrematchCommentView | 2025-12-17 | 2025-12-25 | 5.0 |
| TDD-061 | 實作 LiveDetailView | 2025-12-19 | 2025-12-26 | 5.0 |

**詳細時間表**：請參考 `ticket_timeline.md`

---

## Ticket 開發順序

### Phase 1: Domain Model（優先）
1. TDD-001 ~ TDD-006：Domain Model 定義

### Phase 2: Data & Infrastructure Layer
2. TDD-010 ~ TDD-011：API 定義
3. TDD-020 ~ TDD-022：Client 實作
4. TDD-030 ~ TDD-031：Repository 實作

### Phase 3: Domain Layer
5. TDD-040 ~ TDD-048：UseCase 實作
6. TDD-050 ~ TDD-051：Feature 實作

### Phase 4: UI Layer
7. TDD-060 ~ TDD-061：View 實作

## 估時說明

- **Story Point (SP)**：使用 Fibonacci 數列（1, 2, 3, 5, 8, 13, 21）
- **估時基準**：Senior iOS Engineer + AI 輔助開發
- **估時範圍**：
  - **標準估時**：基於 Story Point 轉換，考慮 AI 輔助開發的時間節省
  - **最嚴厲估時**：一切順利，無意外問題（標準估時 × 0.7，四捨五入）

### AI 輔助開發說明

**AI 工具**（如 GitHub Copilot、Cursor、ChatGPT 等）可以顯著提升開發效率，但影響程度因任務類型而異：

| 任務類型 | AI 輔助效果 | 時間節省比例 | 說明 |
|---------|------------|------------|------|
| **Domain Model** | 高 | 30-50% | AI 可快速生成 Entity/Value Object 結構、Equatable、Identifiable 等 boilerplate code |
| **API 定義** | 中高 | 25-40% | AI 可生成 Request/Response DTO、API 端點定義 |
| **Client** | 中 | 20-35% | AI 可生成 HTTP 請求代碼、標準 Error Handling，但 WebSocket 邏輯仍需人工 |
| **Repository** | 中 | 20-35% | AI 可生成 DTO Mapping、標準 CRUD，但複雜資料合併邏輯仍需人工 |
| **UseCase** | 中低 | 15-30% | AI 可生成基本結構，但業務邏輯、驗證邏輯、整合邏輯需要人工設計 |
| **Feature** | 中低 | 15-30% | AI 可生成 TCA Reducer 結構，但狀態管理邏輯、Action 處理需要人工 |
| **View** | 低中 | 10-25% | AI 可生成 UI 結構，但互動邏輯、動畫、狀態綁定需要人工 |

**注意事項**：
- AI 生成的代碼仍需要 Code Review 和調整
- 複雜業務邏輯、架構設計決策仍需人工
- 測試用例仍需人工編寫和驗證
- 調試和問題解決仍需人工
- AI 輔助效果取決於工程師使用 AI 工具的熟練程度
- 所有估時已四捨五入至整數天數

## 依賴關係

Ticket 必須按照依賴順序開發：
- Domain Model → API → Client → Repository → UseCase → Feature → View

## 總估時統計

### 按層級統計（Senior iOS Engineer + AI 輔助）

| 層級 | Ticket 數量 | 總 Story Point | 標準估時 | 最嚴厲估時 |
|------|------------|--------------|---------|-----------|
| **Domain Model** | 6 | 7 SP | 3 天 | 1 天 |
| **API** | 2 | 8 SP | 3 天 | 2 天 |
| **Client** | 3 | 21 SP | 8 天 | 5 天 |
| **Repository** | 2 | 13 SP | 5 天 | 3 天 |
| **UseCase** | 9 | 62 SP | 25 天 | 18 天 |
| **Feature** | 2 | 21 SP | 8 天 | 6 天 |
| **View** | 2 | 26 SP | 10 天 | 8 天 |
| **總計** | **26** | **158 SP** | **62 天** | **43 天** |

### 按 Feature 統計（Senior iOS Engineer + AI 輔助）

| Feature | Ticket 數量 | 總 Story Point | 標準估時 | 最嚴厲估時 |
|---------|------------|--------------|---------|-----------|
| **PrematchComment** | 14 | 75 SP | 29 天 | 20 天 |
| **LiveChat** | 12 | 83 SP | 33 天 | 23 天 |

### 注意事項

1. **估時僅供參考**：實際開發時間可能因工程師經驗、專案複雜度、技術債務等因素而有所不同
2. **需要定期調整**：根據實際開發情況，應定期調整估時規則
3. **考慮並行開發**：某些 Ticket 可以並行開發（如 Domain Model 的 Entity 可以並行）
4. **考慮風險緩衝**：建議在總估時基礎上增加 20-30% 的緩衝時間
5. **總估時（含緩衝 25%）**：
   - **標準估時**：62 天 × 1.25 = **78 天**（約 16 週）
   - **最嚴厲估時**：43 天 × 1.25 = **54 天**（約 11 週）

