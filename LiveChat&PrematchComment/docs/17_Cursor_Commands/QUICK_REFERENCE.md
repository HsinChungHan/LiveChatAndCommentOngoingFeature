# Cursor Commands 快速參考

## 🚀 一鍵命令

### 每天開始
```bash
@daily-start
```
自動執行：生成計劃 + 建立日誌

### 每天結束
```bash
@daily-end
```
自動執行：統整工作 + 統整對話

---

## 📋 完整命令列表

### 早上流程
1. `@daily-start` - 開始今天的工作
2. `@generate-daily-plan` - 生成工作計劃
3. `@create-daily-log` - 建立工作日誌

### 實作流程
4. `@update-implementation-status` - 更新實作狀態
5. `@update-changelog` - 更新變更日誌
6. `@check-tdd-consistency` - 檢查 TDD 一致性
7. `@deploy-tdd-to-mkdocs` - 部署到 MkDocs

### 晚上流程
8. `@review-cursor-conversations` - 統整對話
9. `@summarize-daily-work` - 統整當天工作
10. `@daily-end` - 結束今天的工作

---

## ⏰ 使用時機

```
09:00 ──> @daily-start
         ├─> @generate-daily-plan
         └─> @create-daily-log

09:30-17:00 ──> 實作循環
         ├─> @update-implementation-status (完成 ticket)
         ├─> @update-changelog (有變更)
         ├─> @check-tdd-consistency (完成功能)
         └─> @deploy-tdd-to-mkdocs (需要發布)

17:30 ──> @daily-end
         ├─> @review-cursor-conversations
         └─> @summarize-daily-work
```

---

## 📊 流程圖

```
開始 → daily-start → 實作循環 → daily-end → 結束
         ↓              ↓            ↓
     生成計劃      更新狀態      統整工作
     建立日誌      記錄變更      統整對話
                 檢查一致性      更新 mkdocs.yml
                 部署文檔        部署到 GitHub Pages
```

---

## 🎯 快速參考表

| 時機 | 命令 | 頻率 | 說明 |
|------|------|------|------|
| 每天開始 | `daily-start` | 每天1次 | 開始工作 |
| 每天開始 | `generate-daily-plan` | 每天1次 | 生成計劃 |
| 每天開始 | `create-daily-log` | 每天1次 | 建立日誌 |
| 實作中 | `update-implementation-status` | 完成 ticket 後 | 更新狀態 |
| 實作中 | `update-changelog` | 有變更時 | 記錄變更 |
| 實作中 | `check-tdd-consistency` | 完成功能後 | 檢查一致性 |
| 實作中 | `deploy-tdd-to-mkdocs` | 需要發布時 | 部署文檔 |
| 每天結束 | `review-cursor-conversations` | 每天1次 | 統整對話 |
| 每天結束 | `summarize-daily-work` | 每天1次 | 統整工作 |
| 每天結束 | `daily-end` | 每天1次 | 結束工作（**需手動更新 mkdocs.yml 並部署**） |

### ✅ 自動化說明

**`daily-end` 命令現在會自動更新 `mkdocs.yml`**：

1. **自動更新**: `summarize_daily_work.sh` 會自動掃描 `15_Daily_Logs/` 目錄並更新 `mkdocs.yml`
2. **手動部署**: 仍需手動執行 `@deploy-tdd-to-mkdocs` 部署到 GitHub Pages

**更新腳本**: `scripts/update_mkdocs_nav.sh` - 可單獨執行以更新導航配置

