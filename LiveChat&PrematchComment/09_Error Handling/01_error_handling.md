# Error Handling

## 錯誤類型分類

### 1. 網路錯誤

| 錯誤類型 | HTTP Status | 說明 | 處理方式 |
|---------|------------|------|---------|
| **Network Error** | - | 網路連線失敗 | 顯示「網路連線失敗，請檢查網路設定」Toast |
| **Timeout** | - | 請求超時 | 顯示「請求超時，請稍後再試」Toast，提供重試按鈕 |
| **Server Error** | 500+ | 伺服器錯誤 | 顯示「伺服器錯誤，請稍後再試」Toast |
| **API Response Error** | - | API 回應格式錯誤（bizCode ≠ 10000） | 根據 `bizCode` 和 `message` 顯示對應錯誤訊息 |

### 2. 客戶端錯誤

| 錯誤類型 | HTTP Status | 說明 | 處理方式 |
|---------|------------|------|---------|
| **Bad Request** | 400 | 請求格式錯誤 | 顯示「請求格式錯誤」Toast，記錄錯誤日誌 |
| **Unauthorized** | 401 | 未授權 | 跳轉到登入頁面 |
| **Forbidden** | 403 | 無權限 | 顯示「無權限執行此操作」Toast |
| **Not Found** | 404 | 資源不存在 | 顯示「資源不存在」Toast |
| **Conflict** | 409 | 資源衝突 | 顯示「操作衝突，請重新整理後再試」Toast |

### 3. 業務邏輯錯誤

| 錯誤類型 | 說明 | 處理方式 |
|---------|------|---------|
| **Validation Error** | 輸入驗證失敗 | 顯示具體的驗證錯誤訊息 |
| **Business Rule Error** | 業務規則違反 | 顯示業務規則錯誤訊息 |
| **Rate Limit** | 請求頻率過高 | 顯示「操作過於頻繁，請稍後再試」Toast |
| **API BizCode Error** | API 回應 bizCode ≠ 10000 | 根據 `bizCode` 和 `message` 顯示對應錯誤訊息，記錄錯誤日誌 |

### 4. WebSocket 錯誤

| 錯誤類型 | 說明 | 處理方式 |
|---------|------|---------|
| **Connection Failed** | WebSocket 連線失敗 | 自動重連，顯示「連線中...」狀態 |
| **Connection Lost** | WebSocket 連線中斷 | 自動重連，顯示「重新連線中...」狀態 |
| **Message Parse Error** | 訊息解析失敗 | 記錄錯誤日誌，忽略該訊息 |
| **STOMP Protocol Error** | STOMP 協議錯誤（CONNECT/SUBSCRIBE 失敗） | 記錄錯誤日誌，嘗試重新建立連線 |
| **Subscription Failed** | 訂閱聊天室失敗 | 記錄錯誤日誌，重試訂閱 |

---

## 錯誤處理策略

### Repository 層

**職責**：
- 捕獲 Client 層的錯誤
- 將技術錯誤轉換為 Domain 錯誤
- 處理 API 回應中的 `bizCode` 錯誤（當 `bizCode ≠ 10000` 時）
- 不處理業務邏輯錯誤

**範例**：
```swift
func getComments(refId: String, mode: SortMode) async throws -> [Comment] {
    do {
        let response = try await client.getComments(refId, mode: mode.value)
        
        // 檢查 API 回應的 bizCode
        guard response.bizCode == 10000 else {
            throw DomainError.apiError(
                message: response.message ?? "API 請求失敗",
                bizCode: response.bizCode
            )
        }
        
        return response.data.map { Comment(from: $0) }
    } catch let error as NetworkError {
        throw DomainError.networkError(error)
    } catch let error as APIError {
        throw DomainError.apiError(error)
    } catch {
        throw DomainError.unknown(error)
    }
}
```

### UseCase 層

**職責**：
- 處理業務邏輯錯誤
- 驗證輸入參數
- 處理 Domain 錯誤並轉換為 UseCase 錯誤

**範例**：
```swift
func execute(input: PublishCommentInput) async throws -> PublishCommentOutput {
    // 驗證輸入
    guard !input.content.isEmpty else {
        throw UseCaseError.validationError("留言內容不能為空")
    }
    
    guard input.content.count <= 500 else {
        throw UseCaseError.validationError("留言內容不能超過 500 字")
    }
    
    do {
        let comment = try await repository.publishComment(
            refId: input.refId,
            content: input.content,
            parentId: input.parentId
        )
        return PublishCommentOutput(comment: comment)
    } catch let error as DomainError {
        throw UseCaseError.fromDomainError(error)
    }
}
```

### Feature 層

**職責**：
- 處理 UseCase 錯誤
- 更新 State 中的錯誤狀態
- 觸發錯誤顯示邏輯

**範例**：
```swift
case .publishCommentResponse(.failure(let error)):
    state.error = error
    state.isLoading = false
    // UI 會根據 state.error 顯示錯誤訊息
```

### View 層

**職責**：
- 顯示錯誤訊息（Toast、Alert 等）
- 提供錯誤恢復機制（重試按鈕等）

---

## 錯誤顯示方式

### Toast 訊息

適用於：
- 網路錯誤
- 伺服器錯誤
- 操作失敗

顯示時間：3 秒

### Alert 對話框

適用於：
- 需要用戶確認的錯誤
- 嚴重錯誤（如資料遺失風險）

### Inline 錯誤訊息

適用於：
- 表單驗證錯誤
- 輸入錯誤

---

## 錯誤恢復機制

### 自動重試

適用於：
- 網路錯誤（最多重試 3 次）
- WebSocket 連線中斷（自動重連）

### 手動重試

適用於：
- 伺服器錯誤
- 業務邏輯錯誤

提供「重試」按鈕，用戶可手動觸發重試。

### 降級處理

適用於：
- 非關鍵功能失敗
- 可選資料載入失敗

例如：個人資訊載入失敗時，不影響主要功能。

---

## 錯誤日誌

### 記錄時機

- 所有錯誤都應記錄日誌
- 包含錯誤類型、錯誤訊息、堆疊追蹤
- 包含用戶操作上下文

### 日誌級別

- **Error**：系統錯誤、網路錯誤
- **Warning**：業務邏輯錯誤、驗證錯誤
- **Info**：一般資訊（可選）

---

## 特殊錯誤處理

### 登入狀態檢查

當 API 回傳 401 Unauthorized 時：
1. 清除本地登入狀態
2. 跳轉到登入頁面
3. 記錄登入過期事件

### WebSocket 重連

當 WebSocket 連線中斷時：
1. 自動重連（指數退避策略）
2. 顯示「重新連線中...」狀態
3. 重連成功後重新發送 CONNECT 和 SUBSCRIBE 訊息
4. 重連成功後同步 blocked user 清單

### 黑名單清理錯誤

當黑名單清理失敗時：
1. 記錄錯誤日誌
2. 不影響主要功能
3. 下次關閉聊天室時再次嘗試清理

