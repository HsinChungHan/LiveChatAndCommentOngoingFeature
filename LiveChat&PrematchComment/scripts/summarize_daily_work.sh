#!/bin/bash

# 統整當天的工作（包含與 Cursor 的對話）
# 使用方法: ./summarize_daily_work.sh [日期]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TDD_DIR="$SCRIPT_DIR"
DAILY_LOGS_DIR="$TDD_DIR/15_Daily_Logs"
CURSOR_WORKFLOW_DIR="$TDD_DIR/16_Cursor_Workflow"
PLAN_DIR="$CURSOR_WORKFLOW_DIR/daily_plans"

# 取得日期（如果沒有提供則使用今天）
if [ -z "$1" ]; then
    DATE=$(date +%Y-%m-%d)
else
    DATE="$1"
fi

# 檢查日期格式
if ! [[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "錯誤: 日期格式不正確，請使用 YYYY-MM-DD 格式"
    exit 1
fi

PLAN_FILE="$PLAN_DIR/$DATE.md"
LOG_FILE="$DAILY_LOGS_DIR/$DATE.md"
SUMMARY_FILE="$CURSOR_WORKFLOW_DIR/daily_summaries/$DATE.md"

# 建立目錄（如果不存在）
mkdir -p "$CURSOR_WORKFLOW_DIR/daily_summaries"

# 檢查工作日誌是否存在
if [ ! -f "$LOG_FILE" ]; then
    echo "⚠️  工作日誌不存在: $LOG_FILE"
    echo "請先建立工作日誌："
    echo "  ./scripts/create_daily_log.sh $DATE"
    exit 1
fi

# 生成統整文件
cat > "$SUMMARY_FILE" <<EOF
# 工作統整 - $DATE

**生成時間**: $(date +"%Y-%m-%d %H:%M:%S")

---

## 📋 今日計劃回顧

EOF

# 如果有工作計劃，讀取計劃內容
if [ -f "$PLAN_FILE" ]; then
    echo "### 原定計劃" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    # 提取計劃中的 tickets
    grep -E "^- \[ \] \*\*TDD-" "$PLAN_FILE" | sed 's/^- \[ \] /- /' >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
else
    echo "（沒有找到當天的工作計劃）" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
fi

cat >> "$SUMMARY_FILE" <<EOF
---

## ✅ 完成項目

（從工作日誌中提取完成項目）

---

## 🤖 與 Cursor 的對話統整

### 重要對話摘要

（請整理今天與 Cursor 的重要對話，包括：）
- 實作決策
- 問題解決過程
- 學習到的知識
- 改進建議

### 對話記錄

（可以貼上重要的對話內容）

---

## 📊 工作統計

- **計劃的 Tickets**: 
- **完成的 Tickets**: 
- **進行中的 Tickets**: 
- **與 Cursor 的對話次數**: 
- **解決的問題數**: 

---

## 💡 反思與學習

- 今天學到了什麼？
- 哪些地方可以做得更好？
- 與 Cursor 的協作有什麼改進空間？

---

## 🔄 明日計劃

（生成明天的工作計劃建議）

---

## 相關文件

- [工作日誌]($LOG_FILE)
- [工作計劃]($PLAN_FILE)（如果存在）

EOF

echo "✅ 工作統整已生成: $SUMMARY_FILE"
echo ""
echo "請手動填寫以下內容："
echo "1. 完成項目（從工作日誌中提取）"
echo "2. 與 Cursor 的對話統整"
echo "3. 工作統計"
echo "4. 反思與學習"
echo ""
echo "你可以使用以下命令開啟："
echo "  open $SUMMARY_FILE"
echo "  或"
echo "  code $SUMMARY_FILE"

