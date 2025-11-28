#!/bin/bash

# 同步 Cursor Commands 到 MkDocs
# 將 ~/.cursor/commands/ 下的文件同步到 docs/17_Cursor_Commands/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TDD_DIR="$(dirname "$SCRIPT_DIR")"
CURSOR_COMMANDS_DIR="$HOME/.cursor/commands"
TARGET_DIR="$TDD_DIR/docs/17_Cursor_Commands"

echo "🔄 同步 Cursor Commands 到 MkDocs..."
echo "來源: $CURSOR_COMMANDS_DIR"
echo "目標: $TARGET_DIR"
echo ""

# 確保目標目錄存在
mkdir -p "$TARGET_DIR"

# 複製所有 .md 文件
echo "📋 複製 Markdown 文件..."
cp -v "$CURSOR_COMMANDS_DIR"/*.md "$TARGET_DIR/" 2>/dev/null || {
    echo "⚠️  警告: 某些文件可能無法複製"
}

# 統計
COPIED_COUNT=$(ls -1 "$TARGET_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
echo ""
echo "✅ 同步完成！已複製 $COPIED_COUNT 個文件到 $TARGET_DIR"
echo ""
echo "📝 下一步："
echo "   1. 檢查文件是否正確複製"
echo "   2. 執行 'python3 -m mkdocs build' 建置文檔"
echo "   3. 執行 'python3 -m mkdocs gh-deploy' 部署到 GitHub Pages"

