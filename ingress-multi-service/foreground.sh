#!/usr/bin/env bash
set -euo pipefail
echo "Cluster nodes:"
kubectl get nodes -o wide || true
echo
echo "Services prepared:"
kubectl get svc frontend-service backend-service || true
echo
echo "When ready, proceed to Step 1."
