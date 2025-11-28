# Feature State & Action (TCA)

本目錄包含所有 Feature 的 TCA State 和 Action 定義。

## 文件列表

- `01_feature_state_action.md` - PrematchComment 和 LiveChat Feature 的 State 和 Action 定義

## 說明

本章節定義了所有 Feature 的 TCA（The Composable Architecture）State 和 Action，包括：

- **State**：UI 需要的所有狀態（列表資料、loading flag、error、pagination cursor 等）
- **Action**：使用者互動、Lifecycle 事件、系統事件、UseCase 回傳等

所有 State 必須使用 Domain Model，不得使用 DTO。

