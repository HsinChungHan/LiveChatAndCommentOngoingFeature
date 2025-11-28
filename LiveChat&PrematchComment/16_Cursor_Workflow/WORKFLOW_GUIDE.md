# Cursor 工作流程完整指南

本指南說明如何與 Cursor AI 協作，進行 MatchChat feature 的開發。

## 📅 每天開始時的工作流程

### 1. 生成當天工作計劃

```bash
# 生成今天的工作計劃
./scripts/generate_daily_plan.sh

# 或指定日期
./scripts/generate_daily_plan.sh 2025-12-01
```

這個腳本會：
- 根據今天的日期，從 `ticket_timeline.md` 找出對應的 tickets
- 從資料庫取得 Jira 資訊（連結、估時、狀態）
- 識別 parent tickets 和 child tickets
- 生成包含以下內容的工作計劃：
  - 今日目標（Parent Tickets 和 Child Tickets）
  - 與 Cursor 的協作計劃
  - 工作記錄模板

### 2. 建立工作日誌

```bash
# 建立今天的工作日誌
./scripts/create_daily_log.sh
```

### 3. 與 Cursor 開始協作

打開生成的工作計劃文件，然後對 Cursor 說：

```
根據今天的工作計劃（16_Cursor_Workflow/daily_plans/YYYY-MM-DD.md），
請協助我：
1. 讀取相關的 TDD 文件
2. 檢查現有的 codebase 結構
3. 提供實作建議和注意事項
4. 檢查依賴關係是否滿足
```

## 🔨 實作過程中的工作流程

### 與 Cursor 協作實作

1. **開始實作前**：
   ```
   我要開始實作 TDD-001，請：
   1. 讀取 TDD-001 的文件
   2. 檢查現有的 codebase 結構
   3. 提供實作建議
   ```

2. **實作過程中**：
   - 隨時與 Cursor 討論實作細節
   - 遇到問題時立即詢問 Cursor
   - 記錄重要的對話和決策

3. **實作完成後**：
   ```
   我已經完成 TDD-001 的實作，請：
   1. 檢查實作是否符合 TDD 規範
   2. 檢查是否有遺漏的功能
   3. 提供改進建議
   ```

### 記錄重要對話

使用 `cursor_conversation_template.md` 記錄重要的對話，包括：
- 實作決策
- 問題解決過程
- 學習到的知識
- 改進建議

## 📝 每天結束時的工作流程

### 1. 統整當天工作

```bash
# 統整今天的工作
./scripts/summarize_daily_work.sh
```

這個腳本會：
- 讀取當天的工作計劃
- 讀取當天的工作日誌
- 生成工作統整文件，包含：
  - 今日計劃回顧
  - 完成項目
  - 與 Cursor 的對話統整
  - 工作統計
  - 反思與學習
  - 明日計劃建議

### 2. 更新工作日誌

在手動填寫工作日誌時，記得：
- 記錄與 Cursor 的重要對話
- 記錄實作決策
- 記錄學習要點

### 3. 與 Cursor 統整對話

打開生成的工作統整文件，然後對 Cursor 說：

```
請幫我統整今天的工作：
1. 根據今天的 git commits 生成變更記錄
2. 更新 implementation_status.md
3. 更新 CHANGELOG.md
4. 檢查實作與 TDD 的一致性
5. 統整今天與你的對話，提取重要決策和學習要點
6. 生成明天的計劃建議
```

### 4. 更新相關文件

- 更新 `13_Implementation_Status/implementation_status.md`
- 更新 `14_Changelog/CHANGELOG.md`
- 更新工作日誌中的「與 Cursor 的對話統整」部分

## 📂 文件結構

```
TDDs/LiveChat&PrematchComment/
├── 13_Implementation_Status/      # 實作狀態追蹤
├── 14_Changelog/                  # 變更日誌
├── 15_Daily_Logs/                 # 工作日誌
│   ├── TEMPLATE.md                # 工作日誌模板（已更新，包含 Cursor 對話統整）
│   └── YYYY-MM-DD.md              # 每日工作日誌
├── 16_Cursor_Workflow/            # Cursor 工作流程
│   ├── README.md                   # 工作流程說明
│   ├── WORKFLOW_GUIDE.md           # 本文件
│   ├── cursor_conversation_template.md  # Cursor 對話記錄模板
│   ├── daily_plans/                # 每日工作計劃
│   │   └── YYYY-MM-DD.md
│   └── daily_summaries/            # 每日工作統整
│       └── YYYY-MM-DD.md
└── scripts/
    ├── create_daily_log.sh         # 建立工作日誌
    ├── generate_daily_plan.sh      # 生成工作計劃
    └── summarize_daily_work.sh     # 統整當天工作
```

## 🎯 最佳實踐

### 1. 每天開始時
- ✅ 執行 `generate_daily_plan.sh` 生成工作計劃
- ✅ 執行 `create_daily_log.sh` 建立工作日誌
- ✅ 與 Cursor 討論當天的工作計劃

### 2. 實作過程中
- ✅ 隨時與 Cursor 討論實作細節
- ✅ 記錄重要的對話和決策
- ✅ 遇到問題立即詢問 Cursor

### 3. 每天結束時
- ✅ 執行 `summarize_daily_work.sh` 統整工作
- ✅ 與 Cursor 統整對話
- ✅ 更新相關文件（implementation_status.md, CHANGELOG.md）
- ✅ 填寫工作日誌中的「與 Cursor 的對話統整」部分

## 💡 與 Cursor 協作的提示

### 有效的提示詞範例

1. **開始實作前**：
   ```
   根據 TDD-001 的文件，請：
   1. 讀取相關的 TDD 文件
   2. 檢查現有的 codebase 結構
   3. 提供實作建議和注意事項
   ```

2. **實作過程中**：
   ```
   我正在實作 Comment Entity，請：
   1. 檢查我的實作是否符合 TDD 規範
   2. 檢查是否有遺漏的功能
   3. 提供改進建議
   ```

3. **遇到問題時**：
   ```
   我遇到了一個問題：[描述問題]
   請協助我：
   1. 分析問題的根本原因
   2. 提供解決方案
   3. 檢查是否有其他相關問題
   ```

4. **每天結束時**：
   ```
   請幫我統整今天的工作：
   1. 根據今天的 git commits 生成變更記錄
   2. 更新 implementation_status.md
   3. 統整今天與你的對話，提取重要決策和學習要點
   ```

## 🔄 自動化建議

可以建立一個 alias 來快速執行這些腳本：

```bash
# 在 ~/.zshrc 或 ~/.bashrc 中加入
alias daily-start="cd /path/to/TDDs/LiveChat\&PrematchComment && ./scripts/generate_daily_plan.sh && ./scripts/create_daily_log.sh"
alias daily-end="cd /path/to/TDDs/LiveChat\&PrematchComment && ./scripts/summarize_daily_work.sh"
```

然後每天開始時執行 `daily-start`，結束時執行 `daily-end`。

