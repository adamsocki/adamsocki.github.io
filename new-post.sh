#!/bin/bash
#
# new-post.sh — Zero-friction blog post creator
#
# Usage:
#   ./new-post.sh                    # Interactive mode
#   ./new-post.sh "My Post Title"    # Quick mode with title
#   ./new-post.sh --devlog           # Quick devlog entry
#   ./new-post.sh --til              # Quick TIL entry
#   ./new-post.sh --update           # Quick status update
#

set -e
BLOG_DIR="src/blog"
DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%Y-%m-%d\ %H:%M)

# Colors for output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get list of project slugs from existing project files
get_project_slugs() {
  grep -rh "projectSlug:" src/_projects/*.md 2>/dev/null | sed 's/.*projectSlug: *"\{0,1\}\([^"]*\)"\{0,1\}/\1/' | sort
}

# Quick mode flags
POST_TYPE="article"
QUICK_MODE=false

case "${1}" in
  --devlog)
    POST_TYPE="devlog"
    QUICK_MODE=true
    shift
    ;;
  --til)
    POST_TYPE="til"
    QUICK_MODE=true
    shift
    ;;
  --update)
    POST_TYPE="update"
    QUICK_MODE=true
    shift
    ;;
esac

# Get title
if [ -n "$1" ]; then
  TITLE="$1"
else
  if [ "$QUICK_MODE" = true ]; then
    echo -e "${CYAN}Quick ${POST_TYPE} — what's it about?${NC}"
  else
    echo -e "${CYAN}What's the title?${NC}"
  fi
  read -r TITLE
fi

if [ -z "$TITLE" ]; then
  echo "Need a title. Exiting."
  exit 1
fi

# Generate filename from title
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
FILENAME="${BLOG_DIR}/${SLUG}.md"

# Check if file exists
if [ -f "$FILENAME" ]; then
  echo -e "${YELLOW}File already exists: ${FILENAME}${NC}"
  echo "Opening it..."
  ${EDITOR:-nano} "$FILENAME"
  exit 0
fi

# Ask for project (optional)
echo ""
echo -e "${CYAN}Link to a project? (leave blank for none)${NC}"
SLUGS=$(get_project_slugs)
if [ -n "$SLUGS" ]; then
  echo -e "  Available: ${GREEN}${SLUGS}${NC}"
fi
read -r PROJECT

# For articles, ask for description
DESCRIPTION=""
if [ "$POST_TYPE" = "article" ]; then
  echo ""
  echo -e "${CYAN}One-line description? (optional, press enter to skip)${NC}"
  read -r DESCRIPTION
fi

# Build the file
cat > "$FILENAME" << FRONTMATTER
---
title: "${TITLE}"
date: ${DATE}
type: ${POST_TYPE}
FRONTMATTER

if [ -n "$PROJECT" ]; then
  echo "project: ${PROJECT}" >> "$FILENAME"
fi

if [ -n "$DESCRIPTION" ]; then
  echo "description: \"${DESCRIPTION}\"" >> "$FILENAME"
fi

echo "---" >> "$FILENAME"
echo "" >> "$FILENAME"

# Add starter content based on type
case "$POST_TYPE" in
  devlog)
    cat >> "$FILENAME" << 'CONTENT'
## What I worked on

## What I learned

## Next up

CONTENT
    ;;
  til)
    cat >> "$FILENAME" << 'CONTENT'
## TIL

## Why it matters

## Links

CONTENT
    ;;
  update)
    cat >> "$FILENAME" << 'CONTENT'
## Status

## What changed

CONTENT
    ;;
  article)
    echo "# ${TITLE}" >> "$FILENAME"
    echo "" >> "$FILENAME"
    echo "" >> "$FILENAME"
    ;;
esac

echo ""
echo -e "${GREEN}Created: ${FILENAME}${NC}"
echo -e "  Type: ${POST_TYPE}"
[ -n "$PROJECT" ] && echo -e "  Project: ${PROJECT}"
echo ""
echo -e "Edit it:  ${CYAN}\${EDITOR:-nano} ${FILENAME}${NC}"
echo -e "Preview:  ${CYAN}npm start${NC}"

# Open in editor if EDITOR is set
if [ -n "$EDITOR" ]; then
  echo ""
  echo -e "${CYAN}Opening in ${EDITOR}...${NC}"
  $EDITOR "$FILENAME"
fi
