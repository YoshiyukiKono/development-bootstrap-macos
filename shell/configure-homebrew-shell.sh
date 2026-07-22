#!/usr/bin/env bash
set -euo pipefail

# Add exactly one Homebrew shellenv line to ~/.zprofile. Do not replace the
# file, and do not duplicate an existing setting.
profile="$HOME/.zprofile"

if [[ -x /opt/homebrew/bin/brew ]]; then
  brew_bin=/opt/homebrew/bin/brew
elif [[ -x /usr/local/bin/brew ]]; then
  brew_bin=/usr/local/bin/brew
else
  printf 'Homebrew was not found in a standard macOS location.\n' >&2
  exit 1
fi

line="eval \"\$($brew_bin shellenv)\""
touch "$profile"
if grep -Fq "$brew_bin shellenv" "$profile"; then
  printf 'Homebrew shell initialization already exists in %s\n' "$profile"
else
  printf '\n# Homebrew\n%s\n' "$line" >> "$profile"
  printf 'Added Homebrew shell initialization to %s\n' "$profile"
fi

# Apply it to this process for immediate verification.
eval "$($brew_bin shellenv)"
brew --version | head -n 1
