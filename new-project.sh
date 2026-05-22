#!/bin/bash
#
# new-project.sh - Simple project page creator
#
# Usage:
#   ./new-project.sh                    # Interactive mode
#   ./new-project.sh "My Project"       # Quick mode with title
#

set -e

PROJECT_DIR="src/_projects"
DATE=$(date +%Y-%m-%d)

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//'
}

yaml_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

append_tags() {
  local raw_tags="$1"

  if [ -z "$raw_tags" ]; then
    echo "tags:"
    echo "  - \"Project\""
    return
  fi

  echo "tags:"
  echo "$raw_tags" | tr ',' '\n' | while read -r tag; do
    CLEAN_TAG=$(echo "$tag" | sed 's/^ *//; s/ *$//')
    if [ -n "$CLEAN_TAG" ]; then
      echo "  - \"$(yaml_escape "$CLEAN_TAG")\""
    fi
  done
}

if [ ! -f "package.json" ] || [ ! -d "src" ]; then
  echo "Run this from the repo root."
  exit 1
fi

mkdir -p "$PROJECT_DIR"

if [ -n "$1" ]; then
  TITLE="$1"
else
  echo -e "${CYAN}Project title?${NC}"
  read -r TITLE
fi

if [ -z "$TITLE" ]; then
  echo "Need a title. Exiting."
  exit 1
fi

DEFAULT_SLUG=$(slugify "$TITLE")
FILENAME="${PROJECT_DIR}/${DEFAULT_SLUG}.md"

if [ -f "$FILENAME" ]; then
  echo -e "${YELLOW}File already exists: ${FILENAME}${NC}"
  echo "Opening it..."
  ${EDITOR:-nano} "$FILENAME"
  exit 0
fi

echo ""
echo -e "${CYAN}One-line description?${NC}"
read -r DESCRIPTION

echo ""
echo -e "${CYAN}Status? (Active, Learning, Planning, Archived) [Active]${NC}"
read -r STATUS
STATUS=${STATUS:-Active}

echo ""
echo -e "${CYAN}Project slug? [${DEFAULT_SLUG}]${NC}"
read -r PROJECT_SLUG
PROJECT_SLUG=${PROJECT_SLUG:-$DEFAULT_SLUG}

echo ""
echo -e "${CYAN}Tags? (comma-separated, optional)${NC}"
read -r TAGS

echo ""
echo -e "${CYAN}Repo URL? (optional)${NC}"
read -r REPO_URL

echo ""
echo -e "${CYAN}Demo URL? (optional)${NC}"
read -r DEMO_URL

echo ""
echo -e "${CYAN}Featured blog post path? (optional, e.g. /posts/my-post/)${NC}"
read -r BLOG_POST

{
  echo "---"
  echo "layout: project.html"
  echo "title: \"$(yaml_escape "$TITLE")\""
  echo "description: \"$(yaml_escape "$DESCRIPTION")\""
  echo "date: ${DATE}"
  echo "status: \"$(yaml_escape "$STATUS")\""
  echo "projectSlug: \"$(yaml_escape "$PROJECT_SLUG")\""
  append_tags "$TAGS"
  if [ -n "$REPO_URL" ]; then
    echo "repoUrl: \"$(yaml_escape "$REPO_URL")\""
  else
    echo "# repoUrl: \"\""
  fi
  if [ -n "$DEMO_URL" ]; then
    echo "demoUrl: \"$(yaml_escape "$DEMO_URL")\""
  else
    echo "# demoUrl: \"\""
  fi
  echo "blogPost: \"$(yaml_escape "$BLOG_POST")\""
  echo "---"
  echo ""
  echo "# ${TITLE}"
  echo ""
  echo "## Overview"
  echo ""
  echo "## What I am building"
  echo ""
  echo "## Notes"
  echo ""
} > "$FILENAME"

echo ""
echo -e "${GREEN}Created: ${FILENAME}${NC}"
echo -e "  Slug: ${PROJECT_SLUG}"
echo -e "  Status: ${STATUS}"
echo ""
echo -e "Edit it:  ${CYAN}\${EDITOR:-nano} ${FILENAME}${NC}"
echo -e "Preview:  ${CYAN}npm start${NC}"

if [ -n "$EDITOR" ]; then
  echo ""
  echo -e "${CYAN}Opening in ${EDITOR}...${NC}"
  $EDITOR "$FILENAME"
fi
