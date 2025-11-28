# TDD-003: UserInfo Entity

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-003 |
| **Jira Key** | FOOTBALL-9173 |
| **標題** | 實作 UserInfo Entity |
| **類型** | Domain Model |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat & PrematchComment |
| **依賴 Ticket** | - |
| **Story Point** | 1 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：0.3 天<br/>最嚴厲：0.2 天 |
| **開發日期 / Development Date** | 2025-11-27 (週四)

## 描述 / Description

定義 UserInfo Entity Domain Model。 / Define UserInfo Entity Domain Model。

## 需求 / Requirements

1. 定義 `LiveChat` 和 `PrematchComment` namespace enum（共用） / Define `LiveChat` and `PrematchComment` namespace enum (shared)
2. 在 namespace 內定義 `UserInfo` struct / Define `UserInfo` struct within namespace
3. 實作 `Identifiable`、`Equatable`、`Sendable` / Implement `Identifiable`, `Equatable`, `Sendable`
4. 使用 `public` 修飾符 / Use `public` modifier
5. 定義所有必要欄位（id、nickname、avatar、tierLevel、countryCode） / Define all required fields (id, nickname, avatar, tierLevel, countryCode)
6. 檔案結構：可放在 `PrematchComment.swift` 或 `LiveChat.swift`，或建立共用的 `Models/Shared/UserInfo.swift` / File structure: Can place in `PrematchComment.swift` or `LiveChat.swift`, or create shared `Models/Shared/UserInfo.swift`

## 實作規範 / Implementation Guidelines

### 程式碼範例 / Code Example

```swift
// 選項 1: 放在 PrematchComment namespace
extension PrematchComment {
    public struct UserInfo: Identifiable, Equatable, Sendable {
        public let id: String
        public let nickname: String?
        public let avatar: String?
        public let tierLevel: String?
        public let countryCode: String?
        
        public init(
            id: String,
            nickname: String?,
            avatar: String?,
            tierLevel: String?,
            countryCode: String?
        ) {
            self.id = id
            self.nickname = nickname
            self.avatar = avatar
            self.tierLevel = tierLevel
            self.countryCode = countryCode
        }
        
        // Equatable: 透過 id 來比較
        public static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
            lhs.id == rhs.id
        }
    }
}

// 選項 2: 放在 LiveChat namespace（相同結構）
extension LiveChat {
    public struct UserInfo: Identifiable, Equatable, Sendable {
        // 相同結構...
    }
}
```

## 驗收條件 / Acceptance Criteria

- [ ] `UserInfo` struct 定義在 namespace extension 內 / `UserInfo` struct defined within namespace extension
- [ ] 所有欄位類型正確，使用 `public` 修飾符 / All field types correct, using `public` modifier
- [ ] 實作 `Identifiable`、`Equatable`、`Sendable` protocols / Implement `Identifiable`, `Equatable`, `Sendable` protocols
- [ ] Equatable 實作正確（透過 id 比較） / Equatable implementation correct (compare by id)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%

## 相關文件 / Related Documents

- Domain Model 定義：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`

