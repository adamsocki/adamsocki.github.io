#!/bin/bash
#
# project-tool.sh - Open the local-only project page drafting tool
#

set -e

if [ ! -f "package.json" ] || [ ! -f "tools/project-tool.html" ]; then
  echo "Run this from the repo root."
  exit 1
fi

TOOL_PATH="$(pwd)/tools/project-tool.html"

if command -v open >/dev/null 2>&1; then
  open "$TOOL_PATH"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$TOOL_PATH"
else
  echo "Open this file in your browser:"
  echo "$TOOL_PATH"
fi
