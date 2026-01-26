#!/bin/bash
# session-start-reminder.sh - Reminds to use claude-mem at session start
#
# This hook outputs a reminder to search claude-mem for context.

cat << 'EOF'
🚀 Claude Code Ready | /verify で検証 | /simplify で簡潔化 | Context7 MCP利用可能

☠️ WORKFLOW REMINDER (違反したら死):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. claude-mem でコンテキスト取得（必須）
   mcp__plugin_claude-mem_mcp-search__search("SDD workflow")

2. 新機能実装は必ず /impl-loop を使用

3. コミット前は必ず /verify を実行

4. 「自律的に」= ワークフロースキップ許可 ではない
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
