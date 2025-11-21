# 發送聊天訊息流程

## Flow 資訊

| 欄位 | 值 |
|------|-----|
| **feature** | LiveChat |
| **flow_id** | LC-SUB-001 |
| **flow_type** | Sub |
| **flow_name** | 用戶留 comment 時登入與 nickname 檢查 |
| **parent_flow_id** | LC-FULL-001 |
| **parent_flow_name** | 用戶進入與離開聊天室（含 WebSocket 相依） |
| **original_annotation** | @flow: Sub |

## 模組說明

| 模組名稱 | 職責 |
|---------|------|
| **LiveDetailView** | 直播詳情頁面 |
| **LiveChatFeature** | TCA Reducer，管理聊天室相關的 State 和 Action |
| **SendChatMessageUseCase** | 發送聊天訊息 |
| **LiveChatRepository** | Domain 資料來源的抽象介面（聊天室相關） |
| **LiveChatClient** | HTTP 通訊（聊天室相關） |
| **ChatAPI** | 後端 endpoint 定義（聊天室相關） |
| **PersonalPage Package (External)** | 登入流程（外部 Package） |
| **FComSharedFlow Package (External)** | Nickname 建立流程（外部 Package） |

## 流程說明

| 流程步驟 | 說明 |
|---------|------|
| **1. 點擊輸入框與登入檢查** | 1. 用戶點擊輸入框準備輸入留言<br>2. 檢查登入狀態<br>3. 未登入則跳轉到 PersonalPage 完成登入 |
| **2. 輸入並送出留言** | 1. 用戶輸入並送出 Chat<br>2. 檢查 nickname 是否存在 |
| **3. 有 nickname 時發送** | 1. 已有 nickname，直接送出留言<br>2. 顯示新留言 |
| **4. 無 nickname 時發送** | 1. 調用 FComSharedFlow Package 建立 nickname<br>2. 建立成功後送出留言<br>3. 顯示 Chat 在最新的位置並 highlight 3 秒 |

## 場景序列圖（原始業務流程）

以下為原始業務流程的序列圖，展示從業務角度的完整流程：

```mermaid
sequenceDiagram
    autonumber
    actor User
    box rgb(255, 248, 220) App
        participant LiveChat as LiveChat Package
        participant MainApp as Main App
        participant PersonalPage as PersonalPage Package(external)
        participant FComSharedFlow as FComSharedFlow Package(external)
    end
    participant Chat as Server

    %% 使用者點擊輸入框 → 先做登入檢查
    User->>LiveChat: 點擊輸入框（準備輸入 Chat）
    note over LiveChat: 點擊輸入框時觸發登入檢查
    LiveChat->>MainApp: APICoordinator.shared.accountManager 檢查登入狀態

    alt [使用者已登入]
        MainApp-->>LiveChat: 已登入
        note over LiveChat: 已登入，允許輸入留言
    else [使用者未登入]
        MainApp-->>LiveChat: 未登入
        LiveChat->>MainApp: route(to: .personalPage)
        MainApp->>PersonalPage: 跳轉到 PersonalPage
        PersonalPage->>PersonalPage: 完成 user 登入流程
        PersonalPage-->>LiveChat: 登入成功（回跳至原頁面）
        note over LiveChat: 登入完成後可再次點擊輸入框繼續流程
    end

    %% 使用者輸入並送出 Comment/Reply
    User->>LiveChat: 輸入並送出 Chat

    %% nickname 檢查（透過 Main App 的 accountManager）
    note over LiveChat: 送出前檢查 client 端 nickname 是否存在
    LiveChat->>MainApp: APICoordinator.shared.accountManager.currentMetadata?.nickname 檢查

    alt [nickname 存在]
        MainApp-->>LiveChat: nickname 存在
        note over LiveChat: 已有 nickname，直接送出 Chat
        LiveChat->>Chat: POST /chat/match/comment { refId, content, parentId? }

        alt [留言成功]
            Chat-->>LiveChat: 201 Created（回傳 comment 資料）
            LiveChat-->>User: 顯示新留言
        else [留言失敗]
            Chat-->>LiveChat: 4xx/5xx Error（留言失敗）
            LiveChat-->>User: 顯示錯誤 Toast（留言失敗）
        end

    else [nickname 不存在]
        MainApp-->>LiveChat: nickname 不存在
        note over LiveChat: 需使用 FComSharedFlow Package 建立 nickname
        
        %% App 端 nickname 建立流程（透過 FComSharedFlow Package）
        LiveChat->>FComSharedFlow: 調用 CreatNickName API
        FComSharedFlow-->>User: 顯示 create nickName pop-up
        User->>FComSharedFlow: 使用者輸入 nickname
        FComSharedFlow->>FComSharedFlow: FComSharedFlow Package 建立 nickname
        FComSharedFlow-->>LiveChat: nickname 建立成功

        LiveChat->>Chat: POST /chat/{matchId}/message { content, messageType: TEXT }

        alt [留言成功]
            Chat-->>LiveChat: 201 Created
            LiveChat-->>User: 顯示 Chat 在最新的位置，並 highlight 3 秒
        else [留言失敗]
            Chat-->>LiveChat: 4xx/5xx Error（留言失敗）
            LiveChat-->>User: 顯示錯誤 Toast（留言失敗）
        end
    end
```

## 模組序列圖（架構設計）

以下為轉換後的模組序列圖，展示 Clean Architecture 各層級的互動：

```mermaid
sequenceDiagram
    autonumber
    actor User
    box rgb(207,232,255) UI Layer
        participant LiveDetailView
    end
    box rgb(255,250,205) Domain Layer
        participant LiveChatFeature
        participant SendChatMessageUseCase
    end
    box rgb(240,240,240) Data & Infrastructure Layer
        participant LiveChatRepository
        participant LiveChatClient
        participant ChatAPI
    end
    participant PersonalPagePackage as PersonalPage Package (External)
    participant FComSharedFlowPackage as FComSharedFlow Package (External)
    participant Server

    Note over User,LiveDetailView: 用戶點擊輸入框
    User->>LiveDetailView: 點擊輸入框
    LiveDetailView->>LiveChatFeature: tapInputField
    LiveChatFeature->>LiveChatFeature: 檢查登入狀態（透過 Main App）
    alt 使用者已登入
        LiveChatFeature->>LiveChatFeature: 已登入，允許輸入留言
    else 使用者未登入
        LiveChatFeature->>PersonalPagePackage: route(to: .personalPage)
        PersonalPagePackage->>PersonalPagePackage: 完成 user 登入流程
        PersonalPagePackage-->>LiveChatFeature: 登入成功（回跳至原頁面）
    end

    Note over User,LiveDetailView: 用戶輸入並送出 Chat
    User->>LiveDetailView: 輸入並送出 Chat
    LiveDetailView->>LiveChatFeature: sendMessage(content: String)
    LiveChatFeature->>SendChatMessageUseCase: execute(input: SendChatMessageInput)
    SendChatMessageUseCase->>SendChatMessageUseCase: 檢查 nickname（透過 Main App）
    alt nickname 存在
        SendChatMessageUseCase->>LiveChatRepository: sendMessage(chatroomId: String, content: String, messageType: MessageType)
        LiveChatRepository->>LiveChatClient: sendMessage(chatroomId: String, content: String, messageType: MessageType)
        LiveChatClient->>ChatAPI: POST /chat/match/comment
        ChatAPI->>Server: POST /chat/match/comment { refId, content, parentId? }
        alt 留言成功
            Server-->>ChatAPI: 201 Created（回傳 comment 資料）
            ChatAPI-->>LiveChatClient: Message DTO
            LiveChatClient-->>LiveChatRepository: Message DTO
            LiveChatRepository-->>SendChatMessageUseCase: Message Entity
            SendChatMessageUseCase-->>LiveChatFeature: Output(message: Message)
            LiveChatFeature-->>LiveDetailView: 更新 State
            LiveDetailView-->>User: 顯示新留言
        else 留言失敗
            Server-->>ChatAPI: 4xx/5xx Error
            ChatAPI-->>LiveChatClient: Error
            LiveChatClient-->>LiveChatRepository: Error
            LiveChatRepository-->>SendChatMessageUseCase: Error
            SendChatMessageUseCase-->>LiveChatFeature: Output(error: Error)
            LiveChatFeature-->>LiveDetailView: 更新 State
            LiveDetailView-->>User: 顯示錯誤 Toast
        end
    else nickname 不存在
        SendChatMessageUseCase->>FComSharedFlowPackage: CreatNickName API
        FComSharedFlowPackage-->>User: 顯示 create nickName pop-up
        User->>FComSharedFlowPackage: 使用者輸入 nickname
        FComSharedFlowPackage->>FComSharedFlowPackage: FComSharedFlow Package 建立 nickname
        FComSharedFlowPackage-->>SendChatMessageUseCase: nickname 建立成功
        SendChatMessageUseCase->>LiveChatRepository: sendMessage(chatroomId: String, content: String, messageType: MessageType)
        LiveChatRepository->>LiveChatClient: sendMessage(chatroomId: String, content: String, messageType: MessageType)
        LiveChatClient->>ChatAPI: POST /chat/{matchId}/message
        ChatAPI->>Server: POST /chat/{matchId}/message { content, messageType: TEXT }
        alt 留言成功
            Server-->>ChatAPI: 201 Created
            ChatAPI-->>LiveChatClient: Message DTO
            LiveChatClient-->>LiveChatRepository: Message DTO
            LiveChatRepository-->>SendChatMessageUseCase: Message Entity
            SendChatMessageUseCase-->>LiveChatFeature: Output(message: Message)
            LiveChatFeature-->>LiveDetailView: 更新 State
            LiveDetailView-->>User: 顯示 Chat 在最新的位置，並 highlight 3 秒
        else 留言失敗
            Server-->>ChatAPI: 4xx/5xx Error
            ChatAPI-->>LiveChatClient: Error
            LiveChatClient-->>LiveChatRepository: Error
            LiveChatRepository-->>SendChatMessageUseCase: Error
            SendChatMessageUseCase-->>LiveChatFeature: Output(error: Error)
            LiveChatFeature-->>LiveDetailView: 更新 State
            LiveDetailView-->>User: 顯示錯誤 Toast
        end
    end
```

