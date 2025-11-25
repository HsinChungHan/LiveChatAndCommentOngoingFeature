# TDD-050: PrematchCommentFeature

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-050 |
| **標題** | 實作 PrematchCommentFeature（TCA Reducer） |
| **類型** | Feature |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | TDD-040, TDD-041, TDD-042, TDD-043, TDD-044 |
| **Story Point** | 8 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：3 天<br/>最嚴厲：2 天 |

## 描述 / Description

實作 PrematchCommentFeature（TCA Reducer）。 / Implement PrematchCommentFeature(TCA Reducer)。

## 需求 / Requirements

1. 定義 State 結構 / Define State Structure
2. 定義 Action 列舉 / Define Action 列舉
3. 實作 Reducer 邏輯 / Implement Reducer Logic
4. 整合所有 UseCase 呼叫 / 整合所有 UseCase Call
5. 實作 State 更新邏輯 / Implement State UpdateLogic
6. 實作 Event Status 通知處理 / Implement Event Status 通知處理

## 驗收條件 / Acceptance Criteria

- [ ] State 和 Action 定義完成 / State 和 Action Definition Complete
- [ ] Reducer 邏輯實作完成 / Reducer LogicImplementation Complete
- [ ] 所有 Action → UseCase 映射完成 / 所有 Action → UseCase 映射完成
- [ ] Event Status 通知處理實作完成 / Event Status 通知處理Implementation Complete
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%

## 相關文件 / Related Documents

- Feature State & Action：`output/LiveChat&PrematchComment/06_Feature State & Action (TCA)/01_feature_state_action.md`
- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`

## 調整因子說明 / 調整因子說明

- 基礎估時：中等 Feature = 3 SP
- +2 SP：需要處理複雜的狀態同步（Event Status 通知） / - +2 SP：需要處理複雜的State同步(Event Status 通知)
- +2 SP：需要處理多種 UI 狀態（Loading、Error、Success） / - +2 SP：需要處理多種 UI State(Loading, Error, Success)
- +1 SP：整合多個 UseCase（5 個） / - +1 SP：整合多個 UseCase(5 個)

