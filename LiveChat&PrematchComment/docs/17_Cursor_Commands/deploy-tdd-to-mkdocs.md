# Deploy TDD to MkDocs

部署 TDD 文檔到 GitHub Pages。

## 使用方式

在 Cursor 中輸入：`@deploy-tdd-to-mkdocs`

或直接說：「部署 TDD 到 MkDocs」或「發布 TDD 文檔」

## 功能說明

1. 進入 TDD 目錄
2. 建置 MkDocs 文檔
3. 部署到 GitHub Pages (gh-pages branch)
4. 顯示部署狀態和網站 URL

## 執行步驟

```bash
cd /Users/reedhsin/Documents/codebase/fcom-iOS/TDDs/LiveChat\&PrematchComment

# 1. 同步 Cursor Commands（可選，如果已更新命令文件）
./scripts/sync_cursor_commands.sh

# 2. 建置並部署到 GitHub Pages
python3 -m mkdocs gh-deploy
```

## 預期輸出

- MkDocs 建置成功訊息
- 推送到 gh-pages branch 的確認
- 網站 URL: `https://hsinchunghan.github.io/LiveChatAndCommentOngoingFeature/`

## 注意事項

- 確保 repository 已設為公開
- 確保 GitHub Pages 設置選擇 "Deploy from a branch" 和 `gh-pages` branch
- 部署後需要等待 5-10 分鐘讓 GitHub Pages 完成部署
- 如果遇到問題，可以加上 `--force` 參數強制重新部署

## 相關連結

- **TDD 目錄**: `/Users/reedhsin/Documents/codebase/fcom-iOS/TDDs/LiveChat&PrematchComment`
- **GitHub Repository**: `https://github.com/HsinChungHan/LiveChatAndCommentOngoingFeature`
- **GitHub Pages URL**: `https://hsinchunghan.github.io/LiveChatAndCommentOngoingFeature/`
- **GitHub Pages 設置**: `https://github.com/HsinChungHan/LiveChatAndCommentOngoingFeature/settings/pages`

## 故障排除

如果部署失敗：
1. 檢查 repository 是否為公開
2. 確認 GitHub Pages 設置正確
3. 檢查 gh-pages branch 是否存在
4. 嘗試使用 `--force` 參數重新部署

