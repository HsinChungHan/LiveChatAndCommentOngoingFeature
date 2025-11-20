# GitBook 部署指南

本指南說明如何將 TDD 文件部署到 GitBook。

## 方式一：使用 GitBook.com（推薦）

GitBook.com 是 GitBook 的官方平台，支援直接連接 GitHub repository。

### 步驟 1：推送代碼到 GitHub

```bash
# 確保所有更改已提交
git add .
git commit -m "Add TDD documentation"

# 推送到 GitHub
git push -u origin main
```

### 步驟 2：在 GitBook.com 創建 Space

1. 前往 [GitBook.com](https://www.gitbook.com/) 並登入（或註冊）
2. 點擊右上角的 **"New Space"** 或 **"Create"**
3. 選擇 **"Import from GitHub"**
4. 授權 GitBook 訪問您的 GitHub 帳號
5. 選擇 repository：`HsinChungHan/Ex-TDDToIn-TDD`
6. 選擇要同步的目錄：`output/LiveChat&PrematchComment`
7. 點擊 **"Import"**

### 步驟 3：配置 GitBook Space

1. 在 GitBook Space 設定中：
   - **Root path**: 設定為 `output/LiveChat&PrematchComment`
   - **Branch**: 設定為 `main`
   - **Summary file**: 確認使用 `SUMMARY.md`

2. GitBook 會自動偵測 `SUMMARY.md` 並生成導航結構

### 步驟 4：發布

1. 在 GitBook Space 中點擊 **"Publish"**
2. 選擇公開或私有
3. 獲取公開連結或自訂域名

## 方式二：使用 GitBook CLI（舊版，不推薦）

> ⚠️ **注意**：GitBook CLI 已停止維護，建議使用 GitBook.com 平台。

### 安裝 GitBook CLI

```bash
npm install -g gitbook-cli
```

### 初始化 GitBook

```bash
cd output/LiveChat&PrematchComment
gitbook install
```

### 本地預覽

```bash
gitbook serve
```

### 建置靜態網站

```bash
gitbook build
```

生成的網站會在 `_book/` 目錄下。

## Mermaid 圖表支援

### GitBook.com

GitBook.com 原生支援 Mermaid 圖表，無需額外配置。只需在 Markdown 中使用：

````markdown
```mermaid
sequenceDiagram
    ...
```
````

### GitBook CLI

如果使用 GitBook CLI，需要安裝 `mermaid-gb3` 插件（已在 `book.json` 中配置）：

```bash
cd output/LiveChat&PrematchComment
gitbook install
```

## 注意事項

1. **路徑問題**：GitBook.com 需要指定正確的 root path（`output/LiveChat&PrematchComment`）
2. **SUMMARY.md**：必須存在於 root path 下，用於定義導航結構
3. **Mermaid 語法**：確保 Mermaid 代碼塊使用正確的語法（已修正 `&lt;` 和 `&gt;` 問題）
4. **檔案編碼**：確保所有 Markdown 檔案使用 UTF-8 編碼

## 自動同步

GitBook.com 支援自動同步 GitHub repository：

- 當您 push 到 GitHub 時，GitBook 會自動更新
- 更新頻率可在 Space 設定中調整

## 疑難排解

### Mermaid 圖表無法顯示

1. 檢查 Mermaid 語法是否正確
2. 確認沒有使用 HTML 實體編碼（`&lt;`、`&gt;`）
3. 使用引號包裹特殊字元：`"<PersonalPageAdapter>"`

### 導航結構不正確

1. 確認 `SUMMARY.md` 存在於 root path
2. 檢查 `SUMMARY.md` 中的路徑是否正確
3. 路徑中的空格和特殊字元需要使用 URL 編碼（`%20`、`%26` 等）

### 檔案無法找到

1. 確認 root path 設定正確
2. 檢查檔案路徑是否與 `SUMMARY.md` 中的路徑一致
3. 確認檔案已推送到 GitHub

## 相關資源

- [GitBook 官方文檔](https://docs.gitbook.com/)
- [GitBook GitHub 整合](https://docs.gitbook.com/integrations/github)
- [Mermaid 語法文檔](https://mermaid.js.org/)

