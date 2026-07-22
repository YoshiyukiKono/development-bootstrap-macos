#!/usr/bin/env bash
set -euo pipefail

# Install Neovim without adding editor configuration.
if command -v nvim >/dev/null 2>&1; then
  nvim --version | head -n 1
  exit 0
fi
if ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew is required. Review install-homebrew.sh first.\n' >&2
  exit 1
fi
brew install neovim
nvim --version | head -n 1
