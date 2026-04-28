#!/bin/sh
# Install ideate-kit globally
# Usage: curl -fsSL https://raw.githubusercontent.com/jinrudals/ideate-kit/main/install.sh | sh
set -eu

REPO="jinrudals/ideate-kit"
BRANCH="main"
INSTALL_DIR="${IDEATEKIT_HOME:-/usr/local/share/ideate-kit}"
BIN_DIR="${IDEATEKIT_BIN:-/usr/local/bin}"

info()  { echo "  $*"; }
error() { echo "ERROR: $*" >&2; exit 1; }

# Download source
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

info "Downloading ideate-kit..."
curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar -xz -C "$TMPDIR"
SRC="$TMPDIR/ideate-kit-$BRANCH"

[ -d "$SRC/src" ] || error "Download failed"

# Install data
info "Installing to $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"
sudo cp -r "$SRC/src/prompts" "$SRC/src/templates" "$SRC/src/scripts" "$INSTALL_DIR/"
sudo chmod +x "$INSTALL_DIR/scripts/bash/"*.sh

# Create wrapper
sudo mkdir -p "$BIN_DIR"
sudo tee "$BIN_DIR/harness" > /dev/null <<'WRAPPER'
#!/usr/bin/env bash
set -euo pipefail
INSTALL_DIR="${IDEATEKIT_HOME:-/usr/local/share/ideate-kit}"
CMD="${1:-help}"
shift || true
case "$CMD" in
  init)       exec "$INSTALL_DIR/scripts/bash/init.sh" "$@" ;;
  check)      exec "$INSTALL_DIR/scripts/bash/check-phase.sh" "$@" ;;
  help|--help|-h)
    echo "Usage: harness <command> [options]"
    echo "Commands: init, check"
    echo "Run 'harness init --help' for details."
    ;;
  *) echo "Unknown command: $CMD" >&2; exit 1 ;;
esac
WRAPPER
sudo chmod +x "$BIN_DIR/harness"

info "✓ ideate-kit installed. Run 'harness init --help' to get started."
