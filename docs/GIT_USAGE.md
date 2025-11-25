# Git 使用指南

本專案使用 Git 進行版本控制。本文檔說明在此專案中 Git 的用途和常用指令。

---

## Git 在本專案中的用途

### 1. 版本控制
- 追蹤所有規範文件（`TDD_rules/`）
- 追蹤工作流程文檔（`docs/`）
- 追蹤範本文件（`templates/`）
- 追蹤生成的 TDD 文件（`output/`）

### 2. 協作開發
- 多人協作開發 TDD 文件
- Code Review 和 Pull Request
- 追蹤變更歷史

### 3. 自動化部署
- GitHub Actions 自動部署 MkDocs 網站到 GitHub Pages
- 每次 push 到 `main` 分支時自動建置和部署

---

## 專案中的 Git 配置

### `.gitignore` 文件

專案根目錄的 `.gitignore` 配置了以下忽略規則：

```
# Output folder - 所有生成的 TDD 文件
output/
# 但允許 mkdocs.yml 和文檔內容
!output/mkdocs.yml
!output/LiveChat&PrematchComment/
!output/LiveChat&PrematchComment/**/*

# macOS
.DS_Store
.AppleDouble
.LSOverride

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Temporary files
*.tmp
*.log

# MkDocs
site/
.mkdocs_cache/
*.pyc
__pycache__/
```

### `jira_integration/.gitignore`

Jira 整合目錄有獨立的 `.gitignore`：

```
# 環境變數檔案（包含敏感資訊）
.env

# Python 快取
__pycache__/
*.py[cod]
*$py.class
*.so

# 虛擬環境
venv/
env/
ENV/

# IDE
.vscode/
.idea/
*.swp
*.swo

# 日誌檔案
*.log

jira_tickets.db
*.db
```

---

## 常用 Git 指令

### 基本操作

#### 查看狀態
```bash
git status
```
查看工作目錄的變更狀態。

#### 查看變更內容
```bash
git diff
```
查看未暫存的變更內容。

```bash
git diff --staged
```
查看已暫存的變更內容。

#### 添加文件到暫存區
```bash
# 添加單個文件
git add <file>

# 添加所有變更
git add .

# 添加特定目錄
git add docs/
```

#### 提交變更
```bash
git commit -m "提交訊息"
```

#### 查看提交歷史
```bash
git log
```

```bash
git log --oneline
```
簡潔格式顯示提交歷史。

---

### 分支操作

#### 查看分支
```bash
git branch
```
查看本地分支。

```bash
git branch -a
```
查看所有分支（包括遠端）。

#### 創建分支
```bash
git branch <branch-name>
```

#### 切換分支
```bash
git checkout <branch-name>
```

#### 創建並切換分支
```bash
git checkout -b <branch-name>
```

---

### 遠端操作

#### 查看遠端倉庫
```bash
git remote -v
```

#### 拉取遠端變更
```bash
git pull
```

#### 推送本地變更
```bash
git push
```

```bash
git push origin <branch-name>
```
推送到指定分支。

---

### 撤銷操作

#### 撤銷工作目錄的變更
```bash
git restore <file>
```
撤銷單個文件的變更。

```bash
git restore .
```
撤銷所有未暫存的變更。

#### 取消暫存
```bash
git restore --staged <file>
```
將文件從暫存區移除。

#### 修改最後一次提交
```bash
git commit --amend -m "新的提交訊息"
```

---

## 專案特定的 Git 工作流程

### 1. 更新規範文件

當更新 `TDD_rules/` 目錄下的規範文件時：

```bash
# 1. 查看變更
git status

# 2. 添加變更
git add TDD_rules/

# 3. 提交
git commit -m "更新 TDD 規範：<具體說明>"

# 4. 推送
git push
```

### 2. 更新工作流程文檔

當更新 `docs/` 目錄下的文檔時：

```bash
git add docs/
git commit -m "更新工作流程文檔：<具體說明>"
git push
```

### 3. 更新生成的 TDD 文件

當更新 `output/` 目錄下的 TDD 文件時：

```bash
git add output/LiveChat&PrematchComment/
git commit -m "更新 TDD 文件：<Feature 名稱>"
git push
```

**注意**：`output/site/` 目錄會被忽略（由 MkDocs 自動生成）。

### 4. 自動部署

當推送到 `main` 分支時，GitHub Actions 會自動：
1. 建置 MkDocs 網站
2. 部署到 GitHub Pages

---

## 常見場景

### 場景 1：提交所有變更

```bash
git add .
git commit -m "更新：<說明變更內容>"
git push
```

### 場景 2：只提交特定目錄

```bash
git add docs/
git commit -m "更新工作流程文檔"
git push
```

### 場景 3：查看最近的變更

```bash
git log --oneline -10
```
查看最近 10 次提交。

```bash
git show
```
查看最後一次提交的詳細內容。

### 場景 4：比較兩個提交

```bash
git diff <commit1> <commit2>
```

### 場景 5：撤銷最後一次提交（保留變更）

```bash
git reset --soft HEAD~1
```

### 場景 6：撤銷最後一次提交（丟棄變更）

```bash
git reset --hard HEAD~1
```

**⚠️ 警告**：`--hard` 會永久丟棄變更，請謹慎使用！

---

## GitHub Actions 自動化

### 自動部署流程

當推送到 `main` 分支時，`.github/workflows/deploy.yml` 會自動執行：

1. **Checkout 代碼**
2. **設置 Python 環境**
3. **安裝依賴**（`pip install -r requirements.txt`）
4. **建置 MkDocs 網站**（`mkdocs build`）
5. **部署到 GitHub Pages**

### 手動觸發部署

在 GitHub 上可以手動觸發部署：
1. 前往 Actions 標籤
2. 選擇 "Deploy MkDocs to GitHub Pages"
3. 點擊 "Run workflow"

---

## 注意事項

### 1. 敏感資訊

**不要提交以下文件到 Git**：
- `jira_integration/.env`（包含 Jira API Token）
- 任何包含 API Key、Token、密碼的文件

這些文件已在 `.gitignore` 中配置。

### 2. 大文件

避免提交大文件（> 100MB）到 Git。如果必須提交，考慮使用 Git LFS。

### 3. 提交訊息規範

建議使用清晰的提交訊息：

```
<類型>: <簡短說明>

<詳細說明（可選）>
```

**類型範例**：
- `docs:` - 文檔更新
- `feat:` - 新功能
- `fix:` - 修復問題
- `refactor:` - 重構
- `chore:` - 維護工作

**範例**：
```
docs: 更新 TDD 生成工作流程文檔

- 添加 AI 輔助生成流程說明
- 更新各角色文件規範
```

---

## 相關資源

- [Git 官方文檔](https://git-scm.com/doc)
- [GitHub Actions 文檔](https://docs.github.com/en/actions)
- [MkDocs 文檔](https://www.mkdocs.org/)

---

**最後更新**：2024-11-25

