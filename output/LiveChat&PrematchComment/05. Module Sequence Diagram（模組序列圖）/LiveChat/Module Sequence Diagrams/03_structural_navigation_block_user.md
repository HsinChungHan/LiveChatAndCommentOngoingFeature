# 封鎖用戶流程

## Flow 資訊

| 欄位 | 值 |
|------|-----|
| **feature** | LiveChat |
| **flow_id** | LC-SUB-002 |
| **flow_type** | Sub |
| **flow_name** | 用戶點擊 avatar 與封鎖其他 user 邏輯 |
| **parent_flow_id** | LC-FULL-001 |
| **parent_flow_name** | 用戶進入與離開聊天室（含 WebSocket 相依） |
| **original_annotation** | @flow: Sub |

## 模組說明

| 模組名稱 | 職責 |
|---------|------|
| **LiveDetailView** | 直播詳情頁面 |
| **LiveChatFeature** | TCA Reducer，管理聊天室相關的 State 和 Action |
| **BlockUserUseCase** | 處理封鎖用戶的邏輯 |
| **LiveChatRepository** | Domain 資料來源的抽象介面（聊天室相關） |

## 流程說明

| 流程步驟 | 說明 |
|---------|------|
| **1. 點擊用戶名稱** | 1. 用戶點擊聊天室中其他用戶的名稱<br>2. 顯示操作選單（含「個人主頁」「Block this user」） |
| **2. 封鎖用戶** | 1. 用戶選擇「Block this user」<br>2. 顯示確認彈窗<br>3. 確認後 Feature 呼叫 BlockUserUseCase<br>4. UseCase 將該用戶加入黑名單 DB<br>5. WebSocket 重連後同步 blocked user 清單 |
| **3. 黑名單清理** | 1. 用戶關閉聊天室時執行黑名單檢查<br>2. 比較黑名單紀錄的加入時間與當前時間<br>3. 若超過 4 小時則自動移除黑名單紀錄 |

## 場景序列圖（原始業務流程）

以下為原始業務流程的序列圖，展示從業務角度的完整流程：

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant LiveChat as LiveChat Package
    participant MainApp as Main App
    participant Chat as Chat API Server

    %% 使用者點擊使用者名稱
    User->>LiveChat: 點擊使用者名稱
    LiveChat-->>User: 顯示底部彈窗（含「個人主頁」「Block this user」）

    alt 1️⃣ 跳轉個人主頁
        User->>LiveChat: 點擊 Go to Profile
        LiveChat->>MainApp: UIViewController+routeToDestination.route(to destination: .personal)
        note over MainApp: 透過 routeToDestination 跳轉到 User Profile Page
        MainApp-->>User: 顯示該使用者的個人主頁畫面

    else 2️⃣ 封鎖使用者
        User->>LiveChat: 點擊 Block this user
        LiveChat-->>User: 顯示確認彈窗
        User->>LiveChat: 點擊確認封鎖

        %% 加入黑名單
        LiveChat->>LiveChat: 將該 User 加入黑名單 DB (userID, eventID, timestamp)

        %% websocket 行為
        LiveChat->>Chat: websocket 重連後同步 blocked user 清單
    end

    %% 使用者關閉 Chatroom
    User->>LiveChat: 關閉聊天室（退出 Chatroom）
    LiveChat->>LiveChat: 執行黑名單檢查與清理

    %% 四小時清除邏輯
    LiveChat->>LiveChat: 比較黑名單紀錄的加入時間與當前時間
    LiveChat->>LiveChat: 若超過 4 小時 → 自動移除黑名單紀錄
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
        participant BlockUserUseCase
    end
    box rgb(240,240,240) Data & Infrastructure Layer
        participant LiveChatRepository
    end

    Note over User,LiveDetailView: 用戶點擊用戶名稱
    User->>LiveDetailView: 點擊使用者名稱
    LiveDetailView->>LiveChatFeature: tapUserName(userId: String)
    LiveChatFeature-->>LiveDetailView: 顯示底部彈窗
    LiveDetailView-->>User: 顯示底部彈窗（含「個人主頁」「Block this user」）

    Note over User,LiveDetailView: 用戶選擇封鎖使用者
    User->>LiveDetailView: 點擊 Block this user
    LiveDetailView->>LiveChatFeature: blockUser(userId: String)
    LiveChatFeature-->>LiveDetailView: 顯示確認彈窗
    LiveDetailView-->>User: 顯示確認彈窗
    User->>LiveDetailView: 點擊確認封鎖
    LiveDetailView->>LiveChatFeature: confirmBlockUser(userId: String)
    LiveChatFeature->>BlockUserUseCase: execute(input: BlockUserInput)
    BlockUserUseCase->>LiveChatRepository: addToBlacklist(userId: String, eventId: String, timestamp: Date)
    LiveChatRepository->>LiveChatRepository: 將該 User 加入黑名單 DB (userID, eventID, timestamp)
    LiveChatRepository-->>BlockUserUseCase: Success
    BlockUserUseCase->>BlockUserUseCase: websocket 重連後同步 blocked user 清單
    BlockUserUseCase-->>LiveChatFeature: Output()
    LiveChatFeature-->>LiveDetailView: 更新 State

    Note over User,LiveDetailView: 用戶關閉聊天室時的黑名單清理邏輯
    Note over User,LiveDetailView: 請參考 01_data_initialization_initialize_chatroom.md 中的 LeaveChatroomUseCase 流程
```

