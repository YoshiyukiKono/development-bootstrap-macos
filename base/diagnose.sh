#!/usr/bin/env bash
set -u

section_failed=0
script_dir="$(cd "$(dirname "$0")" && pwd)"

ok() { printf '  OK       %s\n' "$1"; }
missing() { printf '  MISSING  %s\n' "$1"; section_failed=1; }
review() { printf '           Review: %s\n' "$1"; }

printf 'Base tools\n'
printf '----------\n'

if [[ "$(uname -s)" == "Darwin" ]]; then
  ok "macOS $(sw_vers -productVersion 2>/dev/null || echo unknown) ($(uname -m))"
else
  missing "This repository is intended for macOS; detected $(uname -s)."
fi

if xcode-select -p >/dev/null 2>&1; then
  ok "Xcode Command Line Tools: $(xcode-select -p)"
else
  missing "Xcode Command Line Tools"
  review "$script_dir/install-command-line-tools.sh"
fi

if command -v brew >/dev/null 2>&1; then
  ok "Homebrew: $(brew --version | head -n 1)"
else
  missing "Homebrew"
  review "$script_dir/install-homebrew.sh"
fi

check_command() {
  local command_name="$1"
  local label="$2"
  local install_script="$3"
  local version_command="$4"
  if command -v "$command_name" >/dev/null 2>&1; then
    local version
    version="$(eval "$version_command" 2>/dev/null | head -n 1)"
    ok "$label${version:+: $version}"
  else
    missing "$label"
    review "$script_dir/$install_script"
  fi
}

check_command git "Git" install-git.sh 'git --version'
check_command gh "GitHub CLI" install-github-cli.sh 'gh --version'
check_command python3 "Python 3" install-python.sh 'python3 --version'
check_command uv "uv" install-uv.sh 'uv --version'
check_command nvim "Neovim" install-neovim.sh 'nvim --version'

if command -v code >/dev/null 2>&1; then
  ok "Visual Studio Code CLI: $(code --version | head -n 1)"
elif [[ -d "/Applications/Visual Studio Code.app" ]]; then
  missing "Visual Studio Code is installed, but the 'code' command is not on PATH"
  review "$script_dir/install-vscode.sh"
else
  missing "Visual Studio Code"
  review "$script_dir/install-vscode.sh"
fi

exit "$section_failed"
