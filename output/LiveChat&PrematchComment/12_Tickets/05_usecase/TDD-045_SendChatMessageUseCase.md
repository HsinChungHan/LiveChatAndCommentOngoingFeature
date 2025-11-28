# TDD-045: SendChatMessageUseCase

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-045 |
| **標題** | 實作 SendChatMessageUseCase |
| **類型** | UseCase |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-031 |
| **Story Point** | 13 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：5 天<br/>最嚴厲：4 天 |
| **開發日期 / Development Date** | 2025-12-11 (週四)

## 描述 / Description

實作 SendChatMessageUseCase。 / Implement SendChatMessageUseCase。

## 需求 / Requirements

1. 實作 `SendChatMessageUseCase` struct / Implement `SendChatMessageUseCase` struct
2. 定義 Input/Output Model / Define Input/Output Model
3. 整合 `LiveChatRepository` 呼叫 / Integrate `LiveChatRepository` call
4. 整合 `PersonalPageAdapter` Protocol（登入檢查） / Integrate `PersonalPageAdapter` Protocol (login check)
5. 整合 `FComSharedFlowAdapter` Protocol（nickname 建立） / Integrate `FComSharedFlowAdapter` Protocol (nickname creation)
6. 實作 Error Handling / Implement Error Handling
7. 檔案結構：`Sources/LiveChat/UseCases/SendChatMessageUseCase.swift` / File structure: `Sources/LiveChat/UseCases/SendChatMessageUseCase.swift`

## 實作規範 / Implementation Guidelines

### 程式碼範例 / Code Example

```swift
import Foundation

public struct SendChatMessageUseCase {
    private let repository: LiveChatRepository
    private let personalPageAdapter: PersonalPageAdapter
    private let fComSharedFlowAdapter: FComSharedFlowAdapter
    
    public init(
        repository: LiveChatRepository,
        personalPageAdapter: PersonalPageAdapter,
        fComSharedFlowAdapter: FComSharedFlowAdapter
    ) {
        self.repository = repository
        self.personalPageAdapter = personalPageAdapter
        self.fComSharedFlowAdapter = fComSharedFlowAdapter
    }
    
    public struct Input: Equatable, Sendable {
        public let chatroomId: String
        public let content: String
        public let messageType: LiveChat.MessageType
        
        public init(
            chatroomId: String,
            content: String,
            messageType: LiveChat.MessageType
        ) {
            self.chatroomId = chatroomId
            self.content = content
            self.messageType = messageType
        }
    }
    
    public struct Output: Equatable, Sendable {
        public let message: LiveChat.Message
        
        public init(message: LiveChat.Message) {
            self.message = message
        }
    }
    
    public func execute(input: Input) async throws -> Output {
        // 登入檢查
        guard personalPageAdapter.isLoggedIn else {
            throw SendChatMessageError.notLoggedIn
        }
        
        // Nickname 檢查和建立
        if !personalPageAdapter.hasNickname {
            try await fComSharedFlowAdapter.createNickname()
        }
        
        // 發送訊息
        let message = try await repository.sendMessage(
            chatroomId: input.chatroomId,
            content: input.content,
            messageType: input.messageType
        )
        
        return Output(message: message)
    }
}
```

### 命名規範 / Naming Conventions

- UseCase 使用 `struct`，提供 `execute(input:)` 方法 / UseCase uses `struct`, provides `execute(input:)` method
- Input/Output 使用 nested `struct`，實作 `Equatable`、`Sendable` / Input/Output use nested `struct`, implement `Equatable`, `Sendable`
- 使用 `LiveChat.XXX` 命名空間 / Use `LiveChat.XXX` namespace
- 使用 `public` 修飾符 / Use `public` modifier

## 驗收條件 / Acceptance Criteria

- [ ] `SendChatMessageUseCase` 實作完成 / `SendChatMessageUseCase` implementation complete
- [ ] Input/Output Model 定義完成 / Input/Output Model definition complete
- [ ] 登入檢查邏輯實作完成 / Login check logic implementation complete
- [ ] Nickname 檢查和建立邏輯實作完成 / Nickname check and creation logic implementation complete
- [ ] UseCase 商業邏輯實作完成 / UseCase business logic implementation complete
- [ ] 所有 Test Scenarios 通過（Basic / Branch） / All Test Scenarios passed (Basic / Branch)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 90% / Unit Test Coverage ≥ 90%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- UseCase 定義：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Input/Output Model：`output/LiveChat&PrematchComment/07_UseCase Input & Output Model/01_usecase_input_output.md`
- Test Scenarios：`output/LiveChat&PrematchComment/10_Test Scenarios/01_test_scenarios.md`

## 調整因子說明 / 調整因子說明

- 基礎估時：中等 UseCase = 5 SP
- +3 SP：需要整合多個 Shared Feature（PersonalPageAdapter、FComSharedFlowAdapter） / - +3 SP：需要整合多個 Shared Feature(PersonalPageAdapter, FComSharedFlowAdapter)
- +2 SP：複雜的驗證邏輯（登入檢查、nickname 檢查） / - +2 SP：複雜的ValidationLogic(登入檢查, nickname 檢查)
- +2 SP：複雜的商業邏輯 / - +2 SP：複雜的商業Logic
- +1 SP：需要處理多種 Error 情況

