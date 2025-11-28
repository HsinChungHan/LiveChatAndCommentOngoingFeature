# TDD-060: PrematchCommentView

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-060 |
| **標題** | 實作 PrematchCommentView |
| **類型** | View |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | TDD-050 |
| **Story Point** | 13 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：5 天<br/>最嚴厲：4 天 |
| **開發日期 / Development Date** | 2025-12-17 (週三)

## 描述 / Description

實作 PrematchCommentView。 / Implement PrematchCommentView。

## 需求 / Requirements

1. 實作 `PrematchCommentView`（SwiftUI） / Implement `PrematchCommentView` (SwiftUI)
2. 整合 `PrematchCommentFeature`（使用 TCA `Store`） / Integrate `PrematchCommentFeature` (using TCA `Store`)
3. 實作 UI 狀態綁定（使用 `@Bindable`） / Implement UI state binding (using `@Bindable`)
4. 實作使用者互動處理 / Implement user interaction handling
5. 實作 Loading/Error 狀態顯示 / Implement Loading/Error state display
6. 實作留言列表顯示（支援 top/newest 切換） / Implement comment list display (support top/newest switching)
7. 實作回覆列表顯示（支援展開/收起） / Implement reply list display (support expand/collapse)
8. 實作分頁載入更多 / Implement pagination load more
9. 檔案結構：`Sources/PrematchComment/Views/PrematchComment/PrematchCommentView.swift` / File structure: `Sources/PrematchComment/Views/PrematchComment/PrematchCommentView.swift`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/PrematchComment/Views/PrematchComment/
  ├── PrematchCommentView.swift
  ├── PrematchCommentView+ViewBuilders.swift  # View builders
  └── PrematchCommentContentView.swift        # Content view
```

### 程式碼範例 / Code Example

```swift
import ComposableArchitecture
import SwiftUI

public struct PrematchCommentView: View {
    @Bindable var store: StoreOf<PrematchComment.PrematchCommentFeature>
    
    public init(store: StoreOf<PrematchComment.PrematchCommentFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            if store.isLoading {
                ProgressView()
            } else if let errorMessage = store.errorMessage {
                ErrorView(message: errorMessage)
            } else {
                CommentListView(store: store)
            }
        }
        .onAppear {
            store.send(.loadCommentList)
        }
    }
}

// MARK: - View Builders

extension PrematchCommentView {
    @ViewBuilder
    private func CommentListView(store: StoreOf<PrematchComment.PrematchCommentFeature>) -> some View {
        VStack {
            SortModePicker(store: store)
            CommentList(store: store)
        }
    }
    
    @ViewBuilder
    private func SortModePicker(store: StoreOf<PrematchComment.PrematchCommentFeature>) -> some View {
        Picker("Sort Mode", selection: Binding(
            get: { store.sortMode },
            set: { store.send(.setSortMode($0)) }
        )) {
            Text("Top").tag(PrematchComment.SortMode.top)
            Text("Newest").tag(PrematchComment.SortMode.newest)
        }
        .pickerStyle(.segmented)
    }
}
```

### 命名規範 / Naming Conventions

- View 使用 `struct`，實作 `View` protocol / View uses `struct`, implements `View` protocol
- 使用 `@Bindable` 綁定 Store / Use `@Bindable` to bind Store
- 使用 `StoreOf<Feature>` 類型 / Use `StoreOf<Feature>` type
- 使用 `@ViewBuilder` 組織 View 結構 / Use `@ViewBuilder` to organize View structure
- 使用 extension 分離 View builders / Use extension to separate View builders
- 使用 MARK 註解組織代碼 / Use MARK comments to organize code

## 驗收條件 / Acceptance Criteria

- [ ] `PrematchCommentView` 實作完成 / `PrematchCommentView` implementation complete
- [ ] Feature 整合完成，使用 TCA `Store` / Feature integration complete, using TCA `Store`
- [ ] UI 狀態綁定實作完成，使用 `@Bindable` / UI state binding implementation complete, using `@Bindable`
- [ ] 所有使用者互動流程測試通過 / All user interaction flow tests passed
- [ ] Loading/Error 狀態顯示正確 / Loading/Error state display correct
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] UI Test 覆蓋率 ≥ 70% / UI Test Coverage ≥ 70%

## 相關文件 / Related Documents

- Module Sequence Diagram：`output/LiveChat&PrematchComment/05. Module Sequence Diagram（模組序列圖）/PrematchComment/Module Sequence Diagrams/` / - Module Sequence Diagram：`output/LiveChat&PrematchComment/05. Module Sequence Diagram(模組序列圖)/PrematchComment/Module Sequence Diagrams/`

## 調整因子說明 / 調整因子說明

- 基礎估時：複雜 View = 13 SP
- +2 SP：複雜的列表 UI（留言列表、回覆列表） / - +2 SP：複雜的列表 UI(留言列表, 回覆列表)
- +2 SP：需要處理多種 Loading/Error 狀態 / - +2 SP：需要處理多種 Loading/Error State

