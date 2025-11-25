# TDD-001: Comment Entity

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-001 |
| **標題** | 實作 Comment Entity |
| **類型** | Domain Model |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | - |
| **Story Point** | 1 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：0.3 天<br/>最嚴厲：0.2 天 |

## 描述 / Description

定義 Comment Entity Domain Model。 / Define Comment Entity Domain Model。

## 需求 / Requirements

1. 定義 Comment 結構 / Define Comment Structure
2. 實作 Identifiable 和 Equatable / Implement Identifiable 和 Equatable
3. 定義所有必要欄位（id、content、likeCount、authorId 等） / 定義所有RequiredFields(id, content, likeCount, authorId 等)

## 驗收條件 / Acceptance Criteria

- [ ] Comment Entity 定義完成 / Comment Entity Definition Complete
- [ ] 所有欄位類型正確 / 所有FieldsCorrect Types
- [ ] Equatable 實作正確（透過 id 比較） / Equatable 實作正確(透過 id 比較)
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%

## 相關文件 / Related Documents

- Domain Model 定義：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`

