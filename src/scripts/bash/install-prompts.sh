#!/usr/bin/env bash
# Deploy harness prompts to AI-specific locations
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

AI_TYPE="${1:-}"
PROJECT_ROOT="${2:-$(pwd)}"
PROMPTS_SRC="$SCRIPT_DIR/../../prompts"

[[ -z "$AI_TYPE" ]] && error_exit "Usage: install-prompts.sh <ai-type> [project-root]" 1
[[ -d "$PROMPTS_SRC" ]] || error_exit "Prompts source not found: $PROMPTS_SRC" 1

install_as_copy() {
  local dest_dir="$1" prefix="$2" ext="$3"
  mkdir -p "$dest_dir"
  for f in "$PROMPTS_SRC"/harness.*.md; do
    local name
    name=$(basename "$f")
    cp "$f" "$dest_dir/${prefix}${name%.md}${ext}"
  done
}

install_cursor() {
  local dest_dir="$PROJECT_ROOT/.cursor/rules"
  mkdir -p "$dest_dir"
  for f in "$PROMPTS_SRC"/harness.*.md; do
    local name
    name=$(basename "$f" .md)
    local dest="$dest_dir/${name}.mdc"
    {
      echo "---"
      echo "description: Harness - ${name#harness.}"
      echo "globs: [\"**/*\"]"
      echo "alwaysApply: true"
      echo "---"
      echo ""
      cat "$f"
    } > "$dest"
  done
}

install_append() {
  local dest_file="$1"
  mkdir -p "$(dirname "$dest_file")"
  for f in "$PROMPTS_SRC"/harness.*.md; do
    {
      echo ""
      echo "<!-- harness: $(basename "$f") -->"
      cat "$f"
      echo "<!-- /harness -->"
    } >> "$dest_file"
  done
}

case "$AI_TYPE" in
  kiro-cli)    install_as_copy "$PROJECT_ROOT/.kiro/prompts" "" ".md" ;;
  cursor)      install_cursor ;;
  claude)      install_append "$PROJECT_ROOT/CLAUDE.md" ;;
  gemini)      install_append "$PROJECT_ROOT/GEMINI.md" ;;
  codex|opencode) install_append "$PROJECT_ROOT/AGENTS.md" ;;
  windsurf)    install_as_copy "$PROJECT_ROOT/.windsurf/rules" "" ".md" ;;
  copilot)     install_as_copy "$PROJECT_ROOT/.github/agents" "" ".md" ;;
  *)           error_exit "Unknown AI type: $AI_TYPE. Supported: kiro-cli, cursor, claude, gemini, codex, opencode, windsurf, copilot" 2 ;;
esac

echo "✓ Prompts deployed for $AI_TYPE"
