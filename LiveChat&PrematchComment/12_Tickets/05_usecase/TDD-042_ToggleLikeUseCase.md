# TDD-042: ToggleLikeUseCase

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-042 |
| **Jira Key** | FOOTBALL-9190 |
| **標題** | 實作 ToggleLikeUseCase |
| **類型** | UseCase |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | TDD-030 |
| **Story Point** | 5 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：2 天<br/>最嚴厲：1 天 |
| **開發日期 / Development Date** | 2025-12-10 (週三)

## 描述 / Description

實作 ToggleLikeUseCase。 / Implement ToggleLikeUseCase。

## 需求 / Requirements

1. 實作 `ToggleLikeUseCase` struct / Implement `ToggleLikeUseCase` struct
2. 定義 Input/Output Model / Define Input/Output Model
3. 整合 `PrematchCommentRepository` 呼叫 / Integrate `PrematchCommentRepository` call
4. 整合 `PersonalPageAdapter` Protocol（登入檢查） / Integrate `PersonalPageAdapter` Protocol (login check)
5. 支援 Optimistic UI 更新 / Support Optimistic UI update
6. 實作 Error Handling / Implement Error Handling
7. 檔案結構：`Sources/PrematchComment/UseCases/ToggleLikeUseCase.swift` / File structure: `Sources/PrematchComment/UseCases/ToggleLikeUseCase.swift`

## 實作規範 / Implementation Guidelines

### 程式碼範例 / Code Example

```swift
import Foundation

public struct ToggleLikeUseCase {
    private let repository: PrematchCommentRepository
    private let personalPageAdapter: PersonalPageAdapter
    
    public init(
        repository: PrematchCommentRepository,
        personalPageAdapter: PersonalPageAdapter
    ) {
        self.repository = repository
        self.personalPageAdapter = personalPageAdapter
    }
    
    public struct Input: Equatable, Sendable {
        public let commentId: String
        
        public init(commentId: String) {
            self.commentId = commentId
        }
    }
    
    public struct Output: Equatable, Sendable {
        public let comment: PrematchComment.Comment
        
        public init(comment: PrematchComment.Comment) {
            self.comment = comment
        }
    }
    
    public func execute(input: Input) async throws -> Output {
        // 登入檢查
        guard personalPageAdapter.isLoggedIn else {
            throw ToggleLikeError.notLoggedIn
        }
        
        // Toggle Like
        let comment = try await repository.toggleLike(commentId: input.commentId)
        return Output(comment: comment)
    }
}
```

### 命名規範 / Naming Conventions

- UseCase 使用 `struct`，提供 `execute(input:)` 方法 / UseCase uses `struct`, provides `execute(input:)` method
- Input/Output 使用 nested `struct`，實作 `Equatable`、`Sendable` / Input/Output use nested `struct`, implement `Equatable`, `Sendable`
- 使用 `PrematchComment.XXX` 命名空間 / Use `PrematchComment.XXX` namespace
- 使用 `public` 修飾符 / Use `public` modifier

## 驗收條件 / Acceptance Criteria

- [ ] `ToggleLikeUseCase` 實作完成 / `ToggleLikeUseCase` implementation complete
- [ ] Input/Output Model 定義完成 / Input/Output Model definition complete
- [ ] 登入檢查邏輯實作完成 / Login check logic implementation complete
- [ ] UseCase 商業邏輯實作完成 / UseCase business logic implementation complete
- [ ] 所有 Test Scenarios 通過（Basic / Optional） / All Test Scenarios passed (Basic / Optional)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 90% / Unit Test Coverage ≥ 90%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- UseCase 定義：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Input/Output Model：`output/LiveChat&PrematchComment/07_UseCase Input & Output Model/01_usecase_input_output.md`
- Test Scenarios：`output/LiveChat&PrematchComment/10_Test Scenarios/01_test_scenarios.md`

