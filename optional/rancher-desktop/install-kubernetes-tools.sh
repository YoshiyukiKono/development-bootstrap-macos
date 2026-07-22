#!/usr/bin/env bash
set -euo pipefail

# Rancher Desktop already bundles kubectl and helm in ~/.rd/bin. This script
# installs independent Homebrew copies only when you intentionally want tools
# available without Rancher Desktop. k9s is always an optional convenience.
if ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew is required.\n' >&2
  exit 1
fi

for formula in kubectl helm k9s; do
  if brew list --formula "$formula" >/dev/null 2>&1; then
    printf 'Already installed: %s\n' "$formula"
  else
    brew install "$formula"
  fi
done
kubectl version --client
helm version --short
k9s version
