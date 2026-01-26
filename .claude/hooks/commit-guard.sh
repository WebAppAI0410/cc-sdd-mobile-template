#!/bin/bash
# commit-guard.sh - Blocks commits without /verify
#
# This hook checks if /verify was run before committing.
# It examines recent tool usage to ensure workflow compliance.

# Check for verify marker file (created by /verify command)
VERIFY_MARKER="/tmp/.claude-verify-ran-$(date +%Y%m%d)"

if [[ ! -f "$VERIFY_MARKER" ]]; then
  echo "⛔ WORKFLOW VIOLATION: /verify was not run before commit"
  echo ""
  echo "Run /verify first, then commit."
  echo ""
  echo "Workflow: 実装 → /verify → コミット"
  exit 1
fi

# Check if marker is recent (within last 30 minutes)
if [[ $(find "$VERIFY_MARKER" -mmin +30 2>/dev/null) ]]; then
  echo "⚠️ WARNING: /verify was run more than 30 minutes ago"
  echo "Consider running /verify again before committing."
fi

echo "✅ /verify confirmed. Proceeding with commit."
exit 0
