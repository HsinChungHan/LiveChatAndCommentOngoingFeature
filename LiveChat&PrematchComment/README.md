# LiveChat & PrematchComment TDD

本目錄包含 LiveChat 和 PrematchComment Feature 的完整 TDD（Technical Design Document）文件。

## 本地預覽

使用 MkDocs 本地預覽：

```bash
# 安裝依賴
pip install -r ../../requirements.txt

# 啟動本地伺服器
mkdocs serve
```

然後在瀏覽器中開啟 `http://127.0.0.1:8000` 即可預覽。

## 部署

本 TDD 文件使用 MkDocs 生成，並可部署到 GitHub Pages。

### 自動部署

當推送到 `main` 分支時，GitHub Actions 會自動部署到 GitHub Pages。

### 手動部署

```bash
# 建置網站
mkdocs build

# 部署到 GitHub Pages
mkdocs gh-deploy
```

## 文件結構

- `00_Overview/` - 整體概述
- `01_Integrated Service-Level Sequence Diagram/` - 整合服務層級序列圖
- `02_Architecture/` - 架構圖
- `03_Module Responsibility/` - 模組職責說明
- `04_Domain Model/` - Domain Model 定義
- `05. Module Sequence Diagram（模組序列圖）/` - 模組序列圖
- `06_Feature State & Action (TCA)/` - Feature State 和 Action 定義
- `07_UseCase Input & Output Model/` - UseCase Input/Output Model
- `08_API Spec & Mapping/` - API 規格和 Mapping
- `09_Error Handling/` - 錯誤處理策略
- `10_Test Scenarios/` - 測試場景
- `11_Risks & Questions/` - 風險和問題
- `12_Tickets/` - 開發 Tickets
- `13_Implementation_Status/` - 實作狀態追蹤（確保 TDD 與 codebase 同步）
- `14_Changelog/` - 變更日誌（記錄每日 code change）
- `15_Daily_Logs/` - 工作日誌（記錄每日開發工作）
- `16_Cursor_Workflow/` - Cursor 工作流程（與 Cursor AI 協作的完整流程）

## 開發工作流程

為了確保 TDD 與 codebase 保持同步，建議使用以下工作流程：

### 1. 實作狀態追蹤 (`13_Implementation_Status/`)

- 追蹤每個 TDD Ticket 的實作狀態
- 記錄實作檔案路徑和完成日期
- 定期檢查實作與 TDD 的一致性

### 2. 變更日誌 (`14_Changelog/`)

- 記錄每日的 code change 和新增內容
- 對應到相關的 TDD ticket
- 追蹤 Bug 修復、重構、文件更新等

### 3. 工作日誌 (`15_Daily_Logs/`)

- 記錄每日的開發工作
- 包含計劃、完成項目、遇到的問題、學習反思等
- 使用腳本快速建立：`./scripts/create_daily_log.sh [日期]`

### 4. Cursor 工作流程 (`16_Cursor_Workflow/`)

- 根據日期自動生成當天工作計劃（包含 Jira parent/child tickets）
- 記錄與 Cursor 的重要對話
- 每天結束時統整工作（包含與 Cursor 的對話）
- 詳細工作流程請參考：`16_Cursor_Workflow/WORKFLOW_GUIDE.md`

### 與 Cursor 協作

#### 每天開始時
```bash
# 生成今天的工作計劃（自動找出對應的 Jira tickets）
./scripts/generate_daily_plan.sh

# 建立工作日誌
./scripts/create_daily_log.sh
```

然後與 Cursor 說：
```
根據今天的工作計劃（16_Cursor_Workflow/daily_plans/YYYY-MM-DD.md），
請協助我：
1. 讀取相關的 TDD 文件
2. 檢查現有的 codebase 結構
3. 提供實作建議和注意事項
4. 檢查依賴關係是否滿足
```

#### 每天結束時
```bash
# 統整今天的工作（包含與 Cursor 的對話）
./scripts/summarize_daily_work.sh
```

然後與 Cursor 說：
```
請幫我統整今天的工作：
1. 根據今天的 git commits 生成變更記錄
2. 更新 implementation_status.md
3. 更新 CHANGELOG.md
4. 檢查實作與 TDD 的一致性
5. 統整今天與你的對話，提取重要決策和學習要點
6. 生成明天的計劃建議
```

