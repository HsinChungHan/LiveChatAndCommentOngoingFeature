# GitHub SSH Key 設定指南

## 已生成的 SSH Key

您的 SSH key 已生成並保存在：
- **私鑰**: `~/.ssh/id_ed25519`
- **公鑰**: `~/.ssh/id_ed25519.pub`

## 將 SSH Key 添加到 GitHub

### 步驟 1：複製 SSH Public Key

您的 SSH public key 已自動複製到剪貼簿。如果沒有，請執行：

```bash
cat ~/.ssh/id_ed25519.pub | pbcopy
```

或者手動複製以下內容：

```
（您的 SSH public key 內容會顯示在上方）
```

### 步驟 2：添加到 GitHub

1. 前往 [GitHub SSH Settings](https://github.com/settings/keys)
2. 點擊右上角的 **"New SSH key"** 按鈕
3. 填寫表單：
   - **Title**: 輸入一個描述性名稱（例如：`MacBook Pro` 或 `Development Machine`）
   - **Key**: 貼上剛才複製的 SSH public key（以 `ssh-ed25519` 開頭）
4. 點擊 **"Add SSH key"**
5. 如果需要，輸入您的 GitHub 密碼確認

### 步驟 3：測試 SSH 連接

執行以下命令測試 SSH 連接：

```bash
ssh -T git@github.com
```

如果成功，您會看到類似以下的訊息：
```
Hi [您的 GitHub 用戶名]! You've successfully authenticated, but GitHub does not provide shell access.
```

## 更新 Git Remote URL

如果您的 repository 目前使用 HTTPS，需要改為 SSH：

```bash
cd /Users/reedhsin/Documents/MermaidToTDD
git remote set-url origin git@github.com:HsinChungHan/Ex-TDDToIn-TDD.git
```

驗證 remote URL：

```bash
git remote -v
```

應該顯示：
```
origin  git@github.com:HsinChungHan/Ex-TDDToIn-TDD.git (fetch)
origin  git@github.com:HsinChungHan/Ex-TDDToIn-TDD.git (push)
```

## 推送代碼

現在您可以使用 SSH 推送代碼，無需輸入密碼：

```bash
git push -u origin main
```

## 疑難排解

### 如果 SSH 連接失敗

1. **檢查 SSH agent**：
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```

2. **檢查 SSH 配置**：
   確保 `~/.ssh/config` 文件存在且配置正確：
   ```bash
   cat ~/.ssh/config
   ```
   
   如果不存在，創建一個：
   ```bash
   cat >> ~/.ssh/config << EOF
   Host github.com
     AddKeysToAgent yes
     UseKeychain yes
     IdentityFile ~/.ssh/id_ed25519
   EOF
   ```

3. **將 key 添加到 macOS Keychain**：
   ```bash
   ssh-add --apple-use-keychain ~/.ssh/id_ed25519
   ```

### 如果仍然無法連接

1. 確認 GitHub 上的 SSH key 已正確添加
2. 檢查 key 的權限：
   ```bash
   chmod 600 ~/.ssh/id_ed25519
   chmod 644 ~/.ssh/id_ed25519.pub
   ```
3. 查看詳細的 SSH 連接日誌：
   ```bash
   ssh -vT git@github.com
   ```

## 相關資源

- [GitHub SSH Key 文檔](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [生成新的 SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

