#!/usr/bin/env bash
set -euo pipefail

echo "[setup] Creating sample frontend/backend and installing ingress-nginx..."

# Create a namespace for our app (optional, staying in default for simplicity)
# kubectl create ns app && kubectl config set-context --current --namespace=app || true

# Frontend (nginx on :80) + Service :80
kubectl create deployment frontend-deploy --image=nginx --replicas=1 >/dev/null 2>&1 || true
kubectl expose deployment frontend-deploy --name=frontend-service --port=80 --target-port=80 >/dev/null 2>&1 || true

# Backend (nginx on :80) + Service exposed on :8080 (targetPort :80)
kubectl create deployment backend-deploy --image=nginx --replicas=1 >/dev/null 2>&1 || true
kubectl expose deployment backend-deploy --name=backend-service --port=8080 --target-port=80 >/dev/null 2>&1 || true

# Wait for pods ready
kubectl rollout status deployment/frontend-deploy
kubectl rollout status deployment/backend-deploy

# Install NGINX Ingress Controller (cloud generic manifest)
if ! kubectl get ns ingress-nginx >/dev/null 2>&1; then
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
fi

# Wait for controller to be ready
kubectl -n ingress-nginx rollout status deployment/ingress-nginx-controller

echo "[setup] Done."
# --- drop the ingress manifest on the VM ---
cat >/root/multi-service-ingress.yaml <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: multi-service-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 8080
YAML
echo "[setup] Wrote /root/multi-service-ingress.yaml"

