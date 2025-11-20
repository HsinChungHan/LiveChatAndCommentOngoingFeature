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