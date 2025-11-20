```mermaid
sequenceDiagram
    autonumber
    actor User
    participant MainApp as Main App

    User->>MainApp: 點擊使用者名稱及 Avatar

    MainApp->>MainApp: UIViewController+routeToDestination.route(to destination: .personal)
    note over MainApp: 透過 routeToDestination 跳轉到 User Profile Page
    MainApp-->>User: 顯示該使用者的個人主頁畫面
```