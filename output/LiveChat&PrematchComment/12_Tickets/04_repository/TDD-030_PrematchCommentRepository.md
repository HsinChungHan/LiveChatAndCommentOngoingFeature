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
| **開發日期 / Development Date** | 2025-12-04 (週四)

## 描述 / Description

實作 PrematchCommentRepository。 / Implement PrematchCommentRepository。

## 需求 / Requirements

1. 實作 Repository Protocol（定義在 `PrematchCommentAPI+RepositoryProtocol.swift`） / Implement Repository Protocol (defined in `PrematchCommentAPI+RepositoryProtocol.swift`)
2. 實作 Repository（定義在 `PrematchCommentAPI+Repository.swift`，使用 `actor`） / Implement Repository (defined in `PrematchCommentAPI+Repository.swift`, using `actor`)
3. 實作 DTO → Domain Model 轉換（使用 extension，如 `PrematchCommentAPI+PrematchCommentAPI.swift`） / Implement DTO → Domain Model conversion (using extension, e.g., `PrematchCommentAPI+PrematchCommentAPI.swift`)
4. 整合 `PrematchCommentAPI.PrematchCommentRepository` 呼叫 / Integrate `PrematchCommentAPI.PrematchCommentRepository` call
5. 實作所有方法： / Implement all methods:
   - `getUserInfo() async throws -> PrematchComment.UserInfo`
   - `getCommentMeta(refId: String) async throws -> PrematchComment.CommentMeta`
   - `getComments(refId: String, mode: PrematchComment.SortMode, cursor: PrematchComment.Cursor?) async throws -> ([PrematchComment.Comment], PrematchComment.PagingInfo)`
   - `publishComment(refId: String, content: String, parentId: String?) async throws -> PrematchComment.Comment`
   - `toggleLike(commentId: String) async throws -> PrematchComment.Comment`
   - `getReplies(commentId: String, cursor: PrematchComment.Cursor?) async throws -> ([PrematchComment.Comment], PrematchComment.PagingInfo)`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/PrematchComment/Services/API/PrematchComment/
  ├── PrematchCommentAPI+RepositoryProtocol.swift  # Repository Protocol
  ├── PrematchCommentAPI+Repository.swift          # Repository 實作（actor）
  └── PrematchCommentAPI+PrematchCommentAPI.swift # DTO → Domain Model 轉換
```

### 程式碼範例 / Code Examples

#### PrematchCommentAPI+PrematchCommentAPI.swift (DTO → Domain Model 轉換)
```swift
import Foundation

extension PrematchCommentAPI.CommentDTO {
    func toDomainComment(refId: String) -> PrematchComment.Comment {
        return PrematchComment.Comment(
            id: String(id),
            content: content,
            likeCount: likeCount,
            authorId: authorId,
            authorNickname: authorNickname,
            parentId: parentId == 0 ? nil : String(parentId),
            createdAt: Date(timeIntervalSince1970: TimeInterval(createdAt) / 1000),
            refId: refId,
            repliesCount: repliesCount,
            likedByMe: likedByMe,
            isIsolated: isIsolated,
            isDeleted: isDeleted
        )
    }
}

extension PrematchCommentAPI.CommentPageDTO {
    func toDomainComments(refId: String) -> ([PrematchComment.Comment], PrematchComment.PagingInfo) {
        let comments = list.map { $0.toDomainComment(refId: refId) }
        let pagingInfo = PrematchComment.PagingInfo(
            cursor: cursor == -1 ? nil : PrematchComment.Cursor(value: cursor),
            hasMore: cursor != -1
        )
        return (comments, pagingInfo)
    }
}
```

#### PrematchCommentRepository 實作
```swift
import Foundation
import NetworkService

extension PrematchCommentAPI {
    public actor PrematchCommentRepository: PrematchCommentRepositoryProtocol {
        private let apiRepository: PrematchCommentAPI.PrematchCommentRepository
        
        public init(apiRepository: PrematchCommentAPI.PrematchCommentRepository = PrematchCommentAPI.PrematchCommentRepository()) {
            self.apiRepository = apiRepository
        }
        
        public func getCommentMeta(refId: String) async throws -> PrematchComment.CommentMeta {
            let dto = try await apiRepository.getCommentMeta(refId: refId)
            return dto.toDomainCommentMeta()
        }
        
        public func getComments(
            refId: String,
            mode: PrematchComment.SortMode,
            cursor: PrematchComment.Cursor?
        ) async throws -> ([PrematchComment.Comment], PrematchComment.PagingInfo) {
            let dto = try await apiRepository.getComments(
                refId: refId,
                mode: mode.rawValue,
                cursor: cursor?.value
            )
            return dto.toDomainComments(refId: refId)
        }
        
        // 其他方法...
    }
}
```

### 命名規範 / Naming Conventions

- Repository 使用 `actor`，實作 `PrematchCommentRepositoryProtocol` / Repository uses `actor`, implements `PrematchCommentRepositoryProtocol`
- DTO → Domain Model 轉換使用 extension，方法命名為 `toDomainXXX()` / DTO → Domain Model conversion uses extension, method named `toDomainXXX()`
- Domain Model 使用 `PrematchComment.XXX` 命名空間 / Domain Model uses `PrematchComment.XXX` namespace
- 使用 `public` 修飾符 / Use `public` modifier

## 驗收條件 / Acceptance Criteria

- [ ] Repository Protocol 定義完成（在 `PrematchCommentAPI+RepositoryProtocol.swift`） / Repository Protocol definition complete (in `PrematchCommentAPI+RepositoryProtocol.swift`)
- [ ] Repository 實作完成，使用 `actor`（在 `PrematchCommentAPI+Repository.swift`） / Repository implementation complete, using `actor` (in `PrematchCommentAPI+Repository.swift`)
- [ ] DTO → Domain Model Mapping 實作完成，使用 extension（在 `PrematchCommentAPI+PrematchCommentAPI.swift`） / DTO → Domain Model Mapping implementation complete, using extension (in `PrematchCommentAPI+PrematchCommentAPI.swift`)
- [ ] 所有方法使用 `PrematchComment.XXX` 命名空間 / All methods use `PrematchComment.XXX` namespace
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] 所有方法 Unit Test 覆蓋率 ≥ 80% / All methods Unit Test Coverage ≥ 80%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Domain Model：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`
- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`

