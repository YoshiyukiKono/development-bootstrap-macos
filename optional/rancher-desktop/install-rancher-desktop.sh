#!/usr/bin/env bash
set -euo pipefail

# Homebrew Cask provides a repeatable CLI installation. Rancher Desktop still
# requires GUI first-run configuration and permission approval on macOS.
if [[ -d "/Applications/Rancher Desktop.app" ]]; then
  printf 'Rancher Desktop is already installed.\n'
else
  if ! command -v brew >/dev/null 2>&1; then
    printf 'Homebrew is required.\n' >&2
    exit 1
  fi
  brew install --cask rancher
fi
open -a "Rancher Desktop"
printf 'Complete the first-run UI. Then run configure-path.sh and verify-cluster.sh.\n'
