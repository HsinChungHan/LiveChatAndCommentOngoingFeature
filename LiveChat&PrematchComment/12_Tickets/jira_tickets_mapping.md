# Local Tickets 與 Jira Tickets 對應表

本文件列出所有 Local Tickets 對應的 Jira Ticket 連結及開發時間資訊。

**最後更新**: $(date +%Y-%m-%d\ %H:%M)

---

## 完整對應表

| Ticket ID | 標題 | Jira Key | Jira 連結 | 原始估時 | 已花費時間 | 剩餘時間 | 建立時間 | 更新時間 | 解決時間 | 狀態 |
|-----------|------|----------|-----------|---------|-----------|---------|---------|---------|---------|------|

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
