# 會議議程

本文檔記錄本次會議的討論議程。

---

## 📋 議程內容

### 1. 討論 Feature 的 Architecture Section

**討論重點**：

- Clean Architecture 分層架構
- Feature 架構圖
- Shared Modules 架構
- External Package 整合架構

**相關文件**：

- [Architecture Section](./02_Architecture/01_clean_architecture_diagram.md)

---

### 2. 討論 Feature 的 Module Sequence Diagram Section

**討論重點**：

- 模組互動序列圖
- 按功能分類組織（Data Initialization、Data Interaction、Structural Navigation）

**相關文件**：

- [Module Sequence Diagram Section - LiveChat](./05.%20Module%20Sequence%20Diagram（模組序列圖）/LiveChat/Module%20Sequence%20Diagrams/)
- [Module Sequence Diagram Section - PrematchComment](./05.%20Module%20Sequence%20Diagram（模組序列圖）/PrematchComment/Module%20Sequence%20Diagrams/)

#### 2-1. 當 event status 發生變化

**討論重點**：

- Event Status 訂閱與通知流程
- WebSocket 訂閱機制
- 跨 Package 通訊

**相關文件**：

- [Event Status 訂閱與通知流程](./05.%20Module%20Sequence%20Diagram（模組序列圖）/PrematchComment/Module%20Sequence%20Diagrams/06_event_status_subscription.md)

---

#### 2-2. 確認用戶是否登入、用戶創建 nickName、用戶點擊 avatar 後跳轉到 User Profile Page

**討論重點**：

- 登入檢查流程
- Nickname 建立流程
- 用戶頭像點擊跳轉流程

**相關文件**：

- [聊天室訊息傳遞與滾動加載](./05.%20Module%20Sequence%20Diagram（模組序列圖）/LiveChat/Module%20Sequence%20Diagrams/02_data_interaction_send_message.md)（登入與 nickname 檢查）
- [跳轉個人主頁流程 - LiveChat](./05.%20Module%20Sequence%20Diagram（模組序列圖）/LiveChat/Module%20Sequence%20Diagrams/04_structural_navigation_profile.md)
- [跳轉個人主頁流程 - PrematchComment](./05.%20Module%20Sequence%20Diagram（模組序列圖）/PrematchComment/Module%20Sequence%20Diagrams/05_structural_navigation_profile.md)

---

#### 2-3. 用戶從 In-Site Message 跳轉到 Match Detail Page 後開啟 Prematch Comment Page

**討論重點**：

- In-Site Message 跳轉流程
- Prematch Comment Page 初始化流程

**相關文件**：

- [User 從 In-Site message 跳轉到 Prematch Comment Page](./05.%20Module%20Sequence%20Diagram（模組序列圖）/PrematchComment/Module%20Sequence%20Diagrams/01_data_initialization_refresh.md)

---

### 3. 快速介紹 TDD 生成的工作流程

**介紹重點**：

- 完整流程總覽（階段 0-5）
- Client Side RD 工作流程
- AI 自動化生成流程
- 總估時總結

**相關文件**：

- [TDD 生成工作流程](./01_TDD_生成工作流程.md)

---

### 4. 快速介紹各角色文件規範

**介紹重點**：

- PM（Product Manager）需提供的文件
- BE（Backend Engineer）需提供的文件
- Designer（UI/UX Designer）需提供的文件
- Client Side RD 需提供的文件
- 文件範本與檢查清單

**相關文件**：

- [各角色文件規範](./02_各角色文件規範.md)

---

## 📝 會議記錄

（會議記錄將在此處填寫）

---

**會議日期**：2024-11-21  
**最後更新**：2024-11-21

