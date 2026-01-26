#!/bin/bash
# impl-loop-guard.sh - Warns when writing implementation code without /impl-loop
#
# This hook checks if implementation code is being written in src/ or app/
# directories without using /impl-loop.

# Get the file path from environment (passed by Claude Code)
FILE_PATH="${CLAUDE_FILE_PATH:-}"

# Check if writing to implementation directories
if [[ "$FILE_PATH" =~ ^(src/|app/).*(\.ts|\.tsx)$ ]]; then
  IMPL_LOOP_MARKER="/tmp/.claude-impl-loop-active"

  if [[ ! -f "$IMPL_LOOP_MARKER" ]]; then
    echo "⚠️ WARNING: Writing to implementation code without /impl-loop"
    echo ""
    echo "Are you using /impl-loop for this implementation?"
    echo "If this is a bug fix or simple change, this warning can be ignored."
    echo ""
    echo "For new features, use: /impl-loop <feature> <tasks>"
  fi
fi

exit 0
