# TDD-006: Value Objects

## Ticket Information

|------|-----|
|  | **Ticket ID** | TDD-006 |
| **Jira Key** | FOOTBALL-9176 |  |
|  | Implement Value Objects（SortMode、Cursor、PagingInfo） |  |
|  | **Type** | Domain Model |  |
|  | P0 |  |
|  | LiveChat & PrematchComment |  |
|  | - |  |
|  | **Story Point** | 2 |  |
|  | Standard：1 days<br/>Most Stringent：0.4 days |  |

## Description

Define All Value Objects(SortMode, Cursor, PagingInfo)。

## Requirements

1. newest)
2. Define Cursor Value Object(Pagination游標)
3. Define PagingInfo Value Object(hasMore, nextCursor)
4. Implement Equatable(via值compare)
5. 確保完全不可變

## Acceptance Criteria

- [ ] SortMode Value Object Definition Complete
- [ ] Cursor Value Object Definition Complete
- [ ] PagingInfo Value Object Definition Complete
- [ ] all Value Object 完全不可變
- [ ] Equatable Implementcorrect(via值compare)
- [ ] Unit Test Coverage ≥ 80%

## Related Documents

- Domain Model Definition: `output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`
