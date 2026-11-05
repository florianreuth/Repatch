#!/usr/bin/env bash
# Updates upstream, applies all patches and runs BUILD_COMMAND. Extra arguments are passed to the build command.
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/lib.sh"

bash "$SCRIPT_DIR/updateUpstream.sh"

if [ -z "$BUILD_COMMAND" ]; then
    log "No BUILD_COMMAND configured, skipping build."
    exit 0
fi

cd "$WORK_DIR"
log "Running: $BUILD_COMMAND $*"
bash -c "$BUILD_COMMAND \"\$@\"" build "$@"
log "Build complete${BUILD_ARTIFACTS:+, artifacts: $WORK_DIR/$BUILD_ARTIFACTS}"
