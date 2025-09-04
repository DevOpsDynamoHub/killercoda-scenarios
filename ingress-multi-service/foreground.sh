#!/usr/bin/env bash
set -euo pipefail

echo "Environment snapshot:"
kubectl get nodes -o wide || true
echo
echo "Services (should be created by setup):"
kubectl get svc frontend-service backend-service || true
echo
echo "Next: verify in Step 1, then apply the ingress in Step 2."
