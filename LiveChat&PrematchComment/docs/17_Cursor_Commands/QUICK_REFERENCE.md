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
                 檢查一致性
                 部署文檔
```

