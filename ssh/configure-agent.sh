#!/usr/bin/env bash
set -euo pipefail

# Configure macOS OpenSSH to load this key into ssh-agent and retain its
# passphrase in Keychain. Append a focused github.com block; do not replace the
# user's SSH configuration.
key_path="${1:-$HOME/.ssh/id_ed25519}"
config="$HOME/.ssh/config"

if [[ ! -f "$key_path" ]]; then
  printf 'Private key not found: %s\n' "$key_path" >&2
  exit 1
fi
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
touch "$config"
chmod 600 "$config"

if grep -Eq '^Host[[:space:]]+github\.com([[:space:]]|$)' "$config"; then
  printf 'A github.com block already exists in %s; review it manually.\n' "$config"
else
  cat >> "$config" <<EOF2

Host github.com
  HostName github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $key_path
EOF2
  printf 'Added github.com configuration to %s\n' "$config"
fi

# Apple's OpenSSH accepts --apple-use-keychain on current macOS releases.
ssh-add --apple-use-keychain "$key_path"
ssh-add -l
