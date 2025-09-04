#!/usr/bin/env bash
set -e

# Create frontend
kubectl create deployment frontend-deploy --image=nginx --replicas=1 --dry-run=client -o yaml | kubectl apply -f -
kubectl expose deployment frontend-deploy \
  --name=frontend-service \
  --port=80 \
  --target-port=80 \
  --dry-run=client -o yaml | kubectl apply -f -

# Create backend
kubectl create deployment backend-deploy \
  --image=hashicorp/http-echo \
  --replicas=1 \
  --dry-run=client -o yaml \
  -- --text="Hello from Backend" | kubectl apply -f -
kubectl expose deployment backend-deploy \
  --name=backend-service \
  --port=8080 \
  --target-port=5678 \
  --dry-run=client -o yaml | kubectl apply -f -

# Install ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

# Wait for ingress controller
kubectl -n ingress-nginx rollout status deployment/ingress-nginx-controller
