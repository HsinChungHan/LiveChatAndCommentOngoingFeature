# TDD-046: JoinChatroomUseCase

## Ticket Information

|------|-----|
|  | **Ticket ID** | TDD-046 |
| **Jira Key** | FOOTBALL-9194 |  |
|  | Implement JoinChatroomUseCase |  |
|  | **Type** | UseCase |  |
|  | P0 |  |
|  | LiveChat |  |
|  | TDD-031 |  |
|  | **Story Point** | 13 |  |
|  | Standard：5 days<br/>Most Stringent：4 days |  |

## Description

Implement JoinChatroomUseCase。

## Requirements

1. Implement UseCase Business Logic
2. Integrate LiveChatRepository Call
3. Implement Input/Output Model Validation
4. Implement Error Handling
5. Implement歷史訊息與 WebSocket 訊息合併Logic
6. Implement依 messageNo 去重Logic
7. Handling無法取得 ChatroomId 的情況

## Acceptance Criteria

- [ ] UseCase Business Logic Implementation Complete
- [ ] 訊息合併LogicImplementation Complete
- [ ] 去重LogicImplementation Complete
- [ ] All branches tested
- [ ] Unit Test Coverage ≥ 90%
- [ ] Integration Test Passed

## Related Documents

- UseCase Definition: `output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Input/Output Model: `output/LiveChat&PrematchComment/07_UseCase Input & Output Model/01_usecase_input_output.md`
- Test Scenarios: `output/LiveChat&PrematchComment/10_Test Scenarios/01_test_scenarios.md`

## 調整因子說明

- +2 SP：複雜的資料合併Logic(歷史訊息與 WebSocket 訊息合併)
- +1 SP：複雜的去重Logic

