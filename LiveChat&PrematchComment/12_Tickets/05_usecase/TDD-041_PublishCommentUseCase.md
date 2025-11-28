# TDD-041: PublishCommentUseCase

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-041 |
| **Jira Key** | FOOTBALL-9189 |
| **標題** | 實作 PublishCommentUseCase |
| **類型** | UseCase |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | TDD-030 |
| **Story Point** | 13 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：5 天<br/>最嚴厲：4 天 |
| **開發日期 / Development Date** | 2025-12-09 (週二)

## 描述 / Description

實作 PublishCommentUseCase。 / Implement PublishCommentUseCase。

## 需求 / Requirements

1. 實作 `PublishCommentUseCase` struct / Implement `PublishCommentUseCase` struct
2. 定義 Input/Output Model / Define Input/Output Model
3. 整合 `PrematchCommentRepository` 呼叫 / Integrate `PrematchCommentRepository` call
4. 整合 `PersonalPageAdapter` Protocol（登入檢查） / Integrate `PersonalPageAdapter` Protocol (login check)
5. 整合 `FComSharedFlowAdapter` Protocol（nickname 建立） / Integrate `FComSharedFlowAdapter` Protocol (nickname creation)
6. 實作商業邏輯（留言 vs 回覆） / Implement business logic (comment vs reply)
7. 實作 Error Handling / Implement Error Handling
8. 檔案結構：`Sources/PrematchComment/UseCases/PublishCommentUseCase.swift` / File structure: `Sources/PrematchComment/UseCases/PublishCommentUseCase.swift`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/PrematchComment/UseCases/
  └── PublishCommentUseCase.swift
```

### 程式碼範例 / Code Example

```swift
import Foundation

public struct PublishCommentUseCase {
    private let repository: PrematchCommentRepository
    private let personalPageAdapter: PersonalPageAdapter
    private let fComSharedFlowAdapter: FComSharedFlowAdapter
    
    public init(
        repository: PrematchCommentRepository,
        personalPageAdapter: PersonalPageAdapter,
        fComSharedFlowAdapter: FComSharedFlowAdapter
    ) {
        self.repository = repository
        self.personalPageAdapter = personalPageAdapter
        self.fComSharedFlowAdapter = fComSharedFlowAdapter
    }
    
    public struct Input: Equatable, Sendable {
        public let refId: String
        public let content: String
        public let parentId: String?
        
        public init(refId: String, content: String, parentId: String?) {
            self.refId = refId
            self.content = content
            self.parentId = parentId
        }
    }
    
    public struct Output: Equatable, Sendable {
        public let comment: PrematchComment.Comment
        
        public init(comment: PrematchComment.Comment) {
            self.comment = comment
        }
    }
    
    public func execute(input: Input) async throws -> Output {
        // 1. 登入檢查
        guard personalPageAdapter.isLoggedIn else {
            throw PublishCommentError.notLoggedIn
        }
        
        // 2. Nickname 檢查和建立
        if !personalPageAdapter.hasNickname {
            try await fComSharedFlowAdapter.createNickname()
        }
        
        // 3. 發送留言
        let comment = try await repository.publishComment(
            refId: input.refId,
            content: input.content,
            parentId: input.parentId
        )
        
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

- [ ] `PublishCommentUseCase` 實作完成 / `PublishCommentUseCase` implementation complete
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
- +2 SP：複雜的商業邏輯（留言 vs 回覆） / - +2 SP：複雜的商業Logic(留言 vs 回覆)
- +1 SP：需要處理多種 Error 情況

