#!/bin/bash
#
# code-adjust.sh — Build, commit, and push site code/template/style changes
#
# Usage:
#   ./code-adjust.sh                     # Auto message: "site code update"
#   ./code-adjust.sh "custom message"    # Use a custom commit message
#

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ ! -f "package.json" ] || [ ! -d "src" ]; then
  echo -e "${RED}Run this from the repo root (where package.json is).${NC}"
  exit 1
fi

CODE_PATHS=(
  ".eleventy.js"
  "netlify.toml"
  "package.json"
  "package-lock.json"
  "README.md"
  "CLAUDE.md"
  "src/_includes"
  "src/_layouts"
  "src/_skills"
  "src/css"
  "src/index.html"
  "src/blog-list.html"
  "src/projects-list.html"
  "src/skills-list.html"
  "src/tags.html"
  "content.sh"
  "new-post.sh"
  "new-project.sh"
  "post-tool.sh"
  "project-tool.sh"
  "publish.sh"
  "code-adjust.sh"
  "tools"
)

CHANGED=$(git status --porcelain -- "${CODE_PATHS[@]}" 2>/dev/null)

if [ -z "$CHANGED" ]; then
  echo -e "${YELLOW}No site code changes to publish.${NC}"
  exit 0
fi

echo -e "${CYAN}Code changes to publish:${NC}"
echo "$CHANGED" | while read line; do
  echo -e "  ${GREEN}${line}${NC}"
done
echo ""

if [ -n "$1" ]; then
  MSG="$1"
else
  MSG="site code update"
fi

echo -e "${CYAN}Commit message:${NC} ${MSG}"
echo ""

echo -e "${CYAN}Building site before publish...${NC}"
npm run build
echo ""

git add -- "${CODE_PATHS[@]}"

git commit -m "$MSG"

echo ""
echo -e "${CYAN}Pushing to remote...${NC}"
git push

echo ""
echo -e "${GREEN}Published code changes. Your site will update after deploy finishes.${NC}"
