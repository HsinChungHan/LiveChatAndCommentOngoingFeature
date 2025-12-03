#!/bin/bash

# 自動更新 mkdocs.yml 中的 Daily Logs 和 Daily Plans 導航
# 使用方法: ./update_mkdocs_nav.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MKDOCS_FILE="$SCRIPT_DIR/mkdocs.yml"
DAILY_LOGS_DIR="$SCRIPT_DIR/15_Daily_Logs"
DAILY_PLANS_DIR="$SCRIPT_DIR/16_Cursor_Workflow/daily_plans"

# 檢查 mkdocs.yml 是否存在
if [ ! -f "$MKDOCS_FILE" ]; then
    echo "❌ 錯誤: 找不到 mkdocs.yml: $MKDOCS_FILE"
    exit 1
fi

# 檢查目錄是否存在
if [ ! -d "$DAILY_LOGS_DIR" ]; then
    echo "❌ 錯誤: 找不到 Daily Logs 目錄: $DAILY_LOGS_DIR"
    exit 1
fi

if [ ! -d "$DAILY_PLANS_DIR" ]; then
    echo "❌ 錯誤: 找不到 Daily Plans 目錄: $DAILY_PLANS_DIR"
    exit 1
fi

# 使用 Python 來更新 YAML 文件（更可靠）
python3 <<PYTHON_SCRIPT
import re
from pathlib import Path

mkdocs_file = "$MKDOCS_FILE"
daily_logs_dir = "$DAILY_LOGS_DIR"
daily_plans_dir = "$DAILY_PLANS_DIR"

# 讀取 mkdocs.yml
with open(mkdocs_file, 'r', encoding='utf-8') as f:
    content = f.read()

# ===== 更新 Daily Logs =====
# 找到所有工作日誌文件（格式：YYYY-MM-DD.md）
daily_log_files = sorted(Path(daily_logs_dir).glob("20*.md"))

# 構建新的 Daily Logs 導航列表
daily_logs_nav = [
    "15_Daily_Logs/README.md",
    "15_Daily_Logs/TEMPLATE.md",
    "15_Daily_Logs/WORKFLOW.md",
    "15_Daily_Logs/FORMAT_RULES.md"
]

# 添加所有工作日誌文件
for file in daily_log_files:
    rel_path = str(file.relative_to(Path(mkdocs_file).parent))
    rel_path = rel_path.replace(chr(92), '/')  # Windows 兼容性（反斜線）
    daily_logs_nav.append(rel_path)

# 構建新的 Daily Logs 導航內容
new_daily_logs_section = "  - Daily Logs:\n"
for item in daily_logs_nav:
    new_daily_logs_section += f"    - {item}\n"

# 使用正則表達式替換 Daily Logs 部分
pattern = r'  - Daily Logs:.*?(?=\n  - [A-Z]|\Z)'
content = re.sub(pattern, new_daily_logs_section, content, flags=re.DOTALL)

print(f"✅ 已更新 Daily Logs，加入 {len(daily_log_files)} 個工作日誌文件")

# ===== 更新 Daily Plans =====
# 找到所有工作計劃文件（格式：YYYY-MM-DD.md）
daily_plan_files = sorted(Path(daily_plans_dir).glob("20*.md"))

# 構建新的 Daily Plans 導航列表
daily_plans_nav = []
for file in daily_plan_files:
    rel_path = str(file.relative_to(Path(mkdocs_file).parent))
    rel_path = rel_path.replace(chr(92), '/')  # Windows 兼容性（反斜線）
    daily_plans_nav.append(rel_path)

# 構建新的 Daily Plans 導航內容
# 注意：縮進是 4 個空格（不是 6 個）
new_daily_plans_section = "    - Daily Plans:\n"
for item in daily_plans_nav:
    new_daily_plans_section += f"      - {item}\n"

# 使用正則表達式替換 Daily Plans 部分
# 找到 "    - Daily Plans:" 到下一個同級別項目或父級項目
# 注意：縮進是 4 個空格（不是 6 個）
pattern = r'    - Daily Plans:.*?(?=\n    - [A-Z]|\n  - [A-Z]|\Z)'
content = re.sub(pattern, new_daily_plans_section, content, flags=re.DOTALL)

print(f"✅ 已更新 Daily Plans，加入 {len(daily_plan_files)} 個工作計劃文件")

# 寫回文件
with open(mkdocs_file, 'w', encoding='utf-8') as f:
    f.write(content)

print("")
print("📝 更新的文件：")
for file in daily_log_files:
    print(f"   Daily Logs: {file.name}")
for file in daily_plan_files:
    print(f"   Daily Plans: {file.name}")
PYTHON_SCRIPT

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ mkdocs.yml 更新成功！"
    echo ""
    echo "下一步：執行部署命令"
    echo "  python3 -m mkdocs gh-deploy"
else
    echo "❌ 更新失敗"
    exit 1
fi

