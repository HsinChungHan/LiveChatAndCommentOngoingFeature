# TDD-006: Value Objects

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-006 |
| **標題** | 實作 Value Objects（SortMode、Cursor、PagingInfo） |
| **類型** | Domain Model |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat & PrematchComment |
| **依賴 Ticket** | - |
| **Story Point** | 2 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：1 天<br/>最嚴厲：0.4 天 |

## 描述 / Description

定義所有 Value Objects（SortMode、Cursor、PagingInfo）。 / Define All Value Objects(SortMode, Cursor, PagingInfo)。

## 需求 / Requirements

1. 定義 SortMode Value Object（top / newest）
2. 定義 Cursor Value Object（分頁游標） / Define Cursor Value Object(Pagination游標)
3. 定義 PagingInfo Value Object（hasMore、nextCursor） / Define PagingInfo Value Object(hasMore, nextCursor)
4. 實作 Equatable（透過值比較） / Implement Equatable(透過值比較)
5. 確保完全不可變 / 確保完全不可變

## 驗收條件 / Acceptance Criteria

- [ ] SortMode Value Object 定義完成 / SortMode Value Object Definition Complete
- [ ] Cursor Value Object 定義完成 / Cursor Value Object Definition Complete
- [ ] PagingInfo Value Object 定義完成 / PagingInfo Value Object Definition Complete
- [ ] 所有 Value Object 完全不可變 / 所有 Value Object 完全不可變
- [ ] Equatable 實作正確（透過值比較） / Equatable 實作正確(透過值比較)
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%

## 相關文件 / Related Documents

- Domain Model 定義：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`

