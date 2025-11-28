# TDD-030: PrematchCommentRepository

## Ticket Information

|------|-----|
|  | **Ticket ID** | TDD-030 |
| **Jira Key** | FOOTBALL-9185 |  |
|  | Implement PrematchCommentRepository |  |
|  | **Type** | Repository |  |
|  | P0 |  |
|  | PrematchComment |  |
|  | TDD-001, TDD-002, TDD-006, TDD-020 |  |
|  | **Story Point** | 5 |  |
|  | Standard：2 days<br/>Most Stringent：1 days |  |

## Description

Implement PrematchCommentRepository。

## Requirements

1. Implement Repository 介面
2. Implement DTO → Domain Model 轉換
3. Integrate PrematchCommentClient Call
4. ImplementallMethods：
5. - `getUserInfo() async throws -> UserInfo`
6. - `getCommentMeta(refId: String) async throws -> CommentMeta`
7. - `getComments(refId: String, mode: SortMode, cursor: Cursor?) async throws -> ([Comment], PagingInfo)`
8. - `publishComment(refId: String, content: String, parentId: String?) async throws -> Comment`
9. - `toggleLike(commentId: String) async throws -> Comment`
10. - `getReplies(commentId: String, cursor: Cursor?) async throws -> ([Comment], PagingInfo)`

## Acceptance Criteria

- [ ] Repository 介面Implementation Complete
- [ ] DTO → Domain Model Mapping Implementation Complete
- [ ] allMethods Unit Test Coverage ≥ 80%
- [ ] Integration Test Passed

## Related Documents

- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Domain Model：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`
- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`
