#!/usr/bin/env bash
set -u
failed=0
script_dir="$(cd "$(dirname "$0")" && pwd)"

printf 'SSH and GitHub authentication\n-----------------------------\n'

key=""
for candidate in "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ecdsa" "$HOME/.ssh/id_rsa"; do
  if [[ -f "$candidate" && -f "$candidate.pub" ]]; then key="$candidate"; break; fi
done

if [[ -n "$key" ]]; then
  printf '  OK       SSH key pair: %s\n' "$key"
else
  printf '  MISSING  SSH key pair\n'
  printf '           Review: %s/generate-key.sh\n' "$script_dir"
  failed=1
fi

if [[ -f "$HOME/.ssh/config" ]] && grep -Eq '^Host[[:space:]]+github\.com([[:space:]]|$)' "$HOME/.ssh/config"; then
  printf '  OK       ~/.ssh/config has a github.com host block\n'
else
  printf '  MISSING  github.com SSH configuration\n'
  printf '           Review: %s/configure-agent.sh\n' "$script_dir"
  failed=1
fi

if command -v gh >/dev/null 2>&1 && gh auth status --hostname github.com >/dev/null 2>&1; then
  printf '  OK       GitHub CLI authentication\n'
else
  printf '  MISSING  GitHub CLI authentication\n'
  printf '           Review: %s/authenticate-github.sh\n' "$script_dir"
  failed=1
fi

if [[ -n "$key" ]] && command -v gh >/dev/null 2>&1 && gh auth status --hostname github.com >/dev/null 2>&1; then
  pub_fingerprint="$(ssh-keygen -lf "$key.pub" 2>/dev/null | awk '{print $2}')"
  if gh ssh-key list 2>/dev/null | grep -Fq "$pub_fingerprint"; then
    printf '  OK       Local public key appears in GitHub account\n'
  else
    printf '  MISSING  Local public key was not matched in GitHub account\n'
    printf '           Review: %s/register-github-key.sh\n' "$script_dir"
    failed=1
  fi
fi

exit "$failed"
