# Daily Start

每天開始時執行的工作流程。

## 使用方式

直接在 Cursor 中執行此命令，或說「開始今天的工作」

## 功能

一次性執行：
1. 生成今天的工作計劃
2. 建立今天的工作日誌
3. 讀取工作計劃並提供實作建議

## 執行

```bash
cd /Users/reedhsin/Documents/codebase/fcom-iOS/TDDs/LiveChat\&PrematchComment && \
./scripts/generate_daily_plan.sh && \
./scripts/create_daily_log.sh
```

然後請協助我：
1. 讀取今天的工作計劃（`16_Cursor_Workflow/daily_plans/YYYY-MM-DD.md`）
2. 讀取相關的 TDD 文件
3. 檢查現有的 codebase 結構
4. 提供實作建議和注意事項
5. 檢查依賴關係是否滿足

## 生成的文件

- `16_Cursor_Workflow/daily_plans/YYYY-MM-DD.md`
- `15_Daily_Logs/YYYY-MM-DD.md`

