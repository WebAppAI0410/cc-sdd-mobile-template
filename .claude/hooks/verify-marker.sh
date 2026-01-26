#!/bin/bash
# verify-marker.sh - Creates marker when /verify completes successfully
#
# Called after /verify command to mark that verification was done.

VERIFY_MARKER="/tmp/.claude-verify-ran-$(date +%Y%m%d)"
touch "$VERIFY_MARKER"
echo "✅ Verify marker created: $VERIFY_MARKER"
