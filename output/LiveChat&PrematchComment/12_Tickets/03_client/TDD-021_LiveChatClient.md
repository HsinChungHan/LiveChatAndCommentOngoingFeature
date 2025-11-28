# TDD-021: LiveChatClient

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-021 |
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
    
    public func getChatroomInfo(refId: String) async throws -> ChatAPI.ChatroomInfoDTO {
        return try await apiRepository.getChatroomInfo(refId: refId)
    }
    
    // 其他方法...
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

- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`

