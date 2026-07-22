#!/usr/bin/env bash
set -euo pipefail

# Install GitHub CLI. Authentication remains a separate, explicit step.
if command -v gh >/dev/null 2>&1; then
  gh --version | head -n 1
  exit 0
fi
if ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew is required. Review install-homebrew.sh first.\n' >&2
  exit 1
fi
brew install gh
gh --version | head -n 1
