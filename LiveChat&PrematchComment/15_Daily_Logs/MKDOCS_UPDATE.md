# mkdocs.yml 更新方式

本文檔說明如何更新 `mkdocs.yml` 中的導航配置，特別是 Daily Logs 部分。

## 🔄 自動更新（推薦）

### 方式 1: 使用 daily-end 命令

執行 `daily-end` 命令時，會自動更新 `mkdocs.yml`：

```bash
@daily-end
```

這會執行 `summarize_daily_work.sh` 腳本，該腳本會：
1. 生成工作統整文件
2. **自動更新 mkdocs.yml**（新增功能）
3. 提示部署到 GitHub Pages

### 方式 2: 直接執行更新腳本

```bash
cd /Users/reedhsin/Documents/codebase/fcom-iOS/TDDs/LiveChat\&PrematchComment/LiveChat\&PrematchComment
./scripts/update_mkdocs_nav.sh
```

## 📝 手動更新

如果自動更新失敗，可以手動編輯 `mkdocs.yml`：

### 步驟 1: 找到 Daily Logs 部分

在 `mkdocs.yml` 中找到：

```yaml
  - Daily Logs:
    - 15_Daily_Logs/README.md
    - 15_Daily_Logs/TEMPLATE.md
    - 15_Daily_Logs/WORKFLOW.md
    - 15_Daily_Logs/2025-12-01.md
    - 15_Daily_Logs/2025-12-02.md
```

### 步驟 2: 添加新的工作日誌

在 `Daily Logs` 部分添加新的工作日誌文件：

```yaml
  - Daily Logs:
    - 15_Daily_Logs/README.md
    - 15_Daily_Logs/TEMPLATE.md
    - 15_Daily_Logs/WORKFLOW.md
    - 15_Daily_Logs/FORMAT_RULES.md
    - 15_Daily_Logs/2025-12-01.md
    - 15_Daily_Logs/2025-12-02.md
    - 15_Daily_Logs/2025-12-03.md  # 新增
```

### 步驟 3: 保持順序

確保工作日誌按日期排序（從舊到新）。

## 🔍 更新腳本工作原理

`update_mkdocs_nav.sh` 腳本會：

1. **掃描目錄**: 掃描 `15_Daily_Logs/` 目錄，找到所有格式為 `YYYY-MM-DD.md` 的文件
2. **排序**: 按文件名（日期）排序
3. **更新配置**: 使用 Python 正則表達式替換 `mkdocs.yml` 中的 `Daily Logs` 部分
4. **保留固定文件**: 保留 `README.md`、`TEMPLATE.md`、`WORKFLOW.md`、`FORMAT_RULES.md`

## ⚙️ 技術細節

### 腳本位置

```
scripts/update_mkdocs_nav.sh
```

### 依賴

- Python 3（內建，無需額外安裝）
- 使用 Python 的 `re` 和 `pathlib` 模組（標準庫）

### 更新範圍

腳本只更新 `Daily Logs` 部分，不影響其他導航配置。

## 🚀 完整工作流程

### 每天結束時

```bash
# 1. 執行 daily-end（自動更新 mkdocs.yml）
@daily-end

# 2. 部署到 GitHub Pages
@deploy-tdd-to-mkdocs
```

### 或手動執行

```bash
# 1. 更新 mkdocs.yml
./scripts/update_mkdocs_nav.sh

# 2. 部署
python3 -m mkdocs gh-deploy
```

## ⚠️ 注意事項

1. **備份**: 更新前建議先備份 `mkdocs.yml`
2. **檢查**: 更新後檢查 `mkdocs.yml` 格式是否正確
3. **測試**: 部署前可以本地測試：`python3 -m mkdocs serve`

## 🔧 故障排除

### 問題 1: 腳本執行失敗

**錯誤**: `❌ 更新失敗`

**解決**:
1. 檢查 Python 3 是否已安裝：`python3 --version`
2. 檢查腳本權限：`chmod +x scripts/update_mkdocs_nav.sh`
3. 檢查文件路徑是否正確

### 問題 2: mkdocs.yml 格式錯誤

**錯誤**: MkDocs 建置失敗

**解決**:
1. 檢查 YAML 縮進（必須使用 2 個空格）
2. 檢查是否有語法錯誤
3. 使用 YAML 驗證工具檢查

### 問題 3: 工作日誌未出現在導航中

**原因**: 文件名格式不正確

**解決**: 確保文件名格式為 `YYYY-MM-DD.md`（例如：`2025-12-03.md`）

## 📚 相關文件

- [工作日誌 README](./README.md)
- [工作日誌格式規則](./FORMAT_RULES.md)
- [工作日誌工作流程](./WORKFLOW.md)
- [MkDocs 部署指南](../17_Cursor_Commands/deploy-tdd-to-mkdocs.md)

