# Generate Daily Plan

根據今天的日期，自動生成當天的工作計劃，包含對應的 Jira parent tickets 和 child tickets。

## 使用方式

直接在 Cursor 中執行此命令，或說「生成今天的工作計劃」

## 功能

- 根據今天的日期找出對應的 tickets
- 從資料庫取得 Jira 資訊（連結、估時、狀態）
- 識別 parent tickets 和 child tickets
- 生成包含與 Cursor 協作計劃的工作計劃文件

## 執行

```bash
cd /Users/reedhsin/Documents/codebase/fcom-iOS/TDDs/LiveChat\&PrematchComment && ./scripts/generate_daily_plan.sh
```

## 生成的文件

- `16_Cursor_Workflow/daily_plans/YYYY-MM-DD.md`

