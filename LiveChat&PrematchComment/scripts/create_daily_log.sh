#!/bin/bash

# 建立工作日誌腳本
# 使用方法: ./create_daily_log.sh [日期]
# 如果沒有提供日期，則使用今天的日期

TDD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DAILY_LOGS_DIR="$TDD_DIR/15_Daily_Logs"

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

# 建立工作日誌檔案
LOG_FILE="$DAILY_LOGS_DIR/$DATE.md"

# 如果檔案已存在，詢問是否覆蓋
if [ -f "$LOG_FILE" ]; then
    read -p "檔案 $LOG_FILE 已存在，是否要覆蓋？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "已取消"
        exit 0
    fi
fi

# 讀取模板
TEMPLATE_FILE="$DAILY_LOGS_DIR/TEMPLATE.md"

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "錯誤: 找不到模板檔案 $TEMPLATE_FILE"
    exit 1
fi

# 替換模板中的日期
sed "s/YYYY-MM-DD/$DATE/g" "$TEMPLATE_FILE" > "$LOG_FILE"

echo "✅ 工作日誌已建立: $LOG_FILE"
echo ""
echo "你可以使用以下命令開啟："
echo "  open $LOG_FILE"
echo "  或"
echo "  code $LOG_FILE"

