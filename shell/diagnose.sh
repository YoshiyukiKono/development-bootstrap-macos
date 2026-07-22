#!/usr/bin/env bash
set -u
failed=0
script_dir="$(cd "$(dirname "$0")" && pwd)"

printf 'Shell\n-----\n'
if [[ "${SHELL:-}" == */zsh ]]; then
  printf '  OK       Default shell: %s\n' "$SHELL"
else
  printf '  MISSING  Expected zsh as the default shell; found: %s\n' "${SHELL:-unknown}"
  failed=1
fi

brew_path=""
[[ -x /opt/homebrew/bin/brew ]] && brew_path=/opt/homebrew/bin/brew
[[ -z "$brew_path" && -x /usr/local/bin/brew ]] && brew_path=/usr/local/bin/brew

if [[ -n "$brew_path" ]]; then
  if command -v brew >/dev/null 2>&1; then
    printf '  OK       Homebrew is on PATH\n'
  else
    printf '  MISSING  Homebrew exists but is not on PATH\n'
    printf '           Review: %s/configure-homebrew-shell.sh\n' "$script_dir"
    failed=1
  fi
fi

exit "$failed"
