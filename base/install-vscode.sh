#!/usr/bin/env bash
set -euo pipefail

# Install the GUI application with Homebrew Cask. The `code` shell command may
# still need to be enabled from VS Code: Command Palette ->
# "Shell Command: Install 'code' command in PATH".
if [[ ! -d "/Applications/Visual Studio Code.app" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    printf 'Homebrew is required. Review install-homebrew.sh first.\n' >&2
    exit 1
  fi
  brew install --cask visual-studio-code
fi

if command -v code >/dev/null 2>&1; then
  code --version | head -n 1
else
  printf 'VS Code is installed. Enable the code command from its Command Palette.\n'
fi
