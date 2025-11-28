# Daily End

每天結束時執行的工作流程。

## 使用方式

直接在 Cursor 中執行此命令，或說「結束今天的工作」

## 功能

一次性執行：
1. 統整當天工作
2. 更新實作狀態
3. 更新變更日誌
4. 統整與 Cursor 的對話

## 執行

```bash
cd /Users/reedhsin/Documents/codebase/fcom-iOS/TDDs/LiveChat\&PrematchComment && \
./scripts/summarize_daily_work.sh
```

然後請協助我：
1. 根據今天的 git commits 生成變更記錄
2. 更新 `13_Implementation_Status/implementation_status.md`
3. 更新 `14_Changelog/CHANGELOG.md`
4. 檢查實作與 TDD 的一致性
5. 統整今天與你的對話，提取重要決策和學習要點
6. 生成明天的計劃建議

## 生成的文件

- `16_Cursor_Workflow/daily_summaries/YYYY-MM-DD.md`
- 更新的 `13_Implementation_Status/implementation_status.md`
- 更新的 `14_Changelog/CHANGELOG.md`

