#!/usr/bin/env bash
# Fetches the latest upstream commit and applies all patches onto it.
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/lib.sh"

bash "$SCRIPT_DIR/setup.sh"
bash "$SCRIPT_DIR/applyPatches.sh"
log "All patches apply cleanly to upstream $(upstream_ref)"
