# TDD-010: PrematchCommentAPI

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-010 |
| **標題** | 實作 PrematchCommentAPI 定義 |
| **類型** | API |
| **優先級** | P0 |
| **所屬 Feature** | PrematchComment |
| **依賴 Ticket** | TDD-001, TDD-002, TDD-006 |
| **Story Point** | 3 |
| **估時（Senior iOS Engineer + AI 輔助）** | 標準：1 天<br/>最嚴厲：1 天 |
| **開發日期 / Development Date** | 2025-12-01 (週一)

## 描述 / Description

實作 PrematchCommentAPI API 定義。 / Implement PrematchCommentAPI API 定義。

## 需求 / Requirements

1. 定義 `PrematchCommentAPI` namespace enum / Define `PrematchCommentAPI` namespace enum
2. 使用 extension 分離關注點 / Use extension to separate concerns:
   - `PrematchCommentAPI.swift` - namespace 定義 / namespace definition
   - `PrematchCommentAPI+Endpoint.swift` - Endpoint 定義 / Endpoint definition
   - `PrematchCommentAPI+Models.swift` - API Models 定義 / API Models definition
   - `PrematchCommentAPI+RepositoryProtocol.swift` - Repository Protocol / Repository Protocol
   - `PrematchCommentAPI+Repository.swift` - Repository 實作（使用 actor） / Repository implementation (using actor)
3. 定義所有 Endpoints（URL、Method、Request/Response DTO） / Define All Endpoints (URL, Method, Request/Response DTO)
4. 定義 Error Response 格式 / Define Error Response format
5. Endpoints：
   - `POST /chat/match/comment/batch/info`
   - `GET /chat/match/comment/info/{refId}`
   - `GET /chat/match/comment/popular`
   - `GET /chat/match/comment/newest`
   - `GET /chat/match/comment/replies`
   - `POST /chat/match/comment`
   - `POST /chat/match/comment/like`

## 實作規範 / Implementation Guidelines

### 檔案結構 / File Structure

```
Sources/PrematchComment/Services/API/PrematchComment/
  ├── PrematchCommentAPI.swift                    # namespace 定義
  ├── PrematchCommentAPI+Endpoint.swift           # Endpoint 定義
  ├── PrematchCommentAPI+Models.swift             # API Models 定義
  ├── PrematchCommentAPI+RepositoryProtocol.swift # Repository Protocol
  └── PrematchCommentAPI+Repository.swift        # Repository 實作（actor）
```

### 程式碼範例 / Code Examples

#### PrematchCommentAPI.swift
```swift
/// The namespace for types and functions related to PrematchCommentAPI
public enum PrematchCommentAPI {}
```

#### PrematchCommentAPI+Endpoint.swift
```swift
import Foundation
import NetworkService
import NetworkUtils
import SportyFoundation

extension PrematchCommentAPI {
    public enum PrematchCommentEndpoint: APIEndpoint {
        case getCommentMeta(refId: String)
        case getComments(refId: String, mode: String, cursor: Int?)
        case publishComment(refId: String, content: String, parentId: String?)
        case toggleLike(commentId: String)
        case getReplies(commentId: String, cursor: Int?)
        
        public var baseURL: String {
            AppConfiguration.current.environment.domain.absoluteString
        }
        
        public var path: String {
            let base = "/api/\(Region.current.apiCountryCode)/chat/match/comment"
            
            switch self {
            case .getCommentMeta:
                return "\(base)/batch/info"
            case .getComments:
                return "\(base)/info/{refId}"
            case .publishComment:
                return "\(base)"
            case .toggleLike:
                return "\(base)/like"
            case .getReplies:
                return "\(base)/replies"
            }
        }
        
        public var method: String {
            switch self {
            case .getCommentMeta, .getComments, .getReplies:
                return FComHTTPMethod.get.rawValue
            case .publishComment, .toggleLike:
                return FComHTTPMethod.post.rawValue
            }
        }
        
        public var encoding: APIEncoding {
            switch self {
            case .getCommentMeta, .getComments, .getReplies:
                return .url
            case .publishComment, .toggleLike:
                return .json
            }
        }
        
        public var parameters: [String: Any]? {
            switch self {
            case .getCommentMeta(let refId):
                return ["refId": refId]
            case .getComments(let refId, let mode, let cursor):
                var params: [String: Any] = ["refId": refId, "mode": mode]
                if let cursor = cursor {
                    params["cursor"] = cursor
                }
                return params
            case .publishComment(let refId, let content, let parentId):
                var params: [String: Any] = ["refId": refId, "content": content]
                if let parentId = parentId {
                    params["parentId"] = parentId
                }
                return params
            case .toggleLike(let commentId):
                return ["commentId": commentId]
            case .getReplies(let commentId, let cursor):
                var params: [String: Any] = ["commentId": commentId]
                if let cursor = cursor {
                    params["cursor"] = cursor
                }
                return params
            }
        }
    }
}
```

#### PrematchCommentAPI+Models.swift
```swift
import Foundation

extension PrematchCommentAPI {
    public struct CommentDTO: Decodable, Sendable {
        public let id: Int64
        public let content: String
        public let likeCount: Int
        public let authorId: String
        public let authorNickname: String?
        public let parentId: Int64
        public let createdAt: Int64
        public let repliesCount: Int
        public let likedByMe: Bool
        public let isIsolated: Bool
        public let isDeleted: Bool
        
        enum CodingKeys: String, CodingKey {
            case id, content, likeCount, authorId, authorNickname, parentId
            case createdAt, repliesCount, likedByMe, isIsolated, isDeleted
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int64.self, forKey: .id)
            content = try container.decode(String.self, forKey: .content)
            likeCount = try container.decode(Int.self, forKey: .likeCount)
            authorId = try container.decode(String.self, forKey: .authorId)
            authorNickname = try container.decodeIfPresent(String.self, forKey: .authorNickname)
            parentId = try container.decode(Int64.self, forKey: .parentId)
            createdAt = try container.decode(Int64.self, forKey: .createdAt)
            repliesCount = try container.decodeIfPresent(Int.self, forKey: .repliesCount) ?? 0
            likedByMe = try container.decodeIfPresent(Bool.self, forKey: .likedByMe) ?? false
            isIsolated = try container.decodeIfPresent(Bool.self, forKey: .isIsolated) ?? false
            isDeleted = try container.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
        }
    }
    
    // 其他 DTO 定義...
}
```

#### PrematchCommentAPI+RepositoryProtocol.swift
```swift
import Foundation

extension PrematchCommentAPI {
    protocol PrematchCommentRepositoryProtocol {
        func getCommentMeta(refId: String) async throws -> PrematchCommentAPI.CommentMetaDTO
        func getComments(refId: String, mode: String, cursor: Int?) async throws -> PrematchCommentAPI.CommentPageDTO
        func publishComment(refId: String, content: String, parentId: String?) async throws -> PrematchCommentAPI.CommentDTO
        func toggleLike(commentId: String) async throws -> PrematchCommentAPI.CommentDTO
        func getReplies(commentId: String, cursor: Int?) async throws -> PrematchCommentAPI.CommentPageDTO
    }
}
```

#### PrematchCommentAPI+Repository.swift
```swift
import Foundation
import NetworkService

extension PrematchCommentAPI {
    public actor PrematchCommentRepository: PrematchCommentRepositoryProtocol {
        private let apiClient: APIClient
        
        public init(apiClient: APIClient = APIClient.shared) {
            self.apiClient = apiClient
        }
        
        public func getCommentMeta(refId: String) async throws -> PrematchCommentAPI.CommentMetaDTO {
            let endpoint = PrematchCommentEndpoint.getCommentMeta(refId: refId)
            return try await apiClient.request(endpoint)
        }
        
        public func getComments(refId: String, mode: String, cursor: Int?) async throws -> PrematchCommentAPI.CommentPageDTO {
            let endpoint = PrematchCommentEndpoint.getComments(refId: refId, mode: mode, cursor: cursor)
            return try await apiClient.request(endpoint)
        }
        
        public func publishComment(refId: String, content: String, parentId: String?) async throws -> PrematchCommentAPI.CommentDTO {
            let endpoint = PrematchCommentEndpoint.publishComment(refId: refId, content: content, parentId: parentId)
            return try await apiClient.request(endpoint)
        }
        
        public func toggleLike(commentId: String) async throws -> PrematchCommentAPI.CommentDTO {
            let endpoint = PrematchCommentEndpoint.toggleLike(commentId: commentId)
            return try await apiClient.request(endpoint)
        }
        
        public func getReplies(commentId: String, cursor: Int?) async throws -> PrematchCommentAPI.CommentPageDTO {
            let endpoint = PrematchCommentEndpoint.getReplies(commentId: commentId, cursor: cursor)
            return try await apiClient.request(endpoint)
        }
    }
}
```

### 命名規範 / Naming Conventions

- 使用 `PrematchCommentAPI` 作為 namespace enum / Use `PrematchCommentAPI` as namespace enum
- Endpoint 使用 `PrematchCommentEndpoint` enum，實作 `APIEndpoint` protocol / Endpoint uses `PrematchCommentEndpoint` enum, implements `APIEndpoint` protocol
- API Models 使用 `XXXDTO` 命名，實作 `Decodable`、`Sendable` / API Models use `XXXDTO` naming, implement `Decodable`, `Sendable`
- Repository 使用 `actor`，實作 `PrematchCommentRepositoryProtocol` / Repository uses `actor`, implements `PrematchCommentRepositoryProtocol`
- 使用 extension 分離關注點 / Use extension to separate concerns

## 驗收條件 / Acceptance Criteria

- [ ] `PrematchCommentAPI` namespace enum 定義完成 / `PrematchCommentAPI` namespace enum definition complete
- [ ] 所有檔案結構符合參考代碼風格（使用 extension 分離） / All file structure matches reference code style (using extension separation)
- [ ] 所有 Endpoints 定義完成 / All Endpoints definition complete
- [ ] Request/Response DTO 定義完成，實作 `Decodable`、`Sendable` / Request/Response DTO definition complete, implements `Decodable`, `Sendable`
- [ ] Repository 使用 `actor` 實作 / Repository uses `actor` implementation
- [ ] Repository Protocol 定義完成 / Repository Protocol definition complete
- [ ] Error Response 格式定義完成 / Error Response format definition complete

## 相關文件 / Related Documents

- API Spec：`output/LiveChat&PrematchComment/08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`output/LiveChat&PrematchComment/03_Module Responsibility/01_module_responsibility.md`

