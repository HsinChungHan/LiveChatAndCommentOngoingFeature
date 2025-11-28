# TDD-046: JoinChatroomUseCase

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-046 |
| **標題** | 實作 JoinChatroomUseCase |
| **類型** | UseCase |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-031 |
| **Story Point** | 13 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：5 天<br/>最嚴厲：4 天 |
| **開發日期 / Development Date** | 2025-12-12 (週五)

## 描述 / Description

實作 JoinChatroomUseCase。 / Implement JoinChatroomUseCase。

## 需求 / Requirements

1. 實作 `JoinChatroomUseCase` struct / Implement `JoinChatroomUseCase` struct
2. 定義 Input/Output Model / Define Input/Output Model
3. 整合 `LiveChatRepository` 呼叫 / Integrate `LiveChatRepository` call
4. 實作歷史訊息與 WebSocket 訊息合併邏輯 / Implement historical message and WebSocket message merge logic
5. 實作依 messageNo 去重邏輯 / Implement deduplication logic by messageNo
6. 處理無法取得 chatroomId 的情況 / Handle case when chatroomId cannot be obtained
7. 實作 Error Handling / Implement Error Handling
8. 檔案結構：`Sources/LiveChat/UseCases/JoinChatroomUseCase.swift` / File structure: `Sources/LiveChat/UseCases/JoinChatroomUseCase.swift`

## 實作規範 / Implementation Guidelines

### 程式碼範例 / Code Example

```swift
import Foundation

public struct JoinChatroomUseCase {
    private let repository: LiveChatRepository
    
    public init(repository: LiveChatRepository) {
        self.repository = repository
    }
    
    public struct Input: Equatable, Sendable {
        public let refId: String
        
        public init(refId: String) {
            self.refId = refId
        }
    }
    
    public struct Output: Equatable, Sendable {
        public let chatroomInfo: LiveChat.ChatroomInfo
        public let messages: [LiveChat.Message]
        
        public init(
            chatroomInfo: LiveChat.ChatroomInfo,
            messages: [LiveChat.Message]
        ) {
            self.chatroomInfo = chatroomInfo
            self.messages = messages
        }
    }
    
    public func execute(input: Input) async throws -> Output {
        // 1. 取得聊天室資訊
        let chatroomInfo = try await repository.getChatroomInfo(refId: input.refId)
        
        guard let chatroomId = chatroomInfo.chatroomId, !chatroomId.isEmpty else {
            throw JoinChatroomError.chatroomIdNotFound
        }
        
        // 2. 加入聊天室
        try await repository.joinChatroom(chatroomId: chatroomId)
        
        // 3. 載入歷史訊息
        let historicalMessages = try await repository.loadHistoricalMessages(
            chatroomId: chatroomId,
            lastMessageNo: chatroomInfo.lastMessageNo
        )
        
        // 4. 訂閱 WebSocket
        try await repository.subscribeWebSocket()
        
        // 5. 合併訊息（歷史訊息 + WebSocket 訊息，依 messageNo 去重）
        let mergedMessages = mergeMessages(
            historical: historicalMessages,
            webSocket: repository.getWebSocketMessages()
        )
        
        return Output(chatroomInfo: chatroomInfo, messages: mergedMessages)
    }
    
    private func mergeMessages(
        historical: [LiveChat.Message],
        webSocket: [LiveChat.Message]
    ) -> [LiveChat.Message] {
        // 合併邏輯：依 messageNo 去重，按 messageNo 排序
        var messageMap: [Int: LiveChat.Message] = [:]
        
        for message in historical {
            messageMap[message.messageNo] = message
        }
        
        for message in webSocket {
            messageMap[message.messageNo] = message
        }
        
        return messageMap.values.sorted { $0.messageNo < $1.messageNo }
    }
}
```

### 命名規範 / Naming Conventions

- UseCase 使用 `struct`，提供 `execute(input:)` 方法 / UseCase uses `struct`, provides `execute(input:)` method
- Input/Output 使用 nested `struct`，實作 `Equatable`、`Sendable` / Input/Output use nested `struct`, implement `Equatable`, `Sendable`
- 使用 `LiveChat.XXX` 命名空間 / Use `LiveChat.XXX` namespace
- 使用 `public` 修飾符 / Use `public` modifier

## 驗收條件 / Acceptance Criteria

- [ ] `JoinChatroomUseCase` 實作完成 / `JoinChatroomUseCase` implementation complete
- [ ] Input/Output Model 定義完成 / Input/Output Model definition complete
- [ ] 訊息合併邏輯實作完成 / Message merge logic implementation complete
- [ ] 去重邏輯實作完成 / Deduplication logic implementation complete
- [ ] UseCase 商業邏輯實作完成 / UseCase business logic implementation complete
- [ ] 所有 Test Scenarios 通過（Basic / Branch） / All Test Scenarios passed (Basic / Branch)
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 90% / Unit Test Coverage ≥ 90%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- UseCase 定義：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`
- Input/Output Model：`output/LiveChat&PrematchComment/07_UseCase Input & Output Model/01_usecase_input_output.md`
- Test Scenarios：`output/LiveChat&PrematchComment/10_Test Scenarios/01_test_scenarios.md`

## 調整因子說明 / 調整因子說明

- 基礎估時：複雜 UseCase = 13 SP
- +2 SP：複雜的資料合併邏輯（歷史訊息與 WebSocket 訊息合併） / - +2 SP：複雜的資料合併Logic(歷史訊息與 WebSocket 訊息合併)
- +1 SP：複雜的去重邏輯 / - +1 SP：複雜的去重Logic

