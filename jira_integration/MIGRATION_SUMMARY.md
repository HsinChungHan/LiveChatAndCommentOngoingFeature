# Jira Integration 遷移總結

## 遷移日期
2024-11-25

## 遷移內容

### 已移動到 `jira_integration/` 目錄

1. **腳本目錄** (`scripts/`)
   - 所有 Jira 整合相關的 Python 腳本（25 個）
   - 資料庫使用指南 (`README_DATABASE.md`)

2. **資料庫文件**
   - `jira_tickets.db` - SQLite 資料庫，包含所有 Ticket 和 Jira Issue 資訊

3. **文檔文件**
   - `JIRA_INTEGRATION.md` - Jira 整合完整指南
   - `JIRA_SETUP_GUIDE.md` - Jira 設定快速指南
   - `TROUBLESHOOTING.md` - 疑難排解指南
   - `README.md` - 本目錄使用說明

4. **配置文件**
   - `.env` - 環境變數配置（包含 Jira API Token 等敏感資訊）
   - `.gitignore` - Git 忽略規則

### 已從 `12_Tickets/` 目錄刪除

以下不必要的 log 文件已刪除：
- `CLEANUP_SUMMARY.md`
- `CLEANUP_COMPLETE.md`
- `DUPLICATE_ISSUES_ANALYSIS.md`
- `DELETION_RECOMMENDATION.md`
- `CONSOLIDATION_SUMMARY.md`
- `ASSIGNMENT_SUMMARY.md`
- `TRANSLATION_SUMMARY.md`
- `STORY_ISSUES_LIST.md`
- `ALL_STORY_ISSUES.txt`

### 保留在 `12_Tickets/` 目錄

以下內容保留在 `output/LiveChat&PrematchComment/12_Tickets/` 目錄：
- 所有 Ticket Markdown 文件（中英版本）
- `README.md` - Ticket 說明文檔
- `20_工作日開發計劃.md` - 開發計劃文檔

## 路徑更新

所有腳本中的路徑已更新：

- **資料庫路徑**：`jira_integration/jira_tickets.db`
- **Ticket 文件路徑**：`output/LiveChat&PrematchComment/12_Tickets/`

腳本會自動從正確的位置讀取 Ticket 文件和資料庫。

## 使用方式

### 從 jira_integration 目錄執行腳本

```bash
cd jira_integration
python3 scripts/init_database.py
python3 scripts/load_tickets_to_db.py
python3 scripts/sync_tickets_to_jira.py
```

### 環境變數

確保 `jira_integration/.env` 文件已正確設定：

```env
JIRA_URL=https://your-domain.atlassian.net
JIRA_EMAIL=your-email@example.com
JIRA_API_TOKEN=your-api-token
JIRA_PROJECT_KEY=YOUR-PROJECT-KEY
PARENT_ISSUE_KEY=YOUR-PARENT-ISSUE-KEY
ASSIGNEE_EMAIL=assignee@example.com
REPORTER_EMAIL=reporter@example.com
```

## 目錄結構

```
MermaidToTDD/
├── jira_integration/          # Jira 整合相關（新位置）
│   ├── scripts/               # 所有 Python 腳本
│   ├── jira_tickets.db        # SQLite 資料庫
│   ├── .env                   # 環境變數（需自行創建）
│   ├── .gitignore
│   ├── README.md
│   ├── JIRA_INTEGRATION.md
│   ├── JIRA_SETUP_GUIDE.md
│   └── TROUBLESHOOTING.md
└── output/
    └── LiveChat&PrematchComment/
        └── 12_Tickets/         # Ticket 文件（保留）
            ├── README.md
            ├── 20_工作日開發計劃.md
            └── [Ticket 文件目錄]
```

## 注意事項

1. **環境變數**：`.env` 文件包含敏感資訊，已加入 `.gitignore`，不會被提交到 Git
2. **資料庫備份**：建議定期備份 `jira_tickets.db` 文件
3. **路徑引用**：所有腳本已更新路徑，可以正常從 `jira_integration/` 目錄執行
4. **Ticket 文件**：Ticket Markdown 文件保留在 `output/` 目錄中，作為 TDD 的一部分

---

**最後更新**：2024-11-25


