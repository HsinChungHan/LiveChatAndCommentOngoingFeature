# TDD-051: LiveChatFeature

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-051 |
| **標題** | 實作 LiveChatFeature（TCA Reducer） |
| **類型** | Feature |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-045, TDD-046, TDD-047, TDD-048, TDD-044 |
| **Story Point** | 13 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：5 天<br/>最嚴厲：4 天 |
| **開發日期 / Development Date** | 2025-12-16 (週二)

## 描述 / Description

實作 LiveChatFeature（TCA Reducer）。 / Implement LiveChatFeature(TCA Reducer)。

## 需求 / Requirements

1. 定義 `LiveChatFeature`（使用 TCA `@Reducer`） / Define `LiveChatFeature` (using TCA `@Reducer`)
2. 定義 `State`（使用 `@ObservableState`） / Define `State` (using `@ObservableState`)
3. 定義 `Action`（使用 `@CasePathable` enum） / Define `Action` (using `@CasePathable` enum)
4. 實作 Reducer 邏輯（使用 `Reduce`） / Implement Reducer Logic (using `Reduce`)
5. 整合所有 UseCase 呼叫 / Integrate all UseCase calls
6. 實作 WebSocket 連線狀態管理 / Implement WebSocket connection state management
7. 實作 WebSocket 訊息處理 / Implement WebSocket message handling
8. 檔案結構：`Sources/LiveChat/Features/LiveChat/LiveChatFeature.swift` / File structure: `Sources/LiveChat/Features/LiveChat/LiveChatFeature.swift`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/LiveChat/Features/LiveChat/
  └── LiveChatFeature.swift
```

### 程式碼範例 / Code Example

```swift
import ComposableArchitecture
import Foundation

extension LiveChat {
    @Reducer
    struct LiveChatFeature {
        @Dependency(\.liveChatRepository) var liveChatRepository
        @Dependency(\.sendChatMessageUseCase) var sendChatMessageUseCase
        @Dependency(\.joinChatroomUseCase) var joinChatroomUseCase
        @Dependency(\.leaveChatroomUseCase) var leaveChatroomUseCase
        @Dependency(\.blockUserUseCase) var blockUserUseCase
        @Dependency(\.navigateToProfileUseCase) var navigateToProfileUseCase
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .joinChatroom:
                    return joinChatroom(state: &state)
                    
                case .sendMessage(let content):
                    return sendMessage(content: content, state: &state)
                    
                case .leaveChatroom:
                    return leaveChatroom(state: &state)
                    
                case .blockUser(let userId):
                    return blockUser(userId: userId, state: &state)
                    
                case .webSocketConnected:
                    state.webSocketStatus = .connected
                    return .none
                    
                case .webSocketDisconnected:
                    state.webSocketStatus = .disconnected
                    return .none
                    
                case .webSocketMessageReceived(let message):
                    return handleWebSocketMessage(message: message, state: &state)
                    
                // MARK: - Sub-feature Actions
                case .messageList, .chatroomInfo:
                    return .none
                }
            }
        }
        
        private func joinChatroom(state: inout State) -> Effect<Action> {
            state.isLoading = true
            return .run { [refId = state.refId] send in
                do {
                    let chatroomInfo = try await joinChatroomUseCase.execute(
                        input: .init(refId: refId)
                    )
                    await send(.chatroomInfo(.loaded(chatroomInfo)))
                } catch {
                    await send(.chatroomInfo(.loadFailed(error.localizedDescription)))
                }
            }
        }
        
        // 其他方法...
    }
}

extension LiveChat.LiveChatFeature {
    @ObservableState
    struct State: Equatable {
        var refId: String
        var isLoading = false
        var errorMessage: String?
        var webSocketStatus: WebSocketStatus = .disconnected
        
        enum WebSocketStatus: Equatable {
            case disconnected
            case connecting
            case connected
        }
        
        var chatroomInfo: ChatroomInfoFeature.State
        var messageList: MessageListFeature.State
    }
    
    @CasePathable
    enum Action: Equatable {
        case joinChatroom
        case sendMessage(String)
        case leaveChatroom
        case blockUser(String)
        case navigateToProfile(String)
        
        // MARK: - WebSocket Actions
        case webSocketConnected
        case webSocketDisconnected
        case webSocketMessageReceived(LiveChat.Message)
        
        // MARK: - Sub-feature Actions
        case chatroomInfo(ChatroomInfoFeature.Action)
        case messageList(MessageListFeature.Action)
    }
}
```

### 命名規範 / Naming Conventions

- Feature 使用 `@Reducer` macro，放在 `LiveChat` namespace extension 內 / Feature uses `@Reducer` macro, placed within `LiveChat` namespace extension
- State 使用 `@ObservableState` struct / State uses `@ObservableState` struct
- Action 使用 `@CasePathable` enum / Action uses `@CasePathable` enum
- 使用 `@Dependency` 注入依賴 / Use `@Dependency` to inject dependencies
- 使用 `Reduce` 實作 reducer 邏輯 / Use `Reduce` to implement reducer logic
- 使用 `Effect` 處理異步操作 / Use `Effect` to handle async operations

## 驗收條件 / Acceptance Criteria

- [ ] `LiveChatFeature` 定義完成，使用 `@Reducer` / `LiveChatFeature` definition complete, using `@Reducer`
- [ ] `State` 定義完成，使用 `@ObservableState` / `State` definition complete, using `@ObservableState`
- [ ] `Action` 定義完成，使用 `@CasePathable` / `Action` definition complete, using `@CasePathable`
- [ ] Reducer 邏輯實作完成，使用 `Reduce` / Reducer logic implementation complete, using `Reduce`
- [ ] 所有 Action → UseCase 映射完成 / All Action → UseCase mapping complete
- [ ] WebSocket 連線狀態管理實作完成 / WebSocket connection state management implementation complete
- [ ] WebSocket 訊息處理實作完成 / WebSocket message handling implementation complete
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%

## 相關文件 / Related Documents

- Feature State & Action：`output/LiveChat&PrematchComment/06_Feature State & Action (TCA)/01_feature_state_action.md`
- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`

## 調整因子說明 / 調整因子說明

- 基礎估時：複雜 Feature = 8 SP
- +2 SP：需要處理複雜的狀態同步（WebSocket 連線狀態、訊息同步） / - +2 SP：需要處理複雜的State同步(WebSocket 連線State, 訊息同步)
- +2 SP：需要處理多種 UI 狀態（Loading、Error、Success、WebSocket 狀態） / - +2 SP：需要處理多種 UI State(Loading, Error, Success, WebSocket State)
- +1 SP：整合多個 UseCase（5 個） / - +1 SP：整合多個 UseCase(5 個)

