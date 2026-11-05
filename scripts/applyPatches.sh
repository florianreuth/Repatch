#!/usr/bin/env bash
# Resets the upstream clone to the recorded upstream commit and applies all patches onto PATCHED_BRANCH.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_work_dir
cd "$WORK_DIR"

# git am needs a committer identity, which CI runners usually lack.
if ! git config user.name > /dev/null; then
    git config user.name "Repatch"
    git config user.email "repatch@localhost"
fi

UPSTREAM_REF="$(upstream_ref)"
log "Resetting to upstream ref $UPSTREAM_REF"
git checkout --force -B "$PATCHED_BRANCH" "$UPSTREAM_REF"
git clean -fdx

shopt -s nullglob
PATCHES=("$PATCHES_DIR"/*.patch)
if [ ${#PATCHES[@]} -eq 0 ]; then
    log "No patches to apply."
    exit 0
fi

log "Applying ${#PATCHES[@]} patch(es)..."
# Patch commits are throwaway, so signing them would only prompt for a passphrase on every apply.
if ! git am --3way --ignore-whitespace --no-gpg-sign "${PATCHES[@]}"; then
    echo ""
    echo "Patch application failed. Resolve the conflicts in $WORK_DIR, then run"
    echo "'git am --continue' (or 'git am --abort') and scripts/rebuildPatches.sh."
    exit 1
fi

log "All patches applied on branch $PATCHED_BRANCH: $(git log --oneline -1)"
