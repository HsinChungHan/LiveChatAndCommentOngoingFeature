# TDD-021: LiveChatClient

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-021 |
| **Jira Key** | FOOTBALL-9182 |
| **標題** | 實作 LiveChatClient（HTTP） |
| **類型** | Client |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-011 |
| **Story Point** | 3 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：1 天<br/>最嚴厲：1 天 |
| **開發日期 / Development Date** | 2025-12-02 (週二)

## 描述 / Description

實作 LiveChatClient（HTTP）。 / Implement LiveChatClient(HTTP)。

## 需求 / Requirements

1. 實作 `LiveChatClient`（使用 `APIClient`） / Implement `LiveChatClient` (using `APIClient`)
2. 整合 `ChatAPI.ChatRepository` / Integrate `ChatAPI.ChatRepository`
3. 實作 Error Handling / Implement Error Handling
4. 檔案結構：`Sources/LiveChat/Services/API/LiveChatClient.swift` / File structure: `Sources/LiveChat/Services/API/LiveChatClient.swift`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/LiveChat/Services/API/
  └── LiveChatClient.swift
```

### 程式碼範例 / Code Example

```swift
import Foundation
import NetworkService

public struct LiveChatClient {
    private let apiRepository: ChatAPI.ChatRepository
    
    public init(apiRepository: ChatAPI.ChatRepository = ChatAPI.ChatRepository()) {
        self.apiRepository = apiRepository
    }
    
    /// 批量獲取聊天室計數
    public func getBatchCount(refIdList: [String]) async throws -> [ChatAPI.ChatRoomCountDTO] {
        return try await apiRepository.getBatchCount(refIdList: refIdList)
    }
    
    /// 獲取或創建聊天室資訊
    public func getChatroomInfo(refId: String, userId: String?) async throws -> ChatAPI.ChatroomInfoDataDTO {
        return try await apiRepository.getChatroomInfo(refId: refId, userId: userId)
    }
    
    /// 獲取歷史消息
    public func getHistoricalMessages(chatroomId: String, messageNo: Int, length: Int?) async throws -> [ChatAPI.MessageDTO] {
        return try await apiRepository.getHistoricalMessages(chatroomId: chatroomId, messageNo: messageNo, length: length)
    }
    
    /// 發送消息
    public func sendMessage(chatroomId: String, text: String) async throws -> ChatAPI.MessageResponseDataDTO {
        return try await apiRepository.sendMessage(chatroomId: chatroomId, text: text)
    }
    
    /// 加入聊天室（可選操作）
    public func joinChatroom(chatroomId: String) async throws {
        _ = try await apiRepository.joinChatroom(chatroomId: chatroomId)
    }
    
    /// 離開聊天室（可選操作）
    public func leaveChatroom(chatroomId: String) async throws {
        _ = try await apiRepository.leaveChatroom(chatroomId: chatroomId)
    }
    
    /// 批量強制離開聊天室（可選操作）
    public func bulkLeaveChatroom(chatroomId: String, excludeUserIds: [String]?) async throws {
        _ = try await apiRepository.bulkLeaveChatroom(chatroomId: chatroomId, excludeUserIds: excludeUserIds)
    }
}
```

### 命名規範 / Naming Conventions

- Client 使用 `struct`，提供公開方法 / Client uses `struct`, provides public methods
- 內部使用 `ChatAPI.ChatRepository` / Internally uses `ChatAPI.ChatRepository`
- 方法直接委派給 Repository / Methods delegate directly to Repository
- 使用 `public` 修飾符 / Use `public` modifier

## 驗收條件 / Acceptance Criteria

- [ ] `LiveChatClient` 實作完成 / `LiveChatClient` implementation complete
- [ ] 所有 HTTP API 呼叫方法實作完成 / All HTTP API call methods implementation complete
- [ ] Error Handling 實作完成 / Error Handling implementation complete
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- API Spec：`08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`03_Module Responsibility/01_module_responsibility.md`

