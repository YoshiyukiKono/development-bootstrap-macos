#!/usr/bin/env bash
set -euo pipefail

# macOS supplies compilers and several foundational developer commands through
# Xcode Command Line Tools. This command opens Apple's installer UI.
if xcode-select -p >/dev/null 2>&1; then
  printf 'Already installed: %s\n' "$(xcode-select -p)"
  exit 0
fi

xcode-select --install
printf 'Complete the macOS installer, then verify with:\n  xcode-select -p\n'
