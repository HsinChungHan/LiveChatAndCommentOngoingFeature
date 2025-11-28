# TDD-002: CommentMeta Entity

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-002 |
| **標題** | 實作 CommentMeta Entity |
| **類型** | Domain Model |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | - |
| **Story Point** | 1 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：0.3 天<br/>最嚴厲：0.2 天 |
| **開發日期 / Development Date** | 2025-11-27 (週四)

## 描述 / Description

定義 CommentMeta Entity Domain Model。 / Define CommentMeta Entity Domain Model。

## 需求 / Requirements

1. 在 `PrematchComment` namespace 內定義 `CommentMeta` struct / Define `CommentMeta` struct within `PrematchComment` namespace
2. 實作 `Identifiable`、`Equatable`、`Sendable` / Implement `Identifiable`, `Equatable`, `Sendable`
3. 使用 `public` 修飾符 / Use `public` modifier
4. 定義所有必要欄位（id、commentCount、betCount、refId） / Define all required fields (id, commentCount, betCount, refId)
5. 檔案結構：與 `Comment` 放在同一個檔案 `PrematchComment.swift` / File structure: Place in same file `PrematchComment.swift` as `Comment`

## 實作規範 / Implementation Guidelines

### 程式碼範例 / Code Example

```swift
extension PrematchComment {
    public struct CommentMeta: Identifiable, Equatable, Sendable {
        public let id: String
        public let commentCount: Int
        public let betCount: String
        public let refId: String
        
        public init(
            id: String,
            commentCount: Int,
            betCount: String,
            refId: String
        ) {
            self.id = id
            self.commentCount = commentCount
            self.betCount = betCount
            self.refId = refId
        }
        
        // Equatable: 透過 id 來比較
        public static func == (lhs: CommentMeta, rhs: CommentMeta) -> Bool {
            lhs.id == rhs.id
        }
    }
}
```

## 驗收條件 / Acceptance Criteria

- [ ] `CommentMeta` struct 定義在 `PrematchComment` namespace extension 內 / `CommentMeta` struct defined within `PrematchComment` namespace extension
- [ ] 所有欄位類型正確，使用 `public` 修飾符 / All field types correct, using `public` modifier
- [ ] 實作 `Identifiable`、`Equatable`、`Sendable` protocols / Implement `Identifiable`, `Equatable`, `Sendable` protocols
- [ ] Equatable 實作正確（透過 id 比較） / Equatable implementation correct (compare by id)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%

## 相關文件 / Related Documents

- Domain Model 定義：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`

