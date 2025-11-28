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
| **開發日期 / Development Date** | 2025-11-27 (週四)

## 描述 / Description

定義 Comment Entity Domain Model。 / Define Comment Entity Domain Model。

## 需求 / Requirements

1. 定義 `PrematchComment` namespace enum / Define `PrematchComment` namespace enum
2. 在 namespace 內定義 `Comment` struct / Define `Comment` struct within namespace
3. 實作 `Identifiable`、`Equatable`、`Sendable` / Implement `Identifiable`, `Equatable`, `Sendable`
4. 使用 `public` 修飾符 / Use `public` modifier
5. 定義所有必要欄位（id、content、likeCount、authorId 等） / Define all required fields (id, content, likeCount, authorId, etc.)
6. 檔案結構：`Sources/PrematchComment/Models/PrematchComment.swift` / File structure: `Sources/PrematchComment/Models/PrematchComment.swift`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/PrematchComment/Models/
  └── PrematchComment.swift
```

### 程式碼範例 / Code Example

```swift
import Foundation

/// The namespace for types and functions related to PrematchComment
public enum PrematchComment {}

extension PrematchComment {
    public struct Comment: Identifiable, Equatable, Sendable {
        public let id: String
        public let content: String
        public var likeCount: Int
        public let authorId: String
        public let authorNickname: String?
        public let parentId: String?
        public let createdAt: Date
        public let refId: String
        public let repliesCount: Int
        public let likedByMe: Bool
        public let isIsolated: Bool
        public let isDeleted: Bool
        
        public init(
            id: String,
            content: String,
            likeCount: Int,
            authorId: String,
            authorNickname: String?,
            parentId: String?,
            createdAt: Date,
            refId: String,
            repliesCount: Int,
            likedByMe: Bool,
            isIsolated: Bool,
            isDeleted: Bool
        ) {
            self.id = id
            self.content = content
            self.likeCount = likeCount
            self.authorId = authorId
            self.authorNickname = authorNickname
            self.parentId = parentId
            self.createdAt = createdAt
            self.refId = refId
            self.repliesCount = repliesCount
            self.likedByMe = likedByMe
            self.isIsolated = isIsolated
            self.isDeleted = isDeleted
        }
        
        // Equatable: 透過 id 來比較
        public static func == (lhs: Comment, rhs: Comment) -> Bool {
            lhs.id == rhs.id
        }
    }
}
```

### 命名規範 / Naming Conventions

- 使用 `PrematchComment` 作為 namespace enum / Use `PrematchComment` as namespace enum
- Entity 使用 `public struct`，放在 namespace extension 內 / Entity uses `public struct`, placed within namespace extension
- 所有屬性使用 `public let` 或 `public var` / All properties use `public let` or `public var`
- 實作 `Identifiable`、`Equatable`、`Sendable` protocols / Implement `Identifiable`, `Equatable`, `Sendable` protocols

## 驗收條件 / Acceptance Criteria

- [ ] `PrematchComment` namespace enum 定義完成 / `PrematchComment` namespace enum definition complete
- [ ] `Comment` struct 定義在 namespace extension 內 / `Comment` struct defined within namespace extension
- [ ] 所有欄位類型正確，使用 `public` 修飾符 / All field types correct, using `public` modifier
- [ ] 實作 `Identifiable`、`Equatable`、`Sendable` protocols / Implement `Identifiable`, `Equatable`, `Sendable` protocols
- [ ] Equatable 實作正確（透過 id 比較） / Equatable implementation correct (compare by id)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%

## 相關文件 / Related Documents

- Domain Model 定義：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`

