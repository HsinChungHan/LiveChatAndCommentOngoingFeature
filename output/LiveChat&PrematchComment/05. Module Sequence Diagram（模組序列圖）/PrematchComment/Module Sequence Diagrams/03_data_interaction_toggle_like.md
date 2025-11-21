# 切換 Like 狀態流程

## Flow 資訊

| 欄位 | 值 |
|------|-----|
| **feature** | PrematchComment |
| **flow_id** | PC-SUB-004 |
| **flow_type** | Sub |
| **flow_name** | 用戶點擊 Like（含登入檢查） |
| **parent_flow_id** | PC-FULL-001 |
| **parent_flow_name** | 用戶進入 Upcoming Race Page, Prematch Comment Page 與 Top |
| **original_annotation** | @flow: Sub |

## 模組說明

| 模組名稱 | 職責 |
|---------|------|
| **PrematchCommentView** | 賽前留言頁面 |
| **PrematchCommentFeature** | TCA Reducer，管理評論相關的 State 和 Action |
| **ToggleLikeUseCase** | 切換 Like 狀態（Optimistic UI） |
| **PrematchCommentRepository** | Domain 資料來源的抽象介面（評論相關） |
| **PrematchCommentClient** | HTTP 通訊（評論相關） |
| **PrematchCommentAPI** | 後端 endpoint 定義（評論相關） |
| **PersonalPage Package (External)** | 登入流程（外部 Package） |

## 流程說明

| 流程步驟 | 說明 |
|---------|------|
| **1. 點擊 Like 按鈕** | 1. 用戶點擊留言的 Like 按鈕<br>2. 檢查登入狀態<br>3. 未登入則跳轉到 PersonalPage 完成登入 |
| **2. Optimistic UI 更新** | 1. 通過登入檢查後立即更新畫面上的 Like 數<br>2. 顯示已點讚狀態 + Like +1 |
| **3. 同步 Like 狀態** | 1. 向伺服器發送 Like 請求<br>2. 同步 Like 狀態到伺服器 |

## 場景序列圖（原始業務流程）

以下為原始業務流程的序列圖，展示從業務角度的完整流程：

```mermaid
sequenceDiagram
    autonumber
    actor User
    box rgb(255, 248, 220) App
        participant PrematchComment as PrematchComment Package
        participant MainApp as Main App
        participant PersonalPage as PersonalPage Package(external)
        participant FComSharedFlow as FComSharedFlow Package(external)
    end
    participant Chat as Chat API Server
    
    User->>PrematchComment: 點擊 Like 按鈕
    note over PrematchComment: 點擊 Like 按鈕時觸發登入檢查
    PrematchComment->>MainApp: APICoordinator.shared.accountManager 檢查登入狀態
    
    alt [使用者已登入]
        MainApp-->>PrematchComment: 已登入
        note over PrematchComment: 通過登入檢查
    else [使用者未登入]
        MainApp-->>PrematchComment: 未登入
        PrematchComment->>MainApp: route(to: .personalPage)
        MainApp->>PersonalPage: 跳轉到 PersonalPage
        PersonalPage->>PersonalPage: 完成 user 登入流程
        PersonalPage-->>PrematchComment: 登入成功（回跳至原頁面）
    end
    
    note over PrematchComment: 立即更新畫面上的 Like 數（Optimistic UI）
    PrematchComment-->>User: 顯示已點讚狀態 + Like +1
    PrematchComment->>Chat: POST /chat/match/comment/like { commentId }
    Chat-->>PrematchComment: 200 OK（更新成功）
```

## 模組序列圖（架構設計）

以下為轉換後的模組序列圖，展示 Clean Architecture 各層級的互動：

```mermaid
sequenceDiagram
    autonumber
    actor User
    box rgb(207,232,255) UI Layer
        participant PrematchCommentView
    end
    box rgb(255,250,205) Domain Layer
        participant PrematchCommentFeature
        participant ToggleLikeUseCase
    end
    box rgb(240,240,240) Data & Infrastructure Layer
        participant PrematchCommentRepository
        participant PrematchCommentClient
        participant PrematchCommentAPI
    end
    participant PersonalPagePackage as PersonalPage Package (External)
    participant Server

    Note over User,PrematchCommentView: 用戶點擊 Like 按鈕
    User->>PrematchCommentView: 點擊 Like 按鈕
    PrematchCommentView->>PrematchCommentFeature: toggleLike(commentId: String)
    PrematchCommentFeature->>PrematchCommentFeature: 檢查登入狀態（透過 Main App）
    alt 使用者已登入
        PrematchCommentFeature->>PrematchCommentFeature: 通過登入檢查
        PrematchCommentFeature->>PrematchCommentFeature: 立即更新畫面上的 Like 數（Optimistic UI）
        PrematchCommentFeature-->>PrematchCommentView: 更新 State
        PrematchCommentView-->>User: 顯示已點讚狀態 + Like +1
        PrematchCommentFeature->>ToggleLikeUseCase: execute(input: ToggleLikeInput)
        ToggleLikeUseCase->>PrematchCommentRepository: toggleLike(commentId: String)
        PrematchCommentRepository->>PrematchCommentClient: toggleLike(commentId: String)
        PrematchCommentClient->>PrematchCommentAPI: POST /chat/match/comment/like
        PrematchCommentAPI->>Server: POST /chat/match/comment/like { commentId }
        Server-->>PrematchCommentAPI: 200 OK（更新成功）
        PrematchCommentAPI-->>PrematchCommentClient: Comment DTO
        PrematchCommentClient-->>PrematchCommentRepository: Comment DTO
        PrematchCommentRepository-->>ToggleLikeUseCase: Comment Entity
        ToggleLikeUseCase-->>PrematchCommentFeature: Output(comment: Comment)
        PrematchCommentFeature-->>PrematchCommentView: 更新 State
    else 使用者未登入
        PrematchCommentFeature->>PersonalPagePackage: route(to: .personalPage)
        PersonalPagePackage->>PersonalPagePackage: 完成 user 登入流程
        PersonalPagePackage-->>PrematchCommentFeature: 登入成功（回跳至原頁面）
    end
```

