#!/bin/bash
#
# content.sh - One menu for creating and publishing site content
#
# Usage:
#   ./content.sh
#   ./content.sh post "My Post"
#   ./content.sh project "My Project"
#   ./content.sh publish "commit message"
#

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

run_choice() {
  case "$1" in
    post|article)
      shift
      exec bash new-post.sh "$@"
      ;;
    devlog)
      shift
      exec bash new-post.sh --devlog "$@"
      ;;
    til)
      shift
      exec bash new-post.sh --til "$@"
      ;;
    update)
      shift
      exec bash new-post.sh --update "$@"
      ;;
    project)
      shift
      exec bash new-project.sh "$@"
      ;;
    skill)
      shift
      exec bash new-skill.sh "$@"
      ;;
    employment)
      shift
      exec bash new-employment.sh "$@"
      ;;
    publish)
      shift
      exec bash publish.sh "$@"
      ;;
    *)
      echo "Unknown content action: $1"
      echo "Use: post, devlog, til, update, project, skill, employment, publish"
      exit 1
      ;;
  esac
}

if [ -n "$1" ]; then
  run_choice "$@"
fi

echo -e "${CYAN}What do you want to do?${NC}"
echo "  1) article post"
echo "  2) devlog"
echo "  3) TIL"
echo "  4) update"
echo "  5) project"
echo "  6) skill"
echo "  7) employment"
echo "  8) publish"
echo ""
echo -e "${GREEN}Choose 1-8:${NC}"
read -r CHOICE

case "$CHOICE" in
  1) run_choice post ;;
  2) run_choice devlog ;;
  3) run_choice til ;;
  4) run_choice update ;;
  5) run_choice project ;;
  6) run_choice skill ;;
  7) run_choice employment ;;
  8) run_choice publish ;;
  *) echo "No matching choice. Exiting."; exit 1 ;;
esac
