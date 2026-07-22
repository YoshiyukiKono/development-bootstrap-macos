#!/usr/bin/env bash
set -euo pipefail

# Install Homebrew Python. Project Python versions may instead be managed by uv.
if command -v python3 >/dev/null 2>&1; then
  python3 --version | head -n 1
  exit 0
fi
if ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew is required. Review install-homebrew.sh first.\n' >&2
  exit 1
fi
brew install python
python3 --version | head -n 1
