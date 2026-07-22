#!/usr/bin/env bash
set -euo pipefail

# Official Homebrew installer. It explains planned changes and asks before
# modifying the machine. Read the downloaded script if policy requires it.
if command -v brew >/dev/null 2>&1; then
  brew --version | head -n 1
  exit 0
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# New Apple Silicon installs normally use /opt/homebrew; Intel uses /usr/local.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

brew --version
printf 'Next: run ../shell/configure-homebrew-shell.sh so future shells find brew.\n'
