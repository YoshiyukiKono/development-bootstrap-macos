#!/usr/bin/env bash
set -euo pipefail

# Install a current Git without changing global Git configuration.
if command -v git >/dev/null 2>&1; then
  git --version | head -n 1
  exit 0
fi
if ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew is required. Review install-homebrew.sh first.\n' >&2
  exit 1
fi
brew install git
git --version | head -n 1
