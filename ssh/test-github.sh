#!/usr/bin/env bash
set -uo pipefail

# GitHub's SSH test commonly exits with status 1 even after successful
# authentication because it does not provide shell access. Judge the message.
output="$(ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1)"
printf '%s\n' "$output"
if grep -q 'successfully authenticated' <<<"$output"; then
  exit 0
fi
exit 1
