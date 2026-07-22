#!/usr/bin/env bash
set -euo pipefail

# Browser-based GitHub CLI authentication. Explicitly select SSH as the Git
# protocol; the token is stored by gh in the system credential store when available.
if ! command -v gh >/dev/null 2>&1; then
  printf 'GitHub CLI is required. Review ../base/install-github-cli.sh.\n' >&2
  exit 1
fi

gh auth login --hostname github.com --git-protocol ssh --web
gh auth status --hostname github.com
