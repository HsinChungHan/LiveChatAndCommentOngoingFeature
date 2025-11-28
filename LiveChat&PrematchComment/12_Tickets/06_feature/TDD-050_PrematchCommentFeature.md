# TDD-050: PrematchCommentFeature

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-050 |
| **Jira Key** | FOOTBALL-9198 |
| **標題** | 實作 PrematchCommentFeature（TCA Reducer） |
| **類型** | Feature |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | TDD-040, TDD-041, TDD-042, TDD-043, TDD-044 |
| **Story Point** | 8 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：3 天<br/>最嚴厲：2 天 |
| **開發日期 / Development Date** | 2025-12-16 (週二)

## 描述 / Description

實作 PrematchCommentFeature（TCA Reducer）。 / Implement PrematchCommentFeature(TCA Reducer)。

## 需求 / Requirements

1. 定義 `PrematchCommentFeature`（使用 TCA `@Reducer`） / Define `PrematchCommentFeature` (using TCA `@Reducer`)
2. 定義 `State`（使用 `@ObservableState`） / Define `State` (using `@ObservableState`)
3. 定義 `Action`（使用 `@CasePathable` enum） / Define `Action` (using `@CasePathable` enum)
4. 實作 Reducer 邏輯（使用 `Reduce`） / Implement Reducer Logic (using `Reduce`)
5. 整合所有 UseCase 呼叫 / Integrate all UseCase calls
6. 實作 State 更新邏輯 / Implement State update logic
7. 實作 Event Status 通知處理 / Implement Event Status notification handling
8. 檔案結構：`Sources/PrematchComment/Features/PrematchComment/PrematchCommentFeature.swift` / File structure: `Sources/PrematchComment/Features/PrematchComment/PrematchCommentFeature.swift`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/PrematchComment/Features/PrematchComment/
  └── PrematchCommentFeature.swift
```

### 程式碼範例 / Code Example

```swift
import ComposableArchitecture
import Foundation

extension PrematchComment {
    @Reducer
    struct PrematchCommentFeature {
        @Dependency(\.prematchCommentRepository) var prematchCommentRepository
        @Dependency(\.reloadCommentListUseCase) var reloadCommentListUseCase
        @Dependency(\.publishCommentUseCase) var publishCommentUseCase
        @Dependency(\.toggleLikeUseCase) var toggleLikeUseCase
        @Dependency(\.loadRepliesUseCase) var loadRepliesUseCase
        @Dependency(\.navigateToProfileUseCase) var navigateToProfileUseCase
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .loadCommentList:
                    return loadCommentList(state: &state)
                    
                case .publishComment(let content):
                    return publishComment(content: content, state: &state)
                    
                case .toggleLike(let commentId):
                    return toggleLike(commentId: commentId, state: &state)
                    
                case .loadReplies(let commentId):
                    return loadReplies(commentId: commentId, state: &state)
                    
                case .navigateToProfile(let userId):
                    return navigateToProfile(userId: userId)
                    
                // MARK: - Sub-feature Actions
                case .commentList, .commentMeta:
                    return .none
                }
            }
        }
        
        private func loadCommentList(state: inout State) -> Effect<Action> {
            state.isLoading = true
            return .run { [refId = state.refId, mode = state.sortMode] send in
                do {
                    let (comments, pagingInfo) = try await reloadCommentListUseCase.execute(
                        refId: refId,
                        mode: mode
                    )
                    await send(.commentList(.loaded(comments, pagingInfo)))
                } catch {
                    await send(.commentList(.loadFailed(error.localizedDescription)))
                }
            }
        }
        
        // 其他方法...
    }
}

extension PrematchComment.PrematchCommentFeature {
    @ObservableState
    struct State: Equatable {
        var refId: String
        var sortMode: PrematchComment.SortMode
        var isLoading = false
        var errorMessage: String?
        
        var commentMeta: CommentMetaFeature.State
        var commentList: CommentListFeature.State
    }
    
    @CasePathable
    enum Action: Equatable {
        case loadCommentList
        case publishComment(String)
        case toggleLike(String)
        case loadReplies(String)
        case navigateToProfile(String)
        
        // MARK: - Sub-feature Actions
        case commentMeta(CommentMetaFeature.Action)
        case commentList(CommentListFeature.Action)
    }
}
```

### 命名規範 / Naming Conventions

- Feature 使用 `@Reducer` macro，放在 `PrematchComment` namespace extension 內 / Feature uses `@Reducer` macro, placed within `PrematchComment` namespace extension
- State 使用 `@ObservableState` struct / State uses `@ObservableState` struct
- Action 使用 `@CasePathable` enum / Action uses `@CasePathable` enum
- 使用 `@Dependency` 注入依賴 / Use `@Dependency` to inject dependencies
- 使用 `Reduce` 實作 reducer 邏輯 / Use `Reduce` to implement reducer logic
- 使用 `Effect` 處理異步操作 / Use `Effect` to handle async operations
- 使用 MARK 註解組織代碼 / Use MARK comments to organize code

## 驗收條件 / Acceptance Criteria

- [ ] `PrematchCommentFeature` 定義完成，使用 `@Reducer` / `PrematchCommentFeature` definition complete, using `@Reducer`
- [ ] `State` 定義完成，使用 `@ObservableState` / `State` definition complete, using `@ObservableState`
- [ ] `Action` 定義完成，使用 `@CasePathable` / `Action` definition complete, using `@CasePathable`
- [ ] Reducer 邏輯實作完成，使用 `Reduce` / Reducer logic implementation complete, using `Reduce`
- [ ] 所有 Action → UseCase 映射完成 / All Action → UseCase mapping complete
- [ ] 使用 `@Dependency` 注入依賴 / Use `@Dependency` to inject dependencies
- [ ] Event Status 通知處理實作完成 / Event Status notification handling implementation complete
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%

## 相關文件 / Related Documents

- Feature State & Action：`output/LiveChat&PrematchComment/06_Feature State & Action (TCA)/01_feature_state_action.md`
- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`

## 調整因子說明 / 調整因子說明

- 基礎估時：中等 Feature = 3 SP
- +2 SP：需要處理複雜的狀態同步（Event Status 通知） / - +2 SP：需要處理複雜的State同步(Event Status 通知)
- +2 SP：需要處理多種 UI 狀態（Loading、Error、Success） / - +2 SP：需要處理多種 UI State(Loading, Error, Success)
- +1 SP：整合多個 UseCase（5 個） / - +1 SP：整合多個 UseCase(5 個)

