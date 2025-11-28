# TDD-022: ChatWebSocketClient

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-022 |
| **Jira Key** | FOOTBALL-9183 |
| **標題** | 實作 ChatWebSocketClient（WebSocket） |
| **類型** | Client |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-011 |
| **Story Point** | 13 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：5 天<br/>最嚴厲：3 天 |
| **開發日期 / Development Date** | 2025-12-03 (週三)

## 描述 / Description

實作 ChatWebSocketClient（WebSocket）。 / Implement ChatWebSocketClient(WebSocket)。

## 需求 / Requirements

1. 實作 `ChatWebSocketClient`（使用 WebSocket 框架） / Implement `ChatWebSocketClient` (using WebSocket framework)
2. 實作連線管理（重連、心跳等） / Implement connection management (reconnect, heartbeat, etc.)
3. 實作訂閱 / 取消訂閱 / Implement subscribe / unsubscribe
4. 實作訊息接收與發送 / Implement message receive and send
5. 實作指數退避重連策略 / Implement exponential backoff reconnect strategy
6. 檔案結構：`Sources/LiveChat/Services/API/ChatWebSocketClient.swift` / File structure: `Sources/LiveChat/Services/API/ChatWebSocketClient.swift`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/LiveChat/Services/API/
  └── ChatWebSocketClient.swift
```

### 程式碼範例 / Code Example

```swift
import Foundation

public actor ChatWebSocketClient {
    private var webSocket: WebSocketConnection?
    private var reconnectTask: Task<Void, Never>?
    private var heartbeatTask: Task<Void, Never>?
    
    public init() {}
    
    public func connect(url: URL) async throws {
        // WebSocket 連線邏輯
    }
    
    public func disconnect() async {
        // WebSocket 斷線邏輯
    }
    
    public func send(message: ChatAPI.WebSocketMessage) async throws {
        // 發送訊息邏輯
    }
    
    public func subscribe(onMessage: @escaping (ChatAPI.WebSocketMessage) -> Void) {
        // 訂閱訊息邏輯
    }
    
    private func reconnect() async {
        // 重連邏輯（指數退避）
    }
    
    private func startHeartbeat() {
        // 心跳邏輯
    }
}
```

### 命名規範 / Naming Conventions

- WebSocket Client 使用 `actor`，確保線程安全 / WebSocket Client uses `actor`, ensures thread safety
- 使用 `public` 修飾符 / Use `public` modifier
- 實作連線、斷線、發送、訂閱等方法 / Implement connect, disconnect, send, subscribe methods

## 驗收條件 / Acceptance Criteria

- [ ] `ChatWebSocketClient` 實作完成，使用 `actor` / `ChatWebSocketClient` implementation complete, using `actor`
- [ ] WebSocket 連線管理實作完成 / WebSocket connection management implementation complete
- [ ] 訂閱 / 取消訂閱實作完成 / Subscribe / unsubscribe implementation complete
- [ ] 訊息接收與發送實作完成 / Message receive and send implementation complete
- [ ] 重連機制實作完成（指數退避） / Reconnect mechanism implementation complete (exponential backoff)
- [ ] 心跳機制實作完成 / Heartbeat mechanism implementation complete
- [ ] 檔案結構符合參考代碼風格 / File structure matches reference code style
- [ ] Unit Test 覆蓋率 ≥ 80% / Unit Test Coverage ≥ 80%
- [ ] Integration Test 通過 / Integration Test Passed

## 相關文件 / Related Documents

- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`

## 調整因子說明 / 調整因子說明

- 基礎估時：複雜 Client = 8 SP
- +3 SP：WebSocket
- +2 SP：複雜 Reconnect 邏輯 / - +2 SP：複雜 Reconnect Logic

