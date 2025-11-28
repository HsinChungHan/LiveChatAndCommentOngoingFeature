# Update Changelog

根據今天的 git commits 更新變更日誌。

## 使用方式

直接在 Cursor 中執行此命令，或說「更新變更日誌」

## 功能

- 讀取今天的 git commits
- 對應到相關的 TDD ticket
- 生成變更記錄
- 更新 CHANGELOG.md

## 執行

請協助我：
1. 讀取今天的 git commits（使用 `git log --since="today 00:00" --oneline`）
2. 分析每個 commit 對應的 TDD ticket
3. 生成變更記錄格式
4. 更新 `14_Changelog/CHANGELOG.md`
5. 更新 `13_Implementation_Status/implementation_status.md`（如果 ticket 完成）

## 變更類型

- ✅ 完成：新功能或 Ticket 完成
- 🚧 進行中：正在進行的功能
- 🐛 Bug 修復：修復的問題
- ♻️ 重構：程式碼重構
- 📝 文件更新：TDD 或文件更新
- ⚠️ 問題發現：發現的問題或風險

## 相關文件

- `14_Changelog/CHANGELOG.md`
- `13_Implementation_Status/implementation_status.md`

