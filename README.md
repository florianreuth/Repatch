# Repatch

A minimal template for maintaining a fork as a set of patch files on top of an upstream repository. Instead of a
diverging fork, your changes are stored as `git format-patch` files in `patches/` and are reapplied onto the latest upstream.

## Setup

1. Create a repository from this template.
2. Set `UPSTREAM_REPO` (and optionally the branch and build command) in [`repatch.conf`](repatch.conf).
3. Run `bash scripts/build.sh`.

The upstream clone is placed in `work/<name>/` and is not committed.

## Scripts

| Script                      | Purpose                                                          |
|-----------------------------|------------------------------------------------------------------|
| `scripts/setup.sh`          | Clone or update upstream and check out its latest commit         |
| `scripts/applyPatches.sh`   | Reset the clone to that commit and apply all patches             |
| `scripts/rebuildPatches.sh` | Regenerate `patches/` from the commits in the clone              |
| `scripts/updateUpstream.sh` | `setup.sh` + `applyPatches.sh`, checks that patches still apply  |
| `scripts/build.sh`          | `updateUpstream.sh` + `BUILD_COMMAND`, extra arguments passed on |

## Workflow

1. Run `bash scripts/updateUpstream.sh`.
2. Change and commit code in `work/<name>/` (one commit per patch, amend or rebase to edit existing ones).
3. Run `bash scripts/rebuildPatches.sh` and commit `patches/`.

If a patch fails to apply, resolve the conflict in `work/<name>/`, run `git am --continue`, then rebuild the patches.

The included GitHub workflow builds weekly and on every push, and uploads `BUILD_ARTIFACTS`.
