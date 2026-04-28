#!/usr/bin/env bash
# harness init — install harness toolkit into a project
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

HARNESS_VERSION="0.1.0"
AI_TYPE=""
FORCE=false
PROJECT_ROOT="$(pwd)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ai) AI_TYPE="${2:-}"; shift 2 ;;
    --force) FORCE=true; shift ;;
    --help|-h)
      echo "Usage: harness init --ai <type> [--force]"
      echo "AI types: kiro-cli, cursor, claude, gemini, codex, opencode, windsurf, copilot"
      exit 0 ;;
    *) shift ;;
  esac
done

[[ -z "$AI_TYPE" ]] && error_exit "Missing --ai argument. Usage: harness init --ai <type>" 1

HARNESS_DIR="$PROJECT_ROOT/.harness"

if [[ -d "$HARNESS_DIR" ]] && ! $FORCE; then
  error_exit ".harness/ already exists. Use --force to overwrite." 3
fi

rm -rf "$HARNESS_DIR"
mkdir -p "$HARNESS_DIR"/{memory,templates,scripts/bash}

cp "$SCRIPT_DIR"/../../templates/*.md "$HARNESS_DIR/templates/"
cp "$SCRIPT_DIR"/common.sh "$HARNESS_DIR/scripts/bash/"
cp "$SCRIPT_DIR"/check-phase.sh "$HARNESS_DIR/scripts/bash/"
chmod +x "$HARNESS_DIR/scripts/bash/"*.sh

cat > "$HARNESS_DIR/init-options.json" <<EOF
{"ai":"$AI_TYPE","harness_version":"$HARNESS_VERSION"}
EOF

"$SCRIPT_DIR/install-prompts.sh" "$AI_TYPE" "$PROJECT_ROOT"

echo "✓ Harness installed to $HARNESS_DIR (ai: $AI_TYPE)"
