# TDD-046: JoinChatroomUseCase

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-046 |
| **標題** | 實作 JoinChatroomUseCase |
| **類型** | UseCase |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-031 |
| **Story Point** | 13 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：5 天<br/>最嚴厲：4 天 |

## 描述 / Description

實作 JoinChatroomUseCase。 / Implement JoinChatroomUseCase。

## 需求 / Requirements

1. 實作 UseCase 商業邏輯 / Implement UseCase 商業Logic
2. 整合 LiveChatRepository 呼叫 / Integrate LiveChatRepository Call
3. 實作 Input/Output Model 驗證 / Implement Input/Output Model Validation
4. 實作 Error Handling / Implement Error Handling
5. 實作歷史訊息與 WebSocket 訊息合併邏輯 / 實作歷史訊息與 WebSocket 訊息合併Logic
6. 實作依 messageNo 去重邏輯 / 實作依 messageNo 去重Logic
7. 處理無法取得 chatroomId 的情況 / 處理無法取得 ChatroomId 的情況

## 驗收條件 / Acceptance Criteria

- [ ] UseCase 商業邏輯實作完成 / UseCase 商業LogicImplementation Complete
- [ ] 訊息合併邏輯實作完成 / 訊息合併LogicImplementation Complete
- [ ] 去重邏輯實作完成 / 去重LogicImplementation Complete
- [ ] 所有 Test Scenarios 通過（Basic / Branch
- [ ] Unit Test 覆蓋率 ≥ 90% / Unit Test Coverage ≥ 90%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- UseCase 定義：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Input/Output Model：`output/LiveChat&PrematchComment/07_UseCase Input & Output Model/01_usecase_input_output.md`
- Test Scenarios：`output/LiveChat&PrematchComment/10_Test Scenarios/01_test_scenarios.md`

## 調整因子說明 / 調整因子說明

- 基礎估時：複雜 UseCase = 13 SP
- +2 SP：複雜的資料合併邏輯（歷史訊息與 WebSocket 訊息合併） / - +2 SP：複雜的資料合併Logic(歷史訊息與 WebSocket 訊息合併)
- +1 SP：複雜的去重邏輯 / - +1 SP：複雜的去重Logic

