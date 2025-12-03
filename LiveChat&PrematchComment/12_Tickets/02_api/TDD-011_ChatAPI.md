# TDD-011: ChatAPI

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-011 |
| **Jira Key** | FOOTBALL-9179 |
| **標題** | 實作 ChatAPI 定義 |
| **類型** | API |
| **優先級** | P0 |
| **所屬 Feature** | LiveChat |
| **依賴 Ticket** | TDD-004, TDD-005 |
| **Story Point** | 5 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：2 天<br/>最嚴厲：1 天 |
| **開發日期 / Development Date** | 2025-12-01 (週一)

## 描述 / Description

實作 ChatAPI API 定義（包含 HTTP 和 WebSocket）。 / Implement ChatAPI API 定義(包含 HTTP 和 WebSocket)。

## 需求 / Requirements

1. 定義 `ChatAPI` namespace enum / Define `ChatAPI` namespace enum
2. 使用 extension 分離關注點 / Use extension to separate concerns:
   - `ChatAPI.swift` - namespace 定義 / namespace definition
   - `ChatAPI+Endpoint.swift` - HTTP Endpoint 定義 / HTTP Endpoint definition
   - `ChatAPI+Models.swift` - API Models 定義 / API Models definition
   - `ChatAPI+WebSocket.swift` - WebSocket 端點和訊息格式 / WebSocket endpoint and message format
   - `ChatAPI+RepositoryProtocol.swift` - Repository Protocol / Repository Protocol
   - `ChatAPI+Repository.swift` - Repository 實作（使用 actor） / Repository implementation (using actor)
3. 定義所有 HTTP Endpoints / Define all HTTP Endpoints
4. 定義 WebSocket 端點和訊息格式 / Define WebSocket endpoint and message format
5. Endpoints：
   - `POST /chat/match/batch/count`
   - `GET /chat/match/{refId}`
   - `GET /chat/match/backward`
   - `POST /chat/match/message`（僅支援 TEXT 類型）
   - `POST /chat/match/join`（可選操作）
   - `POST /chat/match/leave`（可選操作）
   - `POST /chat/match/leave/bulk`（可選操作，批量強制離開）
   - `wss://{domain}/chat/websocket/web-chat`（WebSocket）

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/LiveChat/Services/API/Chat/
  ├── ChatAPI.swift                    # namespace 定義
  ├── ChatAPI+Endpoint.swift           # HTTP Endpoint 定義
  ├── ChatAPI+Models.swift             # API Models 定義
  ├── ChatAPI+WebSocket.swift         # WebSocket 端點和訊息格式
  ├── ChatAPI+RepositoryProtocol.swift # Repository Protocol
  └── ChatAPI+Repository.swift        # Repository 實作（actor）
```

### 程式碼範例 / Code Examples

#### ChatAPI+Endpoint.swift
```swift
import Foundation
import NetworkService
import NetworkUtils
import SportyFoundation

extension ChatAPI {
    public enum ChatEndpoint: APIEndpoint {
        case getBatchCount(refIdList: [String])
        case getChatroomInfo(refId: String, userId: String?)
        case getHistoricalMessages(chatroomId: String, messageNo: Int, length: Int?)
        case sendMessage(chatroomId: String, text: String)
        case joinChatroom(chatroomId: String)
        case leaveChatroom(chatroomId: String)
        case bulkLeaveChatroom(chatroomId: String, excludeUserIds: [String]?)
        
        public var baseURL: String {
            AppConfiguration.current.environment.domain.absoluteString
        }
        
        public var path: String {
            let base = "/api/\(Region.current.apiCountryCode)/chat/match"
            
            switch self {
            case .getBatchCount:
                return "\(base)/batch/count"
            case .getChatroomInfo(let refId, _):
                return "\(base)/\(refId)"
            case .getHistoricalMessages:
                return "\(base)/backward"
            case .sendMessage:
                return "\(base)/message"
            case .joinChatroom:
                return "\(base)/join"
            case .leaveChatroom:
                return "\(base)/leave"
            case .bulkLeaveChatroom:
                return "\(base)/leave/bulk"
            }
        }
        
        public var method: String {
            switch self {
            case .getBatchCount, .getChatroomInfo, .getHistoricalMessages:
                return FComHTTPMethod.get.rawValue
            case .sendMessage, .joinChatroom, .leaveChatroom, .bulkLeaveChatroom:
                return FComHTTPMethod.post.rawValue
            }
        }
        
        public var encoding: APIEncoding {
            switch self {
            case .getBatchCount, .getChatroomInfo, .getHistoricalMessages:
                return .url
            case .sendMessage, .joinChatroom, .leaveChatroom, .bulkLeaveChatroom:
                return .json
            }
        }
        
        public var parameters: [String: Any]? {
            switch self {
            case .getBatchCount(let refIdList):
                return ["refIdList": refIdList]
            case .getChatroomInfo(let refId, let userId):
                var params: [String: Any] = ["refId": refId]
                if let userId = userId {
                    params["userId"] = userId
                }
                return params
            case .getHistoricalMessages(let chatroomId, let messageNo, let length):
                var params: [String: Any] = [
                    "chatRoomId": chatroomId,
                    "messageNo": messageNo
                ]
                if let length = length {
                    params["length"] = length
                }
                return params
            case .sendMessage(let chatroomId, let text):
                return [
                    "chatRoomId": chatroomId,
                    "text": text,
                    "messageType": "TEXT"
                ]
            case .joinChatroom(let chatroomId):
                return ["chatRoomId": chatroomId]
            case .leaveChatroom(let chatroomId):
                return ["chatRoomId": chatroomId]
            case .bulkLeaveChatroom(let chatroomId, let excludeUserIds):
                var params: [String: Any] = ["chatRoomId": chatroomId]
                if let excludeUserIds = excludeUserIds {
                    params["excludeUserIds"] = excludeUserIds
                }
                return params
            }
        }
    }
}
```

#### ChatAPI+WebSocket.swift
```swift
import Foundation

extension ChatAPI {
    /// WebSocket endpoint for real-time chat messages
    public struct WebSocketEndpoint {
        /// WebSocket URL
        /// - Parameter domain: WebSocket domain (e.g., "www.encorebet.net")
        /// - Returns: WebSocket URL
        public static func url(for domain: String) -> URL? {
            URL(string: "wss://\(domain)/chat/websocket/web-chat")
        }
        
        /// STOMP subscription destination
        /// - Parameter chatroomId: Chat room ID
        /// - Returns: STOMP destination (e.g., "/topic/chat_room.{chatroomId}")
        public static func subscribeDestination(chatroomId: String) -> String {
            "/topic/chat_room.\(chatroomId)"
        }
    }
    
    /// WebSocket message DTO
    public struct WebSocketMessageDTO: Codable, Sendable {
        public let type: String  // "MESSAGE"
        public let data: MessageResponseDataDTO  // 與 POST /chat/match/message 的 Response 格式相同
        
        enum CodingKeys: String, CodingKey {
            case type, data
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
            data = try container.decodeIfPresent(MessageResponseDataDTO.self, forKey: .data) ?? .dummy
        }
    }
}
```

**WebSocket 規格說明**：

1. **Connect Headers**：
   - `Platform: ios`
   - `App-Version: {version}`
   - `Device-Id: {deviceId}`
   - `userId: {userId}`

2. **Subscribe Headers**：
   - `x-queue-name: {chatRoomId}`

3. **Message Types (msgType)**：
   - `1`: TEXT 消息
   - `4`: JSON 消息（投注分享等）
   - `5`: GIF 消息

4. **Unsubscribe Format**：
   ```
   UNSUBSCRIBE
   id:{subscriptionId}
   ```

詳細規格請參考：`08_API Spec & Mapping/01_api_spec.md`

### 命名規範 / Naming Conventions

- 使用 `ChatAPI` 作為 namespace enum / Use `ChatAPI` as namespace enum
- HTTP Endpoint 使用 `ChatEndpoint` enum，實作 `APIEndpoint` protocol / HTTP Endpoint uses `ChatEndpoint` enum, implements `APIEndpoint` protocol
- WebSocket 相關定義在 `ChatAPI+WebSocket.swift` / WebSocket related definitions in `ChatAPI+WebSocket.swift`
- API Models 使用 `XXXDTO` 命名，實作 `Decodable`、`Sendable` / API Models use `XXXDTO` naming, implement `Decodable`, `Sendable`
- Repository 使用 `actor`，實作 `ChatRepositoryProtocol` / Repository uses `actor`, implements `ChatRepositoryProtocol`

## 驗收條件 / Acceptance Criteria

- [ ] `ChatAPI` namespace enum 定義完成 / `ChatAPI` namespace enum definition complete
- [ ] 所有檔案結構符合參考代碼風格（使用 extension 分離） / All file structure matches reference code style (using extension separation)
- [ ] 所有 HTTP Endpoints 定義完成 / All HTTP Endpoints definition complete
- [ ] WebSocket 端點和訊息格式定義完成 / WebSocket endpoint and message format definition complete
- [ ] Request/Response DTO 定義完成，實作 `Decodable`、`Sendable` / Request/Response DTO definition complete, implements `Decodable`, `Sendable`
- [ ] Repository 使用 `actor` 實作 / Repository uses `actor` implementation
- [ ] Repository Protocol 定義完成 / Repository Protocol definition complete
- [ ] Error Response 格式定義完成 / Error Response format definition complete

## 相關文件 / Related Documents

- API Spec：`08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`03_Module Responsibility/01_module_responsibility.md`

## 調整因子說明 / 調整因子說明

- +2 SP：WebSocket API（複雜度較高） / - +2 SP：WebSocket API(複雜度較高)

