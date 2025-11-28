# TDD-061: LiveDetailView

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-061 |
| **Jira Key** | FOOTBALL-9202 |
| **標題** | 實作 LiveDetailView |
| **類型** | View |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-051 |
| **Story Point** | 13 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：5 天<br/>最嚴厲：4 天 |
| **開發日期 / Development Date** | 2025-12-19 (週五)

## 描述 / Description

實作 LiveDetailView。 / Implement LiveDetailView。

## 需求 / Requirements

1. 實作 `LiveDetailView`（SwiftUI） / Implement `LiveDetailView` (SwiftUI)
2. 整合 `LiveChatFeature`（使用 TCA `Store`） / Integrate `LiveChatFeature` (using TCA `Store`)
3. 實作 UI 狀態綁定（使用 `@Bindable`） / Implement UI state binding (using `@Bindable`)
4. 實作使用者互動處理 / Implement user interaction handling
5. 實作 Loading/Error 狀態顯示 / Implement Loading/Error state display
6. 實作聊天室訊息列表顯示 / Implement chatroom message list display
7. 實作即時訊息接收和顯示（WebSocket） / Implement real-time message receive and display (WebSocket)
8. 實作歷史訊息載入（滾動到頂部） / Implement historical message loading (scroll to top)
9. 實作用戶操作選單（封鎖、跳轉個人主頁） / Implement user action menu (block, navigate to profile)
10. 檔案結構：`Sources/LiveChat/Views/LiveChat/LiveDetailView.swift` / File structure: `Sources/LiveChat/Views/LiveChat/LiveDetailView.swift`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/LiveChat/Views/LiveChat/
  ├── LiveDetailView.swift
  ├── LiveDetailView+ViewBuilders.swift  # View builders
  └── MessageListView.swift             # Message list view
```

### 程式碼範例 / Code Example

```swift
import ComposableArchitecture
import SwiftUI

public struct LiveDetailView: View {
    @Bindable var store: StoreOf<LiveChat.LiveChatFeature>
    
    public init(store: StoreOf<LiveChat.LiveChatFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            if store.isLoading {
                ProgressView()
            } else if let errorMessage = store.errorMessage {
                ErrorView(message: errorMessage)
            } else {
                MessageListView(store: store)
            }
        }
        .onAppear {
            store.send(.joinChatroom)
        }
        .onChange(of: store.webSocketStatus) { oldValue, newValue in
            if newValue == .connected {
                store.send(.subscribeWebSocket)
            }
        }
    }
}

// MARK: - View Builders

extension LiveDetailView {
    @ViewBuilder
    private func MessageListView(store: StoreOf<LiveChat.LiveChatFeature>) -> some View {
        ScrollViewReader { proxy in
            List(store.messageList.messages) { message in
                MessageRow(message: message)
                    .onTapGesture {
                        store.send(.showUserActionMenu(message.authorId))
                    }
            }
            .onChange(of: store.messageList.messages.count) { oldValue, newValue in
                if let lastMessage = store.messageList.messages.last {
                    withAnimation {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }
}
```

### 命名規範 / Naming Conventions

- View 使用 `struct`，實作 `View` protocol / View uses `struct`, implements `View` protocol
- 使用 `@Bindable` 綁定 Store / Use `@Bindable` to bind Store
- 使用 `StoreOf<Feature>` 類型 / Use `StoreOf<Feature>` type
- 使用 `@ViewBuilder` 組織 View 結構 / Use `@ViewBuilder` to organize View structure
- 使用 extension 分離 View builders / Use extension to separate View builders

## 驗收條件 / Acceptance Criteria

- [ ] `LiveDetailView` 實作完成 / `LiveDetailView` implementation complete
- [ ] Feature 整合完成，使用 TCA `Store` / Feature integration complete, using TCA `Store`
- [ ] UI 狀態綁定實作完成，使用 `@Bindable` / UI state binding implementation complete, using `@Bindable`
- [ ] 所有使用者互動流程測試通過 / All user interaction flow tests passed
- [ ] WebSocket 訊息即時顯示正確 / WebSocket message real-time display correct
- [ ] Loading/Error 狀態顯示正確 / Loading/Error state display correct
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] UI Test 覆蓋率 ≥ 70% / UI Test Coverage ≥ 70%

## 相關文件 / Related Documents

- Module Sequence Diagram：`output/LiveChat&PrematchComment/05. Module Sequence Diagram（模組序列圖）/LiveChat/Module Sequence Diagrams/` / - Module Sequence Diagram：`output/LiveChat&PrematchComment/05. Module Sequence Diagram(模組序列圖)/LiveChat/Module Sequence Diagrams/`

## 調整因子說明 / 調整因子說明

- 基礎估時：複雜 View = 13 SP
- +2 SP：複雜的列表 UI（聊天訊息列表） / - +2 SP：複雜的列表 UI(聊天訊息列表)
- +2 SP：需要處理多種 Loading/Error 狀態 / - +2 SP：需要處理多種 Loading/Error State
- +1 SP：WebSocket 即時訊息處理

