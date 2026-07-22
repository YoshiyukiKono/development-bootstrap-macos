#!/usr/bin/env bash
set -euo pipefail

# Use uv's official standalone installer rather than tying uv to Homebrew.
if command -v uv >/dev/null 2>&1; then
  uv --version
  exit 0
fi
curl -LsSf https://astral.sh/uv/install.sh | sh

# The installer normally uses ~/.local/bin. Make it available in this process.
export PATH="$HOME/.local/bin:$PATH"
uv --version
printf 'Open a new shell if uv is not immediately visible elsewhere.\n'
