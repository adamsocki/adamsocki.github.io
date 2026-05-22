#!/bin/bash
#
# publish.sh — Stage, commit, and push blog changes in one shot
#
# Usage:
#   ./publish.sh                     # Auto-detects new/changed posts
#   ./publish.sh "custom message"    # Use a custom commit message
#

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check we're in the right place
if [ ! -f "package.json" ] || [ ! -d "src/blog" ]; then
  echo -e "${RED}Run this from the repo root (where package.json is).${NC}"
  exit 1
fi

# Check for changes
CHANGED=$(git status --porcelain src/blog/ src/_projects/ 2>/dev/null)

if [ -z "$CHANGED" ]; then
  echo -e "${YELLOW}No new or changed posts to publish.${NC}"
  exit 0
fi

# Show what's being published
echo -e "${CYAN}Changes to publish:${NC}"
echo "$CHANGED" | while read line; do
  echo -e "  ${GREEN}${line}${NC}"
done
echo ""

# Build commit message
if [ -n "$1" ]; then
  MSG="$1"
else
  # Auto-generate message from changed files
  NEW_POSTS=$(echo "$CHANGED" | grep "src/blog/" | sed 's/.*src\/blog\///' | sed 's/\.md$//' | tr '\n' ', ' | sed 's/,$//')
  if [ -n "$NEW_POSTS" ]; then
    MSG="blog: ${NEW_POSTS}"
  else
    MSG="site update"
  fi
fi

echo -e "${CYAN}Commit message:${NC} ${MSG}"
echo ""

echo -e "${CYAN}Building site before publish...${NC}"
npm run build
echo ""

# Stage blog and project changes
git add src/blog/ src/_projects/

# Commit
git commit -m "$MSG"

# Push
echo ""
echo -e "${CYAN}Pushing to remote...${NC}"
git push

echo ""
echo -e "${GREEN}Published! Your site will update in a minute or two.${NC}"
