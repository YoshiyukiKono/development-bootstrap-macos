#!/usr/bin/env bash
set -euo pipefail

# Upload only the public key. The private key must never leave this machine.
key_path="${1:-$HOME/.ssh/id_ed25519}"
title="${2:-$(scutil --get ComputerName 2>/dev/null || hostname)}"

if [[ ! -f "$key_path.pub" ]]; then
  printf 'Public key not found: %s.pub\n' "$key_path" >&2
  exit 1
fi
if ! gh auth status --hostname github.com >/dev/null 2>&1; then
  printf 'Authenticate first with authenticate-github.sh.\n' >&2
  exit 1
fi

gh ssh-key add "$key_path.pub" --title "$title" --type authentication
gh ssh-key list
