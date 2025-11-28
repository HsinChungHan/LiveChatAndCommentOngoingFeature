# Cursor 工作流程

本目錄包含與 Cursor AI 協作的完整工作流程，幫助你更有效率地進行開發。

## 工作流程概述

### 1. 每天開始時
- 根據今天的日期，自動找出對應的 Jira parent tickets 和 child tickets
- 生成當天的工作計劃
- 建立工作日誌

### 2. 實作過程中
- 與 Cursor 協作實作功能
- 記錄重要的對話和決策

### 3. 每天結束時
- 統整與 Cursor 的對話
- 更新實作狀態
- 更新變更日誌
- 生成明天的工作計劃

## 使用方式

### 生成當天工作計劃

```bash
# 生成今天的工作計劃
./scripts/generate_daily_plan.sh

# 生成指定日期的工作計劃
./scripts/generate_daily_plan.sh 2025-12-01
```

### 統整當天工作

```bash
# 統整今天的工作（包含與 Cursor 的對話）
./scripts/summarize_daily_work.sh
```

## 文件結構

- `README.md` - 本文件
- `daily_plan_template.md` - 每日工作計劃模板
- `cursor_conversation_template.md` - Cursor 對話記錄模板

