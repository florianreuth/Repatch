#!/usr/bin/env bash
# Shared setup for all scripts: loads repatch.conf and defines paths and helpers.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../repatch.conf
source "$ROOT_DIR/repatch.conf"

: "${UPSTREAM_REPO:?UPSTREAM_REPO must be set in repatch.conf}"
UPSTREAM_BRANCH="${UPSTREAM_BRANCH:-main}"
NAME="${NAME:-$(basename "$UPSTREAM_REPO" .git)}"
PATCHED_BRANCH="${PATCHED_BRANCH:-patched}"
BUILD_COMMAND="${BUILD_COMMAND:-}"
BUILD_ARTIFACTS="${BUILD_ARTIFACTS:-}"

WORK_DIR="$ROOT_DIR/work/$NAME"
PATCHES_DIR="$ROOT_DIR/patches"
UPSTREAM_REF_FILE="$ROOT_DIR/work/.upstream-ref"

log() {
    echo "==> $*"
}

fail() {
    echo "ERROR: $*" >&2
    exit 1
}

require_work_dir() {
    [ -d "$WORK_DIR/.git" ] || fail "No upstream clone at $WORK_DIR, run scripts/setup.sh first."
    [ -f "$UPSTREAM_REF_FILE" ] || fail "No upstream ref at $UPSTREAM_REF_FILE, run scripts/setup.sh first."
}

upstream_ref() {
    tr -d '[:space:]' < "$UPSTREAM_REF_FILE"
}
