# TDD-044: NavigateToProfileUseCase

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-044 |
| **標題** | 實作 NavigateToProfileUseCase |
| **類型** | UseCase |
| **優先級** | P1 |
| **所屬 Feature** | LiveChat & PrematchComment |
| **依賴 Ticket** | - |
| **Story Point** | 2 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：1 天<br/>最嚴厲：1 天 |
| **開發日期 / Development Date** | 2025-12-11 (週四)

## 描述 / Description

實作 NavigateToProfileUseCase。 / Implement NavigateToProfileUseCase。

## 需求 / Requirements

1. 實作 `NavigateToProfileUseCase` struct / Implement `NavigateToProfileUseCase` struct
2. 定義 Input/Output Model / Define Input/Output Model
3. 整合 `PersonalPageAdapter` Protocol 執行路由跳轉 / Integrate `PersonalPageAdapter` Protocol to execute route navigation
4. 實作 Error Handling / Implement Error Handling
5. 檔案結構：`Sources/Shared/UseCases/NavigateToProfileUseCase.swift` / File structure: `Sources/Shared/UseCases/NavigateToProfileUseCase.swift`

## 實作規範 / Implementation Guidelines

### 程式碼範例 / Code Example

```swift
import Foundation

public struct NavigateToProfileUseCase {
    private let personalPageAdapter: PersonalPageAdapter
    
    public init(personalPageAdapter: PersonalPageAdapter) {
        self.personalPageAdapter = personalPageAdapter
    }
    
    public struct Input: Equatable, Sendable {
        public let userId: String
        
        public init(userId: String) {
            self.userId = userId
        }
    }
    
    public struct Output: Equatable, Sendable {
        public init() {}
    }
    
    public func execute(input: Input) async throws -> Output {
        try await personalPageAdapter.navigateToProfile(userId: input.userId)
        return Output()
    }
}
```

### 命名規範 / Naming Conventions

- UseCase 使用 `struct`，提供 `execute(input:)` 方法 / UseCase uses `struct`, provides `execute(input:)` method
- Input/Output 使用 nested `struct`，實作 `Equatable`、`Sendable` / Input/Output use nested `struct`, implement `Equatable`, `Sendable`
- 使用 `public` 修飾符 / Use `public` modifier

## 驗收條件 / Acceptance Criteria

- [ ] `NavigateToProfileUseCase` 實作完成 / `NavigateToProfileUseCase` implementation complete
- [ ] Input/Output Model 定義完成 / Input/Output Model definition complete
- [ ] 路由跳轉邏輯實作完成 / Route navigation logic implementation complete
- [ ] UseCase 商業邏輯實作完成 / UseCase business logic implementation complete
- [ ] 所有 Test Scenarios 通過（Basic / Error） / All Test Scenarios passed (Basic / Error)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 90% / Unit Test Coverage ≥ 90%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- UseCase 定義：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Input/Output Model：`output/LiveChat&PrematchComment/07_UseCase Input & Output Model/01_usecase_input_output.md`
- Test Scenarios：`output/LiveChat&PrematchComment/10_Test Scenarios/01_test_scenarios.md`

