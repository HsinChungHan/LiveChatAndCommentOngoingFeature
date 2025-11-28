# Overview 章節說明

本目錄包含 TDD 文件的 Overview 章節，提供整體 Feature 組合的描述和說明。

## 文件列表

- `01_overview.md` - 整體 Feature 組合概述

## 資料來源

本 TDD 文件基於以下 Input 資料生成：

- **Input 路徑**: `Input/LiveChat&PrematchComment/`
- **Feature 列表**:
  - **LiveChat**: 4 個流程
    - LC-FULL-001: 用戶進入與離開聊天室（含 WebSocket 相依）
    - LC-SUB-001: 用戶留 comment 時登入與 nickname 檢查
    - LC-SUB-002: 用戶點擊 avatar 與封鎖其他 user 邏輯
    - LC-SUB-003: 聊天室訊息傳遞與滾動加載
  - **PrematchComment**: 7 個流程
    - PC-FULL-001: 用戶進入 Upcoming Race Page, Prematch Comment Page 與 Top
    - PC-SUB-001: Event Status 訂閱與通知流程
    - PC-SUB-002: 用戶發 Comment - Reply（含登入與 nickname 檢查）
    - PC-SUB-003: 用戶查看 replies（含分頁載入）
    - PC-SUB-004: 用戶點擊 Like（含登入檢查）
    - PC-SUB-005: 用戶點擊用戶名稱 → 跳轉個人主頁
    - PC-SUB-006: User 從 In-Site message 跳轉到 Prematch Comment Page（待確認）

