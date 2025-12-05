# TDD-020: PrematchCommentClient

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-020 |
| **Jira Key** | FOOTBALL-9181 |
| **標題** | 實作 PrematchCommentClient（HTTP） |
| **類型** | Client |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | TDD-010 |
| **Story Point** | 5 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：2 天<br/>最嚴厲：1 天 |
| **開發日期 / Development Date** | 2025-12-02 (週二)

## 描述 / Description

實作 PrematchCommentClient（HTTP）。 / Implement PrematchCommentClient(HTTP)。

## 需求 / Requirements

1. 實作 `PrematchCommentClient`（使用 `APIClient`） / Implement `PrematchCommentClient` (using `APIClient`)
2. 整合 `PrematchCommentAPI.PrematchCommentRepository` / Integrate `PrematchCommentAPI.PrematchCommentRepository`
3. 實作 Error Handling / Implement Error Handling
4. 檔案結構：`Sources/PrematchComment/Services/API/PrematchCommentClient.swift` / File structure: `Sources/PrematchComment/Services/API/PrematchCommentClient.swift`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/PrematchComment/Services/API/
  └── PrematchCommentClient.swift
```

### 程式碼範例 / Code Example

```swift
import Foundation
import NetworkService

public struct PrematchCommentClient {
    private let apiRepository: PrematchCommentAPI.PrematchCommentRepository
    
    public init(apiRepository: PrematchCommentAPI.PrematchCommentRepository = PrematchCommentAPI.PrematchCommentRepository()) {
        self.apiRepository = apiRepository
    }
    
    /// 批量獲取評論資訊
    public func getBatchCommentInfo(refIdList: [String]) async throws -> [PrematchCommentAPI.CommentMetaInfoDTO] {
        return try await apiRepository.getBatchCommentInfo(refIdList: refIdList)
    }
    
    /// 獲取單個評論資訊
    public func getCommentMeta(refId: String) async throws -> PrematchCommentAPI.CommentMetaDataDTO {
        return try await apiRepository.getCommentMeta(refId: refId)
    }
    
    /// 獲取熱度排序的評論列表
    public func getCommentsByPopular(refId: String, pageNum: Int?, pageSize: Int?) async throws -> [PrematchCommentAPI.CommentDTO] {
        return try await apiRepository.getCommentsByPopular(refId: refId, pageNum: pageNum, pageSize: pageSize)
    }
    
    /// 獲取最新排序的評論列表
    public func getCommentsByNewest(refId: String, prevCommentId: Int64?, pageSize: Int?) async throws -> [PrematchCommentAPI.CommentDTO] {
        return try await apiRepository.getCommentsByNewest(refId: refId, prevCommentId: prevCommentId, pageSize: pageSize)
    }
    
    /// 獲取回覆列表
    public func getReplies(parentCommentId: Int64, prevCommentId: Int64?, pageSize: Int?) async throws -> [PrematchCommentAPI.CommentDTO] {
        return try await apiRepository.getReplies(parentCommentId: parentCommentId, prevCommentId: prevCommentId, pageSize: pageSize)
    }
    
    /// 發佈評論
    /// - Note: sharedBetsMeta 使用 SharedBetsMetadata 包裝以符合 Sendable 協議
    public func publishComment(refId: String, content: String, parentId: Int64?, sharedBetsMeta: SharedBetsMetadata?, tagUserId: String?) async throws -> PrematchCommentAPI.CommentDTO {
        return try await apiRepository.publishComment(refId: refId, content: content, parentId: parentId, sharedBetsMeta: sharedBetsMeta, tagUserId: tagUserId)
    }
    
    /// 切換點讚狀態
    public func toggleLike(commentId: Int64) async throws -> PrematchCommentAPI.CommentDTO? {
        return try await apiRepository.toggleLike(commentId: commentId)
    }
}
```

### 命名規範 / Naming Conventions

- Client 使用 `struct`，提供公開方法 / Client uses `struct`, provides public methods
- 內部使用 `PrematchCommentAPI.PrematchCommentRepository` / Internally uses `PrematchCommentAPI.PrematchCommentRepository`
- 方法直接委派給 Repository / Methods delegate directly to Repository
- 使用 `public` 修飾符 / Use `public` modifier
- `sharedBetsMeta` 使用 `SharedBetsMetadata` 包裝型別以符合 Sendable 協議 / `sharedBetsMeta` uses `SharedBetsMetadata` wrapper type for Sendable compliance

## 驗收條件 / Acceptance Criteria

- [ ] `PrematchCommentClient` 實作完成 / `PrematchCommentClient` implementation complete
- [ ] 所有 API 呼叫方法實作完成 / All API call methods implementation complete
- [ ] Error Handling 實作完成 / Error Handling implementation complete
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- API Spec：`08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`03_Module Responsibility/01_module_responsibility.md`

