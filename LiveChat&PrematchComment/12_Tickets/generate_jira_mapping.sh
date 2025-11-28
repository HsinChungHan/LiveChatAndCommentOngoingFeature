#!/bin/bash

# 從資料庫生成 Jira Tickets 對應表
# 使用方法: ./generate_jira_mapping.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_FILE="$SCRIPT_DIR/jira_tickets.db"
OUTPUT_FILE="$SCRIPT_DIR/jira_tickets_mapping.md"

if [ ! -f "$DB_FILE" ]; then
    echo "錯誤: 找不到資料庫檔案 $DB_FILE"
    exit 1
fi

# 生成 Markdown 文件
sqlite3 -header -column "$DB_FILE" <<EOF > /tmp/jira_mapping_data.txt
SELECT 
  t.ticket_id,
  t.title,
  COALESCE(j.jira_key, j_en.jira_key) as jira_key,
  COALESCE(j.url, j_en.url) as url,
  COALESCE(j.original_estimate, j_en.original_estimate) as original_estimate,
  COALESCE(j.time_spent, j_en.time_spent) as time_spent,
  COALESCE(j.time_remaining, j_en.time_remaining) as time_remaining,
  COALESCE(j.created_at, j_en.created_at) as created_at,
  COALESCE(j.updated_at, j_en.updated_at) as updated_at,
  COALESCE(j.resolved_at, j_en.resolved_at) as resolved_at,
  COALESCE(j.status, j_en.status) as status
FROM tickets t
LEFT JOIN jira_issues j ON t.ticket_id = j.ticket_id
LEFT JOIN tickets t_en ON t_en.ticket_id = t.ticket_id || '-EN'
LEFT JOIN jira_issues j_en ON t_en.ticket_id = j_en.ticket_id
WHERE t.ticket_id NOT LIKE '%-EN'
ORDER BY t.ticket_id;
EOF

# 生成 Markdown 文件頭部
cat > "$OUTPUT_FILE" <<'HEADER'
# Local Tickets 與 Jira Tickets 對應表

本文件列出所有 Local Tickets 對應的 Jira Ticket 連結及開發時間資訊。

**最後更新**: $(date +%Y-%m-%d\ %H:%M)

---

## 完整對應表

| Ticket ID | 標題 | Jira Key | Jira 連結 | 原始估時 | 已花費時間 | 剩餘時間 | 建立時間 | 更新時間 | 解決時間 | 狀態 |
|-----------|------|----------|-----------|---------|-----------|---------|---------|---------|---------|------|
HEADER

# 處理資料並轉換為 Markdown 表格格式
python3 <<'PYTHON_SCRIPT'
import sys
import re
from datetime import datetime

# 讀取資料
with open('/tmp/jira_mapping_data.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# 跳過標題行
data_lines = lines[2:]  # 跳過空行和標題行

current_layer = None
layer_names = {
    'TDD-001': '**Domain Model Layer**',
    'TDD-010': '**API Layer**',
    'TDD-020': '**Client Layer**',
    'TDD-030': '**Repository Layer**',
    'TDD-040': '**UseCase Layer**',
    'TDD-050': '**Feature Layer**',
    'TDD-060': '**View Layer**',
}

for line in data_lines:
    if not line.strip():
        continue
    
    parts = [p.strip() for p in line.split('|')]
    if len(parts) < 12:
        continue
    
    ticket_id = parts[0]
    title = parts[1]
    jira_key = parts[2] if parts[2] else '-'
    url = parts[3] if parts[3] else '-'
    original_estimate = parts[4] if parts[4] else '-'
    time_spent = parts[5] if parts[5] else '-'
    time_remaining = parts[6] if parts[6] else '-'
    created_at = parts[7] if parts[7] else '-'
    updated_at = parts[8] if parts[8] else '-'
    resolved_at = parts[9] if parts[9] else '-'
    status = parts[10] if parts[10] else '-'
    
    # 檢查是否需要顯示層級標題
    for key, layer_name in layer_names.items():
        if ticket_id.startswith(key.split('-')[0] + '-' + key.split('-')[1]):
            if current_layer != layer_name:
                print(f"| {layer_name} | | | | | | | | | | |")
                current_layer = layer_name
            break
    
    # 格式化時間
    if created_at and created_at != '-':
        try:
            dt = datetime.fromisoformat(created_at.replace('+0800', ''))
            created_at = dt.strftime('%Y-%m-%d %H:%M')
        except:
            pass
    
    if updated_at and updated_at != '-':
        try:
            dt = datetime.fromisoformat(updated_at.replace('+0800', ''))
            updated_at = dt.strftime('%Y-%m-%d %H:%M')
        except:
            pass
    
    # 生成 Jira 連結
    if jira_key and jira_key != '-':
        jira_link = f"[{jira_key}]({url})" if url != '-' else jira_key
        url_link = f"[連結]({url})" if url != '-' else '-'
    else:
        jira_link = '-'
        url_link = '-'
    
    # 輸出表格行
    print(f"| {ticket_id} | {title} | {jira_link} | {url_link} | {original_estimate} | {time_spent} | {time_remaining} | {created_at} | {updated_at} | {resolved_at} | {status} |")
PYTHON_SCRIPT

# 添加文件尾部
cat >> "$OUTPUT_FILE" <<'FOOTER'

---

## 統計資訊

### 按狀態統計

| 狀態 | 數量 |
|------|------|
| 進行中 | $(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM jira_issues WHERE status = '進行中';") |
| Backlog | $(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM jira_issues WHERE status = 'Backlog';") |

### 備註

- **時間格式說明**:
  - `2h 24m` = 2 小時 24 分鐘
  - `1d` = 1 天
  - `1w` = 1 週

- **狀態說明**:
  - `進行中`: 目前正在開發中
  - `Backlog`: 待開發

- **資料來源**: `jira_tickets.db` 資料庫
- **更新方式**: 執行 `./generate_jira_mapping.sh` 即可更新此文件
FOOTER

echo "✅ Jira Tickets 對應表已生成: $OUTPUT_FILE"

