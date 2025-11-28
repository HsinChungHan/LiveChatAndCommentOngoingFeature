# TDD-005: ChatroomInfo Entity

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-005 |
| **Jira Key** | FOOTBALL-9175 |
| **標題** | 實作 ChatroomInfo Entity |
| **類型** | Domain Model |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | - |
| **Story Point** | 1 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：0.3 天<br/>最嚴厲：0.2 天 |
| **開發日期 / Development Date** | 2025-11-28 (週五)

## 描述 / Description

定義 ChatroomInfo Entity Domain Model。 / Define ChatroomInfo Entity Domain Model。

## 需求 / Requirements

1. 在 `LiveChat` namespace 內定義 `ChatroomInfo` struct / Define `ChatroomInfo` struct within `LiveChat` namespace
2. 實作 `Identifiable`、`Equatable`、`Sendable` / Implement `Identifiable`, `Equatable`, `Sendable`
3. 使用 `public` 修飾符 / Use `public` modifier
4. 定義所有必要欄位 / Define all required fields
5. 檔案結構：與 `Message` 放在同一個檔案 `LiveChat.swift` / File structure: Place in same file `LiveChat.swift` as `Message`

## 實作規範 / Implementation Guidelines

### 程式碼範例 / Code Example

```swift
extension LiveChat {
    public struct ChatroomInfo: Identifiable, Equatable, Sendable {
        public let id: String
        public let chatroomId: String
        public let lastMessageNo: Int
        public let refId: String
        public let onlineCount: Int
        public let betCount: String
        public let chatRoomType: Int
        public let nickNameAvailable: Bool?
        
        public init(
            id: String,
            chatroomId: String,
            lastMessageNo: Int,
            refId: String,
            onlineCount: Int,
            betCount: String,
            chatRoomType: Int,
            nickNameAvailable: Bool?
        ) {
            self.id = id
            self.chatroomId = chatroomId
            self.lastMessageNo = lastMessageNo
            self.refId = refId
            self.onlineCount = onlineCount
            self.betCount = betCount
            self.chatRoomType = chatRoomType
            self.nickNameAvailable = nickNameAvailable
        }
        
        // Equatable: 透過 id 來比較
        public static func == (lhs: ChatroomInfo, rhs: ChatroomInfo) -> Bool {
            lhs.id == rhs.id
        }
    }
}
```

## 驗收條件 / Acceptance Criteria

- [ ] `ChatroomInfo` struct 定義在 `LiveChat` namespace extension 內 / `ChatroomInfo` struct defined within `LiveChat` namespace extension
- [ ] 所有欄位類型正確，使用 `public` 修飾符 / All field types correct, using `public` modifier
- [ ] 實作 `Identifiable`、`Equatable`、`Sendable` protocols / Implement `Identifiable`, `Equatable`, `Sendable` protocols
- [ ] Equatable 實作正確（透過 id 比較） / Equatable implementation correct (compare by id)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%

## 相關文件 / Related Documents

- Domain Model 定義：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`

