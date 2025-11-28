# TDD-047: LeaveChatroomUseCase

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-047 |
| **標題** | 實作 LeaveChatroomUseCase |
| **類型** | UseCase |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-031 |
| **Story Point** | 5 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：2 天<br/>最嚴厲：1 天 |
| **開發日期 / Development Date** | 2025-12-15 (週一)

## 描述 / Description

實作 LeaveChatroomUseCase。 / Implement LeaveChatroomUseCase。

## 需求 / Requirements

1. 實作 `LeaveChatroomUseCase` struct / Implement `LeaveChatroomUseCase` struct
2. 定義 Input/Output Model / Define Input/Output Model
3. 整合 `LiveChatRepository` 呼叫 / Integrate `LiveChatRepository` call
4. 實作清除快取訊息的邏輯 / Implement clear cached messages logic
5. 實作黑名單檢查與清理邏輯（4 小時自動清理） / Implement blacklist check and cleanup logic (auto cleanup after 4 hours)
6. 實作 Error Handling / Implement Error Handling
7. 檔案結構：`Sources/LiveChat/UseCases/LeaveChatroomUseCase.swift` / File structure: `Sources/LiveChat/UseCases/LeaveChatroomUseCase.swift`

## 實作規範 / Implementation Guidelines

### 程式碼範例 / Code Example

```swift
import Foundation

public struct LeaveChatroomUseCase {
    private let repository: LiveChatRepository
    
    public init(repository: LiveChatRepository) {
        self.repository = repository
    }
    
    public struct Input: Equatable, Sendable {
        public let chatroomId: String
        
        public init(chatroomId: String) {
            self.chatroomId = chatroomId
        }
    }
    
    public struct Output: Equatable, Sendable {
        public init() {}
    }
    
    public func execute(input: Input) async throws -> Output {
        // 1. 取消訂閱 WebSocket
        try await repository.unsubscribeWebSocket()
        
        // 2. 離開聊天室
        try await repository.leaveChatroom(chatroomId: input.chatroomId)
        
        // 3. 清除快取訊息
        repository.clearCachedMessages(chatroomId: input.chatroomId)
        
        // 4. 檢查並清理黑名單（4 小時自動清理）
        try await repository.checkAndCleanBlacklist()
        
        return Output()
    }
}
```

### 命名規範 / Naming Conventions

- UseCase 使用 `struct`，提供 `execute(input:)` 方法 / UseCase uses `struct`, provides `execute(input:)` method
- Input/Output 使用 nested `struct`，實作 `Equatable`、`Sendable` / Input/Output use nested `struct`, implement `Equatable`, `Sendable`
- 使用 `LiveChat.XXX` 命名空間 / Use `LiveChat.XXX` namespace
- 使用 `public` 修飾符 / Use `public` modifier

## 驗收條件 / Acceptance Criteria

- [ ] `LeaveChatroomUseCase` 實作完成 / `LeaveChatroomUseCase` implementation complete
- [ ] Input/Output Model 定義完成 / Input/Output Model definition complete
- [ ] 清除快取邏輯實作完成 / Clear cache logic implementation complete
- [ ] 黑名單清理邏輯實作完成 / Blacklist cleanup logic implementation complete
- [ ] UseCase 商業邏輯實作完成 / UseCase business logic implementation complete
- [ ] 所有 Test Scenarios 通過（Basic / Branch） / All Test Scenarios passed (Basic / Branch)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 90% / Unit Test Coverage ≥ 90%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- UseCase 定義：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Input/Output Model：`output/LiveChat&PrematchComment/07_UseCase Input & Output Model/01_usecase_input_output.md`
- Test Scenarios：`output/LiveChat&PrematchComment/10_Test Scenarios/01_test_scenarios.md`

