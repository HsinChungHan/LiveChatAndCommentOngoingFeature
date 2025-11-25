# TDD-040: ReloadCommentListUseCase

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-040 |
| **標題** | 實作 ReloadCommentListUseCase |
| **類型** | UseCase |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | TDD-030 |
| **Story Point** | 5 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：2 天<br/>最嚴厲：1 天 |

## 描述 / Description

實作 ReloadCommentListUseCase。 / Implement ReloadCommentListUseCase。

## 需求 / Requirements

1. 實作 UseCase 商業邏輯 / Implement UseCase 商業Logic
2. 整合 PrematchCommentRepository 呼叫 / Integrate PrematchCommentRepository Call
3. 實作 Input/Output Model 驗證 / Implement Input/Output Model Validation
4. 實作 Error Handling / Implement Error Handling
5. 支援 triggerType（init / refresh
6. 支援 mode（top / newest）
7. 支援分頁（cursor） / 支援Pagination(cursor)

## 驗收條件 / Acceptance Criteria

- [ ] UseCase 商業邏輯實作完成 / UseCase 商業LogicImplementation Complete
- [ ] 所有 Test Scenarios 通過（Basic / Branch
- [ ] Unit Test 覆蓋率 ≥ 90% / Unit Test Coverage ≥ 90%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- UseCase 定義：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Input/Output Model：`output/LiveChat&PrematchComment/07_UseCase Input & Output Model/01_usecase_input_output.md`
- Test Scenarios：`output/LiveChat&PrematchComment/10_Test Scenarios/01_test_scenarios.md`

