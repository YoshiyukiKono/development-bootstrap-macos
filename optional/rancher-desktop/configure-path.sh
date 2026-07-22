#!/usr/bin/env bash
set -euo pipefail

# Rancher Desktop supplies rdctl, nerdctl, docker, kubectl, and helm under
# ~/.rd/bin. Add that directory once to zsh startup files.
rd_bin="$HOME/.rd/bin"
profile="$HOME/.zprofile"
line='export PATH="$HOME/.rd/bin:$PATH"'

if [[ ! -d "$rd_bin" ]]; then
  printf '%s does not exist. Start Rancher Desktop and finish first-run setup.\n' "$rd_bin" >&2
  exit 1
fi

touch "$profile"
if grep -Fq '.rd/bin' "$profile"; then
  printf 'Rancher Desktop PATH entry already exists in %s\n' "$profile"
else
  printf '\n# Rancher Desktop CLI tools\n%s\n' "$line" >> "$profile"
  printf 'Added Rancher Desktop CLI tools to %s\n' "$profile"
fi
export PATH="$rd_bin:$PATH"
command -v rdctl
