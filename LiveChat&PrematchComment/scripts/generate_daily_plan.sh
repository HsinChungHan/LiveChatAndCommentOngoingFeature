#!/bin/bash

# 根據日期生成當天的工作計劃
# 使用方法: ./generate_daily_plan.sh [日期]
# 如果沒有提供日期，則使用今天的日期

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TDD_DIR="$SCRIPT_DIR"
DB_FILE="$TDD_DIR/12_Tickets/jira_tickets.db"
TIMELINE_FILE="$TDD_DIR/12_Tickets/ticket_timeline.md"
DAILY_LOGS_DIR="$TDD_DIR/15_Daily_Logs"
CURSOR_WORKFLOW_DIR="$TDD_DIR/16_Cursor_Workflow"

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

# 檢查是否為工作日（週一至週五）
WEEKDAY=$(python3 -c "from datetime import datetime; d = datetime.strptime('$DATE', '%Y-%m-%d'); print(d.weekday())")
if [ "$WEEKDAY" -ge 5 ]; then
    echo "錯誤: $DATE 是週末，只有工作日才能建立 daily plan"
    exit 1
fi

# 建立工作計劃檔案
PLAN_FILE="$CURSOR_WORKFLOW_DIR/daily_plans/$DATE.md"

# 建立目錄（如果不存在）
mkdir -p "$CURSOR_WORKFLOW_DIR/daily_plans"
mkdir -p "$DAILY_LOGS_DIR"

# 使用 Python 腳本生成工作計劃
python3 <<PYTHON_SCRIPT
import sys
import sqlite3
from datetime import datetime, timedelta
import re

date_str = "$DATE"
db_file = "$DB_FILE"
timeline_file = "$TIMELINE_FILE"
plan_file = "$PLAN_FILE"

# 解析日期
target_date = datetime.strptime(date_str, "%Y-%m-%d")

# 讀取 timeline 文件找出當天的 tickets
tickets_today = []
parent_tickets = []
child_tickets = []

try:
    with open(timeline_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    # 找出包含日期的行
    for line in lines:
        if '|' in line and 'TDD-' in line:
            parts = [p.strip() for p in line.split('|')]
            if len(parts) >= 6:
                ticket_id = parts[1].strip()
                start_date_str = parts[4].strip() if len(parts) > 4 else ''
                end_date_str = parts[5].strip() if len(parts) > 5 else ''
                
                if ticket_id.startswith('TDD-') or ticket_id.startswith('MAIN-'):
                    try:
                        if start_date_str:
                            start_date = datetime.strptime(start_date_str, "%Y-%m-%d")
                        if end_date_str:
                            end_date = datetime.strptime(end_date_str, "%Y-%m-%d")
                        
                        # 檢查是否在日期範圍內
                        if start_date_str and end_date_str:
                            if start_date <= target_date <= end_date:
                                tickets_today.append({
                                    'id': ticket_id,
                                    'start': start_date_str,
                                    'end': end_date_str,
                                    'title': parts[2].strip() if len(parts) > 2 else ticket_id
                                })
                    except:
                        pass
except Exception as e:
    print(f"讀取 timeline 文件時發生錯誤: {e}", file=sys.stderr)

# 從資料庫取得 Jira 資訊
jira_info = {}
if db_file:
    try:
        conn = sqlite3.connect(db_file)
        cursor = conn.cursor()
        
        for ticket in tickets_today:
            ticket_id = ticket['id']
            # 查詢 Jira 資訊
            cursor.execute("""
                SELECT j.jira_key, j.url, j.original_estimate, j.status
                FROM jira_issues j
                WHERE j.ticket_id = ? OR j.ticket_id = ?
            """, (ticket_id, ticket_id + '-EN'))
            
            result = cursor.fetchone()
            if result:
                jira_info[ticket_id] = {
                    'key': result[0],
                    'url': result[1],
                    'estimate': result[2],
                    'status': result[3]
                }
        
        conn.close()
    except Exception as e:
        print(f"讀取資料庫時發生錯誤: {e}", file=sys.stderr)

# 讀取依賴關係
dependencies = {}
try:
    conn = sqlite3.connect(db_file)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT ticket_id, depends_on_ticket_id
        FROM dependencies
    """)
    
    for row in cursor.fetchall():
        ticket_id, depends_on = row
        if ticket_id not in dependencies:
            dependencies[ticket_id] = []
        dependencies[ticket_id].append(depends_on)
    
    conn.close()
except:
    pass

# 分類 tickets
for ticket in tickets_today:
    ticket_id = ticket['id']
    # 檢查是否有 child tickets
    has_children = any(ticket_id in deps for deps in dependencies.values())
    if has_children:
        parent_tickets.append(ticket)
    else:
        # 檢查是否有 parent
        if ticket_id in dependencies and dependencies[ticket_id]:
            child_tickets.append(ticket)
        else:
            # 沒有依賴關係的獨立 ticket
            parent_tickets.append(ticket)

# 生成工作計劃
with open(plan_file, 'w', encoding='utf-8') as f:
    f.write(f"# 工作計劃 - {date_str}\n\n")
    f.write(f"**生成時間**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
    
    f.write("## 📋 今日目標\n\n")
    
    if parent_tickets:
        f.write("### Parent Tickets（主要工作項目）\n\n")
        for ticket in parent_tickets:
            ticket_id = ticket['id']
            title = ticket['title']
            jira = jira_info.get(ticket_id, {})
            
            f.write(f"- [ ] **{ticket_id}**: {title}\n")
            if jira.get('key'):
                f.write(f"  - Jira: [{jira['key']}]({jira.get('url', '')})\n")
            if jira.get('estimate'):
                f.write(f"  - 估時: {jira['estimate']}\n")
            if jira.get('status'):
                f.write(f"  - 狀態: {jira['status']}\n")
            f.write(f"  - 時間範圍: {ticket['start']} ~ {ticket['end']}\n")
            f.write("\n")
    
    if child_tickets:
        f.write("### Child Tickets（相關工作項目）\n\n")
        for ticket in child_tickets:
            ticket_id = ticket['id']
            title = ticket['title']
            jira = jira_info.get(ticket_id, {})
            
            f.write(f"- [ ] **{ticket_id}**: {title}\n")
            if jira.get('key'):
                f.write(f"  - Jira: [{jira['key']}]({jira.get('url', '')})\n")
            if jira.get('estimate'):
                f.write(f"  - 估時: {jira['estimate']}\n")
            f.write(f"  - 時間範圍: {ticket['start']} ~ {ticket['end']}\n")
            f.write("\n")
    
    if not tickets_today:
        f.write("今天沒有排定的 tickets。\n\n")
    
    f.write("## 🤖 與 Cursor 的協作計劃\n\n")
    f.write("### 開始實作前\n\n")
    f.write("請 Cursor 協助：\n")
    f.write("1. 讀取相關的 TDD 文件\n")
    f.write("2. 檢查現有的 codebase 結構\n")
    f.write("3. 提供實作建議和注意事項\n")
    f.write("4. 檢查依賴關係是否滿足\n\n")
    
    f.write("### 實作過程中\n\n")
    f.write("- 隨時與 Cursor 討論實作細節\n")
    f.write("- 記錄重要的決策和對話\n")
    f.write("- 遇到問題時請 Cursor 協助解決\n\n")
    
    f.write("### 實作完成後\n\n")
    f.write("請 Cursor 協助：\n")
    f.write("1. 檢查實作是否符合 TDD 規範\n")
    f.write("2. 檢查是否有遺漏的功能\n")
    f.write("3. 提供改進建議\n")
    f.write("4. 更新相關文件\n\n")
    
    f.write("## 📝 工作記錄\n\n")
    f.write("### 與 Cursor 的重要對話\n\n")
    f.write("（在此記錄與 Cursor 的重要對話和決策）\n\n")
    f.write("### 實作進度\n\n")
    f.write("（在此記錄實作進度）\n\n")
    f.write("### 遇到的問題\n\n")
    f.write("（在此記錄遇到的問題和解決方案）\n\n")

print(f"✅ 工作計劃已生成: {plan_file}")
print(f"\n今天有 {len(tickets_today)} 個 tickets:")
for ticket in tickets_today:
    print(f"  - {ticket['id']}: {ticket['title']}")

PYTHON_SCRIPT

echo ""
echo "你可以使用以下命令開啟："
echo "  open $PLAN_FILE"
echo "  或"
echo "  code $PLAN_FILE"

