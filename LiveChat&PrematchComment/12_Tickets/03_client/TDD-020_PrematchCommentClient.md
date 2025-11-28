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
    
    public func getCommentMeta(refId: String) async throws -> PrematchCommentAPI.CommentMetaDTO {
        return try await apiRepository.getCommentMeta(refId: refId)
    }
    
    public func getComments(refId: String, mode: String, cursor: Int?) async throws -> PrematchCommentAPI.CommentPageDTO {
        return try await apiRepository.getComments(refId: refId, mode: mode, cursor: cursor)
    }
    
    // 其他方法...
}
```

### 命名規範 / Naming Conventions

- Client 使用 `struct`，提供公開方法 / Client uses `struct`, provides public methods
- 內部使用 `PrematchCommentAPI.PrematchCommentRepository` / Internally uses `PrematchCommentAPI.PrematchCommentRepository`
- 方法直接委派給 Repository / Methods delegate directly to Repository
- 使用 `public` 修飾符 / Use `public` modifier

## 驗收條件 / Acceptance Criteria

- [ ] `PrematchCommentClient` 實作完成 / `PrematchCommentClient` implementation complete
- [ ] 所有 API 呼叫方法實作完成 / All API call methods implementation complete
- [ ] Error Handling 實作完成 / Error Handling implementation complete
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`

