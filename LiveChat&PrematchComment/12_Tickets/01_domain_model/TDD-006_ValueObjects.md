# TDD-006: Value Objects

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-006 |
| **Jira Key** | FOOTBALL-9176 |
| **標題** | 實作 Value Objects（SortMode、Cursor、PagingInfo） |
| **類型** | Domain Model |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat & PrematchComment |
| **依賴 Ticket** | - |
| **Story Point** | 2 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：1 天<br/>最嚴厲：0.4 天 |
| **開發日期 / Development Date** | 2025-11-28 (週五)

## 描述 / Description

定義所有 Value Objects（SortMode、Cursor、PagingInfo）。 / Define All Value Objects(SortMode, Cursor, PagingInfo)。

## 需求 / Requirements

1. 在 `PrematchComment` 和 `LiveChat` namespace 內定義 Value Objects / Define Value Objects within `PrematchComment` and `LiveChat` namespace
2. 定義 `SortMode` enum（top / newest） / Define `SortMode` enum (top / newest)
3. 定義 `Cursor` struct（分頁游標） / Define `Cursor` struct (pagination cursor)
4. 定義 `PagingInfo` struct（hasMore、cursor） / Define `PagingInfo` struct (hasMore, cursor)
5. 實作 `Equatable`、`Sendable` / Implement `Equatable`, `Sendable`
6. 使用 `public` 修飾符 / Use `public` modifier
7. 確保完全不可變（所有屬性使用 `let`） / Ensure completely immutable (all properties use `let`)
8. 檔案結構：可放在各自的 namespace 檔案中，或建立共用的 `Models/Shared/ValueObjects.swift` / File structure: Can place in respective namespace files, or create shared `Models/Shared/ValueObjects.swift`

## 實作規範 / Implementation Guidelines

### 程式碼範例 / Code Example

```swift
extension PrematchComment {
    public enum SortMode: String, Equatable, Sendable {
        case top = "top"
        case newest = "newest"
    }
    
    public struct Cursor: Equatable, Sendable {
        public let value: Int
        
        public init(value: Int) {
            self.value = value
        }
    }
    
    public struct PagingInfo: Equatable, Sendable {
        public let cursor: Cursor?
        public let hasMore: Bool
        
        public init(cursor: Cursor?, hasMore: Bool) {
            self.cursor = cursor
            self.hasMore = hasMore
        }
    }
}

// LiveChat 使用相同的 Value Objects 或定義自己的
extension LiveChat {
    public enum SortMode: String, Equatable, Sendable {
        case top = "top"
        case newest = "newest"
    }
    
    public struct Cursor: Equatable, Sendable {
        public let value: Int
        
        public init(value: Int) {
            self.value = value
        }
    }
    
    public struct PagingInfo: Equatable, Sendable {
        public let cursor: Cursor?
        public let hasMore: Bool
        
        public init(cursor: Cursor?, hasMore: Bool) {
            self.cursor = cursor
            self.hasMore = hasMore
        }
    }
}
```

## 驗收條件 / Acceptance Criteria

- [ ] `SortMode` enum 定義完成，實作 `Equatable`、`Sendable` / `SortMode` enum definition complete, implements `Equatable`, `Sendable`
- [ ] `Cursor` struct 定義完成，實作 `Equatable`、`Sendable` / `Cursor` struct definition complete, implements `Equatable`, `Sendable`
- [ ] `PagingInfo` struct 定義完成，實作 `Equatable`、`Sendable` / `PagingInfo` struct definition complete, implements `Equatable`, `Sendable`
- [ ] 所有 Value Object 完全不可變（所有屬性使用 `let`） / All Value Objects completely immutable (all properties use `let`)
- [ ] 所有屬性使用 `public` 修飾符 / All properties use `public` modifier
- [ ] Equatable 實作正確（透過值比較） / Equatable implementation correct (compare by value)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%

## 相關文件 / Related Documents

- Domain Model 定義：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`

