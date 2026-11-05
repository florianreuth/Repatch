#!/usr/bin/env bash
# Clones or updates the upstream repository and checks out the latest commit of UPSTREAM_BRANCH.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if [ -d "$WORK_DIR/.git" ]; then
    log "Updating existing clone..."
    git -C "$WORK_DIR" fetch origin
else
    log "Cloning $UPSTREAM_REPO..."
    mkdir -p "$(dirname "$WORK_DIR")"
    git clone "$UPSTREAM_REPO" "$WORK_DIR"
fi

cd "$WORK_DIR"
UPSTREAM_REF="$(git rev-parse "origin/$UPSTREAM_BRANCH")"
log "Checking out $UPSTREAM_BRANCH at $UPSTREAM_REF"
git -c advice.detachedHead=false checkout --force "$UPSTREAM_REF"
git clean -fdx

echo "$UPSTREAM_REF" > "$UPSTREAM_REF_FILE"
log "Upstream commit: $(git log --oneline -1)"
