# TDD-010: PrematchCommentAPI

## Ticket 資訊 / Ticket Information

| 欄位 | 值 |
|------|-----|
| **Ticket ID** | TDD-010 |
| **Jira Key** | FOOTBALL-9178 |
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
        case getBatchCommentInfo(refIdList: [String])
        case getCommentMeta(refId: String)
        case getCommentsByPopular(refId: String, pageNum: Int?, pageSize: Int?)
        case getCommentsByNewest(refId: String, prevCommentId: Int64?, pageSize: Int?)
        case getReplies(parentCommentId: Int64, prevCommentId: Int64?, pageSize: Int?)
        case publishComment(refId: String, content: String, parentId: Int64?, sharedBetsMeta: [String: AnyCodable]?, tagUserId: String?)
        case toggleLike(commentId: Int64)
        
        public var baseURL: String {
            AppConfiguration.current.environment.domain.absoluteString
        }
        
        public var path: String {
            let base = "/api/\(Region.current.apiCountryCode)/chat/match/comment"
            
            switch self {
            case .getBatchCommentInfo:
                return "\(base)/batch/info"
            case .getCommentMeta(let refId):
                return "\(base)/info/\(refId)"
            case .getCommentsByPopular:
                return "\(base)/popular"
            case .getCommentsByNewest:
                return "\(base)/newest"
            case .getReplies:
                return "\(base)/replies"
            case .publishComment:
                return "\(base)"
            case .toggleLike:
                return "\(base)/like"
            }
        }
        
        public var method: String {
            switch self {
            case .getBatchCommentInfo, .publishComment, .toggleLike:
                return FComHTTPMethod.post.rawValue
            case .getCommentMeta, .getCommentsByPopular, .getCommentsByNewest, .getReplies:
                return FComHTTPMethod.get.rawValue
            }
        }
        
        public var encoding: APIEncoding {
            switch self {
            case .getBatchCommentInfo, .publishComment, .toggleLike:
                return .json
            case .getCommentMeta, .getCommentsByPopular, .getCommentsByNewest, .getReplies:
                return .url
            }
        }
        
        public var parameters: [String: Any]? {
            switch self {
            case .getBatchCommentInfo(let refIdList):
                return ["refIdList": refIdList]
            case .getCommentMeta:
                return nil  // Path parameter only
            case .getCommentsByPopular(let refId, let pageNum, let pageSize):
                var params: [String: Any] = ["refId": refId]
                if let pageNum = pageNum {
                    params["pageNum"] = pageNum
                }
                if let pageSize = pageSize {
                    params["pageSize"] = pageSize
                }
                return params
            case .getCommentsByNewest(let refId, let prevCommentId, let pageSize):
                var params: [String: Any] = ["refId": refId]
                if let prevCommentId = prevCommentId {
                    params["prevCommentId"] = prevCommentId
                }
                if let pageSize = pageSize {
                    params["pageSize"] = pageSize
                }
                return params
            case .getReplies(let parentCommentId, let prevCommentId, let pageSize):
                var params: [String: Any] = ["parentCommentId": parentCommentId]
                if let prevCommentId = prevCommentId {
                    params["prevCommentId"] = prevCommentId
                }
                if let pageSize = pageSize {
                    params["pageSize"] = pageSize
                }
                return params
            case .publishComment(let refId, let content, let parentId, let sharedBetsMeta, let tagUserId):
                var params: [String: Any] = [
                    "refId": refId,
                    "comment": content
                ]
                if let parentId = parentId {
                    params["parentCommentId"] = parentId
                }
                if let sharedBetsMeta = sharedBetsMeta {
                    params["sharedBetsMeta"] = sharedBetsMeta
                }
                if let tagUserId = tagUserId {
                    params["tagUserId"] = tagUserId
                }
                return params
            case .toggleLike(let commentId):
                return ["commentId": commentId]
            }
        }
    }
}
```

#### PrematchCommentAPI+Models.swift
```swift
import Foundation

extension PrematchCommentAPI {
    // MARK: - Response DTOs
    
    public struct CommentMetaInfoDTO: Decodable, Sendable {
        public let refId: String
        public let commentCount: String
        public let betCount: String
    }
    
    public struct CommentMetaDataDTO: Decodable, Sendable {
        public let refId: String
        public let commentCount: String
        public let betCount: String
    }
    
    public struct CommentDTO: Decodable, Sendable {
        public let id: Int64
        public let parentId: Int64  // 0 表示第一層評論
        public let sharedBetsMeta: String?  // 共享投注資訊（自訂 JSON 格式）
        public let userId: String
        public let userNickname: String
        public let userTierLevel: String
        public let userAvatar: String
        public let countryCode: String
        public let comment: String  // 注意：API 欄位名稱是 "comment"
        public let isIsolated: Bool
        public let isDeleted: Bool
        public let likedCount: Int
        public let repliesCount: Int
        public let likedByMe: Bool
        public let createTime: Int64  // 時間戳（毫秒）
        public let tagUserId: String?
        public let tagUserNickname: String?
        
        enum CodingKeys: String, CodingKey {
            case id, parentId, sharedBetsMeta, userId, userNickname, userTierLevel
            case userAvatar, countryCode, comment, isIsolated, isDeleted
            case likedCount, repliesCount, likedByMe, createTime, tagUserId, tagUserNickname
        }
    }
    
    // MARK: - Request DTOs
    
    public struct BatchCommentInfoRequestDTO: Encodable, Sendable {
        public let refIdList: [String]
    }
    
    public struct PublishCommentRequestDTO: Encodable, Sendable {
        public let refId: String
        public let parentCommentId: Int64?  // 可選，父評論 ID（如果是回覆）
        public let sharedBetsMeta: [String: AnyCodable]?  // 可選，共享投注資訊（自訂 JSON 格式）
        public let comment: String
        public let tagUserId: String?  // 可選，被標記的用戶 ID
    }
    
    public struct ToggleLikeRequestDTO: Encodable, Sendable {
        public let commentId: Int64?
    }
    
    // MARK: - Response Wrappers
    
    public struct BatchCommentInfoResponseDTO: Decodable, Sendable {
        public let bizCode: Int
        public let innerMsg: String?
        public let message: String?
        public let data: [CommentMetaInfoDTO]
    }
    
    public struct CommentMetaResponseDTO: Decodable, Sendable {
        public let bizCode: Int
        public let innerMsg: String?
        public let message: String?
        public let data: CommentMetaDataDTO
    }
    
    public struct CommentListResponseDTO: Decodable, Sendable {
        public let bizCode: Int
        public let innerMsg: String?
        public let message: String?
        public let data: [CommentDTO]
    }
    
    public struct CommentResponseDTO: Decodable, Sendable {
        public let bizCode: Int
        public let innerMsg: String?
        public let message: String?
        public let data: CommentDTO
    }
    
    public struct ToggleLikeResponseDTO: Decodable, Sendable {
        public let bizCode: Int
        public let innerMsg: String?
        public let message: String?
        public let data: CommentDTO?  // 根據 API Docs，回應為 null，但實際可能返回更新後的 CommentDTO
    }
}
```

#### PrematchCommentAPI+RepositoryProtocol.swift
```swift
import Foundation

extension PrematchCommentAPI {
    protocol PrematchCommentRepositoryProtocol {
        func getBatchCommentInfo(refIdList: [String]) async throws -> [CommentMetaInfoDTO]
        func getCommentMeta(refId: String) async throws -> CommentMetaDataDTO
        func getCommentsByPopular(refId: String, pageNum: Int?, pageSize: Int?) async throws -> [CommentDTO]
        func getCommentsByNewest(refId: String, prevCommentId: Int64?, pageSize: Int?) async throws -> [CommentDTO]
        func getReplies(parentCommentId: Int64, prevCommentId: Int64?, pageSize: Int?) async throws -> [CommentDTO]
        func publishComment(refId: String, content: String, parentId: Int64?, sharedBetsMeta: [String: AnyCodable]?, tagUserId: String?) async throws -> CommentDTO
        func toggleLike(commentId: Int64) async throws -> CommentDTO?
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
        
        public func getBatchCommentInfo(refIdList: [String]) async throws -> [CommentMetaInfoDTO] {
            let endpoint = PrematchCommentEndpoint.getBatchCommentInfo(refIdList: refIdList)
            let response: BatchCommentInfoResponseDTO = try await apiClient.request(endpoint)
            return response.data
        }
        
        public func getCommentMeta(refId: String) async throws -> CommentMetaDataDTO {
            let endpoint = PrematchCommentEndpoint.getCommentMeta(refId: refId)
            let response: CommentMetaResponseDTO = try await apiClient.request(endpoint)
            return response.data
        }
        
        public func getCommentsByPopular(refId: String, pageNum: Int?, pageSize: Int?) async throws -> [CommentDTO] {
            let endpoint = PrematchCommentEndpoint.getCommentsByPopular(refId: refId, pageNum: pageNum, pageSize: pageSize)
            let response: CommentListResponseDTO = try await apiClient.request(endpoint)
            return response.data
        }
        
        public func getCommentsByNewest(refId: String, prevCommentId: Int64?, pageSize: Int?) async throws -> [CommentDTO] {
            let endpoint = PrematchCommentEndpoint.getCommentsByNewest(refId: refId, prevCommentId: prevCommentId, pageSize: pageSize)
            let response: CommentListResponseDTO = try await apiClient.request(endpoint)
            return response.data
        }
        
        public func getReplies(parentCommentId: Int64, prevCommentId: Int64?, pageSize: Int?) async throws -> [CommentDTO] {
            let endpoint = PrematchCommentEndpoint.getReplies(parentCommentId: parentCommentId, prevCommentId: prevCommentId, pageSize: pageSize)
            let response: CommentListResponseDTO = try await apiClient.request(endpoint)
            return response.data
        }
        
        public func publishComment(refId: String, content: String, parentId: Int64?, sharedBetsMeta: [String: AnyCodable]?, tagUserId: String?) async throws -> CommentDTO {
            let endpoint = PrematchCommentEndpoint.publishComment(refId: refId, content: content, parentId: parentId, sharedBetsMeta: sharedBetsMeta, tagUserId: tagUserId)
            let response: CommentResponseDTO = try await apiClient.request(endpoint)
            return response.data
        }
        
        public func toggleLike(commentId: Int64) async throws -> CommentDTO? {
            let endpoint = PrematchCommentEndpoint.toggleLike(commentId: commentId)
            let response: ToggleLikeResponseDTO = try await apiClient.request(endpoint)
            return response.data  // 可能為 null
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

- API Spec：`08_API Spec & Mapping/01_api_spec.md`
- Module Responsibility：`03_Module Responsibility/01_module_responsibility.md`

