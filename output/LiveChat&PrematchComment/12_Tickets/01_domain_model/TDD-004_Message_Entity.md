# TDD-004: Message Entity

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-004 |
| **標題** | 實作 Message Entity |
| **類型** | Domain Model |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | - |
| **Story Point** | 1 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：0.3 天<br/>最嚴厲：0.2 天 |
| **開發日期 / Development Date** | 2025-11-28 (週五)

## 描述 / Description

定義 Message Entity Domain Model。 / Define Message Entity Domain Model。

## 需求 / Requirements

1. 定義 `LiveChat` namespace enum / Define `LiveChat` namespace enum
2. 在 namespace 內定義 `Message` struct / Define `Message` struct within namespace
3. 定義 `MessageType` enum（放在 `LiveChat` namespace 內） / Define `MessageType` enum (within `LiveChat` namespace)
4. 實作 `Identifiable`、`Equatable`、`Sendable` / Implement `Identifiable`, `Equatable`, `Sendable`
5. 使用 `public` 修飾符 / Use `public` modifier
6. 定義所有必要欄位 / Define all required fields
7. 檔案結構：`Sources/LiveChat/Models/LiveChat.swift` / File structure: `Sources/LiveChat/Models/LiveChat.swift`

## 實作規範 / Implementation Guidelines

### 程式碼範例 / Code Example

```swift
import Foundation

/// The namespace for types and functions related to LiveChat
public enum LiveChat {}

extension LiveChat {
    public enum MessageType: String, Equatable, Sendable {
        case text = "TEXT"
    }
    
    public struct Message: Identifiable, Equatable, Sendable {
        public let id: String
        public let content: String
        public let messageNo: Int
        public let previousMessageNo: Int
        public let authorId: String
        public let authorNickname: String?
        public let messageType: MessageType
        public let createdAt: Date
        public let chatroomId: String
        public let isIsolated: Bool
        public let isDeleted: Bool
        public let status: Int
        
        public init(
            id: String,
            content: String,
            messageNo: Int,
            previousMessageNo: Int,
            authorId: String,
            authorNickname: String?,
            messageType: MessageType,
            createdAt: Date,
            chatroomId: String,
            isIsolated: Bool,
            isDeleted: Bool,
            status: Int
        ) {
            self.id = id
            self.content = content
            self.messageNo = messageNo
            self.previousMessageNo = previousMessageNo
            self.authorId = authorId
            self.authorNickname = authorNickname
            self.messageType = messageType
            self.createdAt = createdAt
            self.chatroomId = chatroomId
            self.isIsolated = isIsolated
            self.isDeleted = isDeleted
            self.status = status
        }
        
        // Equatable: 透過 id 來比較
        public static func == (lhs: Message, rhs: Message) -> Bool {
            lhs.id == rhs.id
        }
    }
}
```

## 驗收條件 / Acceptance Criteria

- [ ] `LiveChat` namespace enum 定義完成 / `LiveChat` namespace enum definition complete
- [ ] `Message` struct 定義在 namespace extension 內 / `Message` struct defined within namespace extension
- [ ] `MessageType` enum 定義完成 / `MessageType` enum definition complete
- [ ] 所有欄位類型正確，使用 `public` 修飾符 / All field types correct, using `public` modifier
- [ ] 實作 `Identifiable`、`Equatable`、`Sendable` protocols / Implement `Identifiable`, `Equatable`, `Sendable` protocols
- [ ] Equatable 實作正確（透過 id 比較） / Equatable implementation correct (compare by id)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%

## 相關文件 / Related Documents

- Domain Model 定義：`output/LiveChat&PrematchComment/04_Domain Model/01_domain_model.md`

