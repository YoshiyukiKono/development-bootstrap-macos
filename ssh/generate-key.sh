#!/usr/bin/env bash
set -euo pipefail

# Keep one revocable SSH key per physical machine or VM. Never overwrite an
# existing private key automatically.
email="${1:-}"
key_path="${2:-$HOME/.ssh/id_ed25519}"

if [[ -z "$email" ]]; then
  printf 'Usage: %s EMAIL [KEY_PATH]\n' "$0" >&2
  exit 2
fi
if [[ -e "$key_path" || -e "$key_path.pub" ]]; then
  printf 'Refusing to overwrite existing key material: %s\n' "$key_path" >&2
  exit 1
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
ssh-keygen -t ed25519 -C "$email" -f "$key_path"
printf 'Created: %s and %s.pub\n' "$key_path" "$key_path"
