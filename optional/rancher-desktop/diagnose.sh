#!/usr/bin/env bash
set -u
failed=0
script_dir="$(cd "$(dirname "$0")" && pwd)"

printf 'Optional: Rancher Desktop and Kubernetes\n----------------------------------------\n'

if [[ -d "/Applications/Rancher Desktop.app" ]]; then
  printf '  OK       Rancher Desktop application\n'
else
  printf '  OPTIONAL Rancher Desktop is not installed\n'
  printf '           Review: %s/install-rancher-desktop.sh\n' "$script_dir"
  # Optional absence does not fail the whole bootstrap.
  exit 0
fi

if command -v rdctl >/dev/null 2>&1; then
  if rdctl list-settings >/dev/null 2>&1; then
    printf '  OK       Rancher Desktop is responding to rdctl\n'
  else
    printf '  MISSING  Rancher Desktop is installed but not running or initialized\n'
    printf '           Open the application, complete first-run setup, then review verify-cluster.sh\n'
    failed=1
  fi
else
  printf '  MISSING  rdctl is not on PATH\n'
  printf '           Review: %s/configure-path.sh\n' "$script_dir"
  failed=1
fi

for command_name in kubectl helm; do
  if command -v "$command_name" >/dev/null 2>&1; then
    printf '  OK       %s\n' "$command_name"
  else
    printf '  MISSING  %s\n' "$command_name"
    printf '           Review: %s/configure-path.sh or install-kubernetes-tools.sh\n' "$script_dir"
    failed=1
  fi
done

if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  printf '  OK       Kubernetes cluster is reachable; context: %s\n' "$(kubectl config current-context 2>/dev/null || echo unknown)"
else
  printf '  MISSING  Reachable Kubernetes cluster\n'
  printf '           Review: %s/verify-cluster.sh\n' "$script_dir"
  failed=1
fi

exit "$failed"
