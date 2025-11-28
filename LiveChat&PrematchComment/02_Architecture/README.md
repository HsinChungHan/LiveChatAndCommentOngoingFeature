# Architecture 章節說明

本目錄包含 TDD 文件的 Architecture 章節，提供系統架構圖和架構說明。

## 文件列表

- `01_clean_architecture_diagram.md` - Clean Architecture 架構圖

## 說明

Architecture 章節包含：

- 垂直 Clean Architecture 圖
- 各 Layer 的職責說明
- 依賴方向說明
- 模組關係圖

## 架構層級

1. **UI Layer**：View 層
2. **Domain Layer**：Feature + UseCase 層
3. **Data & Infrastructure Layer**：Repository + Client + API 層
4. **Domain Model Layer**：Entity + Value Object 層

## 依賴方向

**UI → Feature → UseCase → Repository → Client → API**

禁止越層呼叫。

