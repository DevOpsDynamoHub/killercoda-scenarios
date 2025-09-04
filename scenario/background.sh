#!/usr/bin/env bash
set -e

# Frontend deployment + service
kubectl create deployment frontend-deploy --image=nginx --replicas=1
kubectl expose deployment frontend-deploy \
  --name=frontend-service \
  --port=80 \
  --target-port=80

# Backend deployment + service
kubectl create deployment backend-deploy --image=hashicorp/http-echo --replicas=1 \
  -- --text="Hello from Backend"
kubectl expose deployment backend-deploy \
  --name=backend-service \
  --port=8080 \
  --target-port=5678

# Install ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
kubectl -n ingress-nginx rollout status deployment/ingress-nginx-controller
