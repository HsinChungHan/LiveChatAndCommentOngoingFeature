# Check TDD Consistency

檢查實作與 TDD 文件的一致性。

## 使用方式

直接在 Cursor 中執行此命令，或說「檢查 TDD 一致性」

## 功能

- 檢查實作檔案是否存在
- 檢查實作是否符合 TDD 規範
- 檢查是否有遺漏的功能
- 提供改進建議

## 執行

請協助我檢查指定 ticket 的實作與 TDD 一致性：

1. 讀取 TDD ticket 文件（例如：`12_Tickets/01_domain_model/TDD-001_Comment_Entity.md`）
2. 檢查實作檔案是否存在（根據 TDD 文件中的檔案結構）
3. 檢查實作是否符合 TDD 規範：
   - 命名規範
   - 檔案結構
   - 功能完整性
   - 測試覆蓋率
4. 檢查是否有遺漏的功能
5. 提供改進建議

## 使用範例

檢查 TDD-001：
```
請檢查 TDD-001 的實作是否與 TDD 文件一致
```

檢查多個 tickets：
```
請檢查 TDD-001, TDD-002, TDD-003 的實作是否與 TDD 文件一致
```

## 相關文件

- `12_Tickets/` - TDD ticket 文件
- `13_Implementation_Status/implementation_status.md` - 實作狀態

