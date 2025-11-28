# Cursor 工作流程快速開始

## 🚀 快速開始

### 每天開始時（3 個步驟）

1. **生成工作計劃**
   ```bash
   ./scripts/generate_daily_plan.sh
   ```

2. **建立工作日誌**
   ```bash
   ./scripts/create_daily_log.sh
   ```

3. **與 Cursor 開始協作**
   ```
   根據今天的工作計劃（16_Cursor_Workflow/daily_plans/YYYY-MM-DD.md），
   請協助我：
   1. 讀取相關的 TDD 文件
   2. 檢查現有的 codebase 結構
   3. 提供實作建議和注意事項
   4. 檢查依賴關係是否滿足
   ```

### 每天結束時（2 個步驟）

1. **統整當天工作**
   ```bash
   ./scripts/summarize_daily_work.sh
   ```

2. **與 Cursor 統整對話**
   ```
   請幫我統整今天的工作：
   1. 根據今天的 git commits 生成變更記錄
   2. 更新 implementation_status.md
   3. 更新 CHANGELOG.md
   4. 檢查實作與 TDD 的一致性
   5. 統整今天與你的對話，提取重要決策和學習要點
   6. 生成明天的計劃建議
   ```

## 📁 生成的文件

### 每天開始時生成
- `16_Cursor_Workflow/daily_plans/YYYY-MM-DD.md` - 當天工作計劃
- `15_Daily_Logs/YYYY-MM-DD.md` - 當天工作日誌

### 每天結束時生成
- `16_Cursor_Workflow/daily_summaries/YYYY-MM-DD.md` - 當天工作統整

## 📝 需要手動填寫的內容

### 工作日誌中
- ✅ 完成項目
- 🚧 進行中項目
- 🐛 遇到的問題
- 🤖 與 Cursor 的對話統整（重要！）
- 💡 學習與反思
- 📊 時間統計

### 工作統整中
- ✅ 完成項目（從工作日誌中提取）
- 🤖 與 Cursor 的對話統整（重要！）
- 📊 工作統計
- 💡 反思與學習

## 💡 提示

- 工作計劃會自動根據日期找出對應的 Jira tickets
- 工作日誌模板已包含「與 Cursor 的對話統整」部分
- 記得每天結束時統整與 Cursor 的對話，這對後續開發很有幫助

## 📚 詳細文件

- [完整工作流程指南](WORKFLOW_GUIDE.md)
- [Cursor 對話記錄模板](cursor_conversation_template.md)

