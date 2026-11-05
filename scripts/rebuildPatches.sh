#!/usr/bin/env bash
# Regenerates patches/ from all commits above the upstream ref in the upstream clone.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_work_dir
cd "$WORK_DIR"

UPSTREAM_REF="$(upstream_ref)"
rm -f "$PATCHES_DIR"/*.patch
mkdir -p "$PATCHES_DIR"

if [ "$(git rev-list --count "$UPSTREAM_REF"..HEAD)" -eq 0 ]; then
    log "No commits above upstream ref, patches/ cleared."
    exit 0
fi

# --zero-commit and --no-signature keep patches stable, so unchanged commits produce no diff.
git format-patch \
    --zero-commit \
    --no-signature \
    --no-numbered \
    --subject-prefix="" \
    --output-directory "$PATCHES_DIR" \
    "$UPSTREAM_REF"..HEAD

log "Done. Commit the updated patches/ directory."
