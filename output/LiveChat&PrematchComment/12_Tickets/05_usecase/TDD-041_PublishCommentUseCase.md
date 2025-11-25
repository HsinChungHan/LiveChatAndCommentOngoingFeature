# TDD-041: PublishCommentUseCase

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-041 |
| **標題** | 實作 PublishCommentUseCase |
| **類型** | UseCase |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | TDD-030 |
| **Story Point** | 13 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：5 天<br/>最嚴厲：4 天 |

## 描述 / Description

實作 PublishCommentUseCase。 / Implement PublishCommentUseCase。

## 需求 / Requirements

1. 實作 UseCase 商業邏輯 / Implement UseCase 商業Logic
2. 整合 PrematchCommentRepository 呼叫 / Integrate PrematchCommentRepository Call
3. 實作 Input/Output Model 驗證 / Implement Input/Output Model Validation
4. 實作 Error Handling / Implement Error Handling
5. 整合 PersonalPageAdapter Protocol（登入檢查） / Integrate PersonalPageAdapter Protocol(登入檢查)
6. 整合 FComSharedFlowAdapter Protocol（nickname 建立） / Integrate FComSharedFlowAdapter Protocol(nickname 建立)
7. 支援留言和回覆（透過 parentId 區分） / 支援留言和回覆(透過 parentId 區分)

## 驗收條件 / Acceptance Criteria

- [ ] UseCase 商業邏輯實作完成 / UseCase 商業LogicImplementation Complete
- [ ] 登入檢查邏輯實作完成 / 登入檢查LogicImplementation Complete
- [ ] Nickname 檢查和建立邏輯實作完成 / Nickname 檢查和建立LogicImplementation Complete
- [ ] 所有 Test Scenarios 通過（Basic / Branch
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

