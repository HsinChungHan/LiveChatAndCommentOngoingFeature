# TDD-030: PrematchCommentRepository

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-030 |
| **標題** | 實作 PrematchCommentRepository |
| **類型** | Repository |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | TDD-001, TDD-002, TDD-006, TDD-020 |
| **Story Point** | 5 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：2 天<br/>最嚴厲：1 天 |

## 描述 / Description

實作 PrematchCommentRepository。 / Implement PrematchCommentRepository。

## 需求 / Requirements

1. 實作 Repository 介面 / Implement Repository 介面
2. 實作 DTO → Domain Model 轉換 / Implement DTO → Domain Model 轉換
3. 整合 PrematchCommentClient 呼叫 / Integrate PrematchCommentClient Call
4. 實作所有方法： / 實作所有Methods：
   - `getUserInfo() async throws -> UserInfo`
   - `getCommentMeta(refId: String) async throws -> CommentMeta`
   - `getComments(refId: String, mode: SortMode, cursor: Cursor?) async throws -> ([Comment], PagingInfo)`
   - `publishComment(refId: String, content: String, parentId: String?) async throws -> Comment`
   - `toggleLike(commentId: String) async throws -> Comment`
   - `getReplies(commentId: String, cursor: Cursor?) async throws -> ([Comment], PagingInfo)`

## 驗收條件 / Acceptance Criteria

- [ ] Repository 介面實作完成 / Repository 介面Implementation Complete
- [ ] DTO → Domain Model Mapping 實作完成 / DTO → Domain Model Mapping Implementation Complete
- [ ] 所有方法 Unit Test 覆蓋率 ≥ 80% / 所有Methods Unit Test Coverage ≥ 80%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Domain Model：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`
- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`

