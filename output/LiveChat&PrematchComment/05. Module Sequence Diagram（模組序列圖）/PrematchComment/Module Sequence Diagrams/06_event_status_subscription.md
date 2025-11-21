# Event Status 訂閱與通知流程

## Flow 資訊

| 欄位 | 值 |
|------|-----|
| **feature** | PrematchComment |
| **flow_id** | PC-SUB-001 |
| **flow_type** | Sub |
| **flow_name** | Event Status 訂閱與通知流程 |
| **parent_flow_id** | PC-FULL-001 |
| **parent_flow_name** | 用戶進入 Upcoming Race Page, Prematch Comment Page 與 Top |
| **original_annotation** | @flow: Sub |

## 模組說明

| 模組名稱 | 職責 |
|---------|------|
| **PrematchCommentView** | 賽前留言頁面 |
| **PrematchCommentFeature** | TCA Reducer，管理評論相關的 State 和 Action |
| **FactsCenter Package (External)** | Event Status 訂閱與通知（外部 Package） |

## 流程說明

| 流程步驟 | 說明 |
|---------|------|
| **1. Event Status 訂閱** | 1. 用戶進入 Race Detail Page<br>2. FactsCenter Package（外部）自動透過 WebSocket 訂閱 Event Status |
| **2. Event Status 變更通知** | 1. Prematch Comment Page 處於開啟狀態<br>2. Server 推送 EventStatusChanged 事件<br>3. FactsCenter Package 透過 interface 通知 PrematchCommentFeature |
| **3. 處理通知** | 1. 若 event status 有改變，且為 match_started：自動關閉 Prematch Comment Page，導回 Race Detail Page<br>2. 若 event status 沒有改變：APP 維持原畫面 |

## 場景序列圖（原始業務流程）

以下為原始業務流程的序列圖，展示從業務角度的完整流程：

```mermaid
sequenceDiagram
    autonumber
    actor User
    box rgb(255, 248, 220) App
        participant LiveChat as LiveChat Package
        participant FactsCenter as FactsCenter Package(external)
    end
    participant Server as Server

    %% Event status 訂閱（在進入 Race Detail Page 時）
    note over User,LiveChat: 用戶進入 Race Detail Page
    FactsCenter->>Server: WebSocket 訂閱 Event Status
    note over FactsCenter,Server: FactsCenter Package 透過 WebSocket 向 Server 訂閱 Event Status

    %% Event status 變化時，自動關閉 Prematch Comment Page
    note over User,LiveChat: Prematch Comment Page 處於開啟狀態（需先進入 Race Detail Page）
    Server-->>FactsCenter: EventStatusChanged
    FactsCenter->>LiveChat: eventStatus(didChange status: Int)
    note over FactsCenter,LiveChat: FactsCenter Package 透過 interface 通知 LiveChat Package
    alt [若 event status 有改變，且為 match_started]
        LiveChat->>User: 關閉 Prematch Comment Page（導回 Race Detail Page）
        note over LiveChat: 下次再打開 Chat Room 時，會是 match ongoing 的 chat room
    else [若 event status 沒有改變]
        note over LiveChat: APP 維持原畫面
    end
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
    end
    participant FactsCenterPackage as FactsCenter Package (External)
    participant Server

    Note over User,PrematchCommentView: 用戶進入 Race Detail Page
    User->>PrematchCommentView: 進入 Race Detail Page
    FactsCenterPackage->>Server: WebSocket 訂閱 Event Status
    Note over FactsCenterPackage: 外部 Package，內部實作不在此 TDD 範圍內

    Note over User,PrematchCommentView: Prematch Comment Page 處於開啟狀態
    Note over User,PrematchCommentView: Event Status 變更通知
    Server-->>FactsCenterPackage: EventStatusChanged
    FactsCenterPackage->>PrematchCommentFeature: eventStatus(didChange status: Int)
    Note over FactsCenterPackage,PrematchCommentFeature: FactsCenter Package 透過 interface 通知 PrematchCommentFeature
    alt 若 event status 有改變，且為 match_started
        PrematchCommentFeature->>PrematchCommentView: 關閉 Prematch Comment Page
        PrematchCommentView-->>User: 導回 Race Detail Page
        Note over PrematchCommentFeature: 下次再打開 Chat Room 時，會是 match ongoing 的 chat room
    else 若 event status 沒有改變
        PrematchCommentFeature->>PrematchCommentFeature: APP 維持原畫面
    end
```

