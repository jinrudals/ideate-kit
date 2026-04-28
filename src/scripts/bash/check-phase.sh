#!/usr/bin/env bash
# Validate prerequisites for a harness phase
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

JSON_MODE=false
PHASE=""

for arg in "$@"; do
  case "$arg" in
    --json) JSON_MODE=true ;;
    --help|-h)
      echo "Usage: check-phase.sh <phase> [--json]"
      echo "Phases: ideate, clarify, domain, architect, research, scaffold, handoff"
      exit 0 ;;
    -*) error_exit "Unknown option: $arg" 1 ;;
    *) PHASE="$arg" ;;
  esac
done

[[ -z "$PHASE" ]] && error_exit "Phase name required. Usage: check-phase.sh <phase> [--json]" 1

HARNESS_DIR="$(find_harness_dir)" || error_exit ".harness/ directory not found" 2
MEMORY_DIR="$HARNESS_DIR/memory"

# Prerequisite matrix
declare -A REQUIRED OPTIONAL
REQUIRED[ideate]=""
REQUIRED[clarify]="system-vision.md"
REQUIRED[domain]="system-vision.md"
REQUIRED[architect]="system-vision.md domain-model.md"
REQUIRED[research]="system-architecture.md"
REQUIRED[scaffold]="system-vision.md domain-model.md system-architecture.md"
REQUIRED[handoff]="system-vision.md domain-model.md system-architecture.md"
OPTIONAL[scaffold]="research-findings.md"
OPTIONAL[handoff]="research-findings.md"

[[ -z "${REQUIRED[$PHASE]+x}" ]] && error_exit "Unknown phase: $PHASE. Valid: ideate, clarify, domain, architect, research, scaffold, handoff" 1

missing=()
available=()

for file in ${REQUIRED[$PHASE]}; do
  if [[ -f "$MEMORY_DIR/$file" ]]; then
    available+=("$file")
  else
    missing+=("$file")
  fi
done

for file in ${OPTIONAL[$PHASE]:-}; do
  [[ -f "$MEMORY_DIR/$file" ]] && available+=("$file")
done

ready=true
[[ ${#missing[@]} -gt 0 ]] && ready=false

if $JSON_MODE; then
  avail_json="[]"
  miss_json="[]"
  if [[ ${#available[@]} -gt 0 ]]; then
    avail_json="[$(printf '"%s",' "${available[@]}" | sed 's/,$//')]"
  fi
  if [[ ${#missing[@]} -gt 0 ]]; then
    miss_json="[$(printf '"%s",' "${missing[@]}" | sed 's/,$//')]"
  fi
  json_output_raw \
    "phase" "\"$PHASE\"" \
    "ready" "$ready" \
    "harness_dir" "\"$HARNESS_DIR\"" \
    "memory_dir" "\"$MEMORY_DIR\"" \
    "available" "$avail_json" \
    "missing" "$miss_json"
else
  echo "Phase: $PHASE"
  echo "Ready: $ready"
  echo "Harness: $HARNESS_DIR"
  if [[ ${#available[@]} -gt 0 ]]; then
    echo "Available: ${available[*]}"
  fi
  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Missing: ${missing[*]}"
    # Suggest which phase to run
    for m in "${missing[@]}"; do
      case "$m" in
        system-vision.md) echo "  → Run harness.ideate first" ;;
        domain-model.md) echo "  → Run harness.domain first" ;;
        system-architecture.md) echo "  → Run harness.architect first" ;;
      esac
    done
  fi
fi

$ready || exit 1
