# Cursor 工作流命令

本目錄包含 MatchChat feature 開發的常用 Cursor 命令。

## 📋 命令列表

### 每天開始時

1. **daily-start** - 開始今天的工作
   - 生成工作計劃
   - 建立工作日誌
   - 提供實作建議

2. **generate-daily-plan** - 生成今天的工作計劃
   - 根據日期找出對應的 Jira tickets
   - 生成工作計劃文件

3. **create-daily-log** - 建立今天的工作日誌
   - 使用預設模板建立工作日誌

### 每天結束時

4. **daily-end** - 結束今天的工作
   - 統整當天工作
   - 更新實作狀態
   - 更新變更日誌
   - 統整對話

5. **summarize-daily-work** - 統整當天工作
   - 生成工作統整文件

### 部署與發布

6. **deploy-tdd-to-mkdocs** - 部署 TDD 到 MkDocs
   - 建置 MkDocs 文檔
   - 部署到 GitHub Pages (gh-pages branch)
   - 顯示部署狀態和網站 URL
   - 包含對話統整模板

6. **review-cursor-conversations** - 統整對話
   - 提取重要決策
   - 提取學習要點
   - 生成對話摘要

### 實作過程中

7. **update-implementation-status** - 更新實作狀態
   - 檢查實作進度
   - 更新狀態追蹤表
   - 檢查 TDD 一致性

8. **update-changelog** - 更新變更日誌
   - 根據 git commits 生成變更記錄
   - 更新 CHANGELOG.md

9. **check-tdd-consistency** - 檢查 TDD 一致性
   - 檢查實作檔案是否存在
   - 檢查是否符合 TDD 規範
   - 提供改進建議

## 🚀 快速使用

### 每天開始時
在 Cursor 中說：「開始今天的工作」或執行 `daily-start` 命令

### 每天結束時
在 Cursor 中說：「結束今天的工作」或執行 `daily-end` 命令

### 實作過程中
- 「更新實作狀態」- 更新狀態追蹤
- 「更新變更日誌」- 更新變更記錄
- 「檢查 TDD 一致性」- 檢查實作與 TDD 的一致性

## 📁 相關文件

### 本目錄文件
- **工作流程指南**: `WORKFLOW_GUIDE.md` - 完整流程圖和使用時機說明
- **快速參考**: `QUICK_REFERENCE.md` - 命令快速參考表

### TDD 目錄文件
- 工作流程指南: `/Users/reedhsin/Documents/codebase/fcom-iOS/TDDs/LiveChat&PrematchComment/16_Cursor_Workflow/WORKFLOW_GUIDE.md`
- 快速開始: `/Users/reedhsin/Documents/codebase/fcom-iOS/TDDs/LiveChat&PrematchComment/16_Cursor_Workflow/QUICK_START.md`

