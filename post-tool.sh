#!/bin/bash
#
# post-tool.sh - Open the local-only blog post drafting tool
#

set -e

if [ ! -f "package.json" ] || [ ! -f "tools/post-tool.html" ]; then
  echo "Run this from the repo root."
  exit 1
fi

TOOL_PATH="$(pwd)/tools/post-tool.html"

if command -v open >/dev/null 2>&1; then
  open "$TOOL_PATH"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$TOOL_PATH"
else
  echo "Open this file in your browser:"
  echo "$TOOL_PATH"
fi
