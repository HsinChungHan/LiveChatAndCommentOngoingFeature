# TDD-040: ReloadCommentListUseCase

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-040 |
| **Jira Key** | FOOTBALL-9188 |
| **標題** | 實作 ReloadCommentListUseCase |
| **類型** | UseCase |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | TDD-030 |
| **Story Point** | 5 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：2 天<br/>最嚴厲：1 天 |
| **開發日期 / Development Date** | 2025-12-08 (週一)

## 描述 / Description

實作 ReloadCommentListUseCase。 / Implement ReloadCommentListUseCase。

## 需求 / Requirements

1. 實作 `ReloadCommentListUseCase` struct / Implement `ReloadCommentListUseCase` struct
2. 定義 Input/Output Model / Define Input/Output Model
3. 整合 `PrematchCommentRepository` 呼叫 / Integrate `PrematchCommentRepository` call
4. 實作商業邏輯（triggerType、mode、cursor 處理） / Implement business logic (triggerType, mode, cursor handling)
5. 實作 Error Handling / Implement Error Handling
6. 檔案結構：`Sources/PrematchComment/UseCases/ReloadCommentListUseCase.swift` / File structure: `Sources/PrematchComment/UseCases/ReloadCommentListUseCase.swift`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/PrematchComment/UseCases/
  └── ReloadCommentListUseCase.swift
```

### 程式碼範例 / Code Example

```swift
import Foundation

public struct ReloadCommentListUseCase {
    private let repository: PrematchCommentRepository
    
    public init(repository: PrematchCommentRepository) {
        self.repository = repository
    }
    
    public struct Input: Equatable, Sendable {
        public let refId: String
        public let mode: PrematchComment.SortMode
        public let triggerType: TriggerType
        public let cursor: PrematchComment.Cursor?
        
        public enum TriggerType: Equatable, Sendable {
            case init
            case refresh
        }
        
        public init(
            refId: String,
            mode: PrematchComment.SortMode,
            triggerType: TriggerType,
            cursor: PrematchComment.Cursor?
        ) {
            self.refId = refId
            self.mode = mode
            self.triggerType = triggerType
            self.cursor = cursor
        }
    }
    
    public struct Output: Equatable, Sendable {
        public let comments: [PrematchComment.Comment]
        public let pagingInfo: PrematchComment.PagingInfo
        
        public init(
            comments: [PrematchComment.Comment],
            pagingInfo: PrematchComment.PagingInfo
        ) {
            self.comments = comments
            self.pagingInfo = pagingInfo
        }
    }
    
    public func execute(input: Input) async throws -> Output {
        let (comments, pagingInfo) = try await repository.getComments(
            refId: input.refId,
            mode: input.mode.rawValue,
            cursor: input.cursor?.value
        )
        return Output(comments: comments, pagingInfo: pagingInfo)
    }
}
```

### 命名規範 / Naming Conventions

- UseCase 使用 `struct`，提供 `execute(input:)` 方法 / UseCase uses `struct`, provides `execute(input:)` method
- Input/Output 使用 nested `struct`，實作 `Equatable`、`Sendable` / Input/Output use nested `struct`, implement `Equatable`, `Sendable`
- 使用 `PrematchComment.XXX` 命名空間 / Use `PrematchComment.XXX` namespace
- 使用 `public` 修飾符 / Use `public` modifier

## 驗收條件 / Acceptance Criteria

- [ ] `ReloadCommentListUseCase` 實作完成 / `ReloadCommentListUseCase` implementation complete
- [ ] Input/Output Model 定義完成 / Input/Output Model definition complete
- [ ] UseCase 商業邏輯實作完成 / UseCase business logic implementation complete
- [ ] 所有 Test Scenarios 通過（Basic / Branch） / All Test Scenarios passed (Basic / Branch)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 90% / Unit Test Coverage ≥ 90%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- UseCase 定義：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Input/Output Model：`output/LiveChat&PrematchComment/07_UseCase Input & Output Model/01_usecase_input_output.md`
- Test Scenarios：`output/LiveChat&PrematchComment/10_Test Scenarios/01_test_scenarios.md`

