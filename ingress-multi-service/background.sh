#!/usr/bin/env bash
set -euo pipefail

log() { echo "[setup] $*"; }

log "Checking cluster connectivity…"
kubectl version --short || true
kubectl get nodes -o wide

# --- App: frontend (nginx) ---
log "Creating frontend deployment and service…"
kubectl create deployment frontend-deploy --image=nginx --replicas=1 >/dev/null 2>&1 || true
kubectl expose deployment frontend-deploy \
  --name=frontend-service --port=80 --target-port=80 >/dev/null 2>&1 || true

# --- App: backend (http-echo) ---
log "Creating backend deployment and service…"
kubectl create deployment backend-deploy \
  --image=hashicorp/http-echo --replicas=1 \
  -- -text="Hello from Backend" >/dev/null 2>&1 || true
# http-echo listens on 5678; expose it as 8080
kubectl expose deployment backend-deploy \
  --name=backend-service --port=8080 --target-port=5678 >/dev/null 2>&1 || true

log "Waiting for app rollouts…"
kubectl rollout status deployment/frontend-deploy
kubectl rollout status deployment/backend-deploy

# --- Ingress controller (NGINX) ---
log "Installing NGINX Ingress Controller…"
# Cloud-agnostic manifest from upstream
if ! kubectl get ns ingress-nginx >/dev/null 2>&1; then
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
fi

log "Waiting for ingress controller to be Ready…"
kubectl -n ingress-nginx rollout status deployment/ingress-nginx-controller

# --- Ingress manifest dropped to the VM for Step 2 ---
log "Writing /root/multi-service-ingress.yaml…"
cat >/root/multi-service-ingress.yaml <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: multi-service-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
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

log "Done. Services and controller are ready."
