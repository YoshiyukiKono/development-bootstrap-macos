#!/usr/bin/env bash
set -u

repo_dir="$(cd "$(dirname "$0")" && pwd)"
failed=0

run_check() {
  local script="$1"
  printf '\n'
  if ! "$script"; then
    failed=1
  fi
}

printf 'development-bootstrap-macos\n'
printf '============================\n'
printf 'Read-only diagnosis. No settings will be changed.\n'

run_check "$repo_dir/base/diagnose.sh"
run_check "$repo_dir/shell/diagnose.sh"
run_check "$repo_dir/ssh/diagnose.sh"
run_check "$repo_dir/optional/rancher-desktop/diagnose.sh"

printf '\n'
if [[ "$failed" -eq 0 ]]; then
  printf 'Overall: READY\n'
else
  printf 'Overall: ACTION REQUIRED\n'
  printf 'Review the scripts named above, run the relevant ones, then rerun ./diagnose.sh.\n'
fi

exit "$failed"
