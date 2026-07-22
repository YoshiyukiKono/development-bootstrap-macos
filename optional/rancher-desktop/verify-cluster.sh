#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.rd/bin:$PATH"

printf 'Rancher Desktop settings:\n'
rdctl list-settings
printf '\nKubernetes context:\n'
kubectl config current-context
printf '\nCluster information:\n'
kubectl cluster-info
printf '\nNodes:\n'
kubectl get nodes -o wide
printf '\nHelm:\n'
helm version --short
