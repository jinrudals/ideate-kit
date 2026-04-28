#!/usr/bin/env bash
# Harness toolkit — shared utilities
set -euo pipefail

find_harness_dir() {
  local dir="${1:-$(pwd)}"
  while [[ "$dir" != "/" ]]; do
    [[ -d "$dir/.harness" ]] && { echo "$dir/.harness"; return 0; }
    dir="$(dirname "$dir")"
  done
  return 1
}

check_file_exists() {
  local file="$1" label="${2:-$1}"
  [[ -f "$file" ]] && return 0
  echo "ERROR: Required file not found: $label" >&2
  return 1
}

json_output() {
  # Usage: json_output key1 val1 key2 val2 ...
  local out="{"
  local first=true
  while [[ $# -ge 2 ]]; do
    $first && first=false || out+=","
    out+="\"$1\":\"$2\""
    shift 2
  done
  echo "${out}}"
}

json_output_raw() {
  # Like json_output but values are not quoted (for booleans, arrays)
  local out="{"
  local first=true
  while [[ $# -ge 2 ]]; do
    $first && first=false || out+=","
    out+="\"$1\":$2"
    shift 2
  done
  echo "${out}}"
}

error_exit() {
  echo "ERROR: $1" >&2
  exit "${2:-1}"
}
