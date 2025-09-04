#!/usr/bin/env bash
set -e

kubectl create deployment frontend-deploy --image=nginx --replicas=1 || true
kubectl expose deployment frontend-deploy --name=frontend-service --port=80 --target-port=80 || true

kubectl create deployment backend-deploy --image=hashicorp/http-echo --replicas=1 -- -text="Hello from Backend" || true
kubectl expose deployment backend-deploy --name=backend-service --port=8080 --target-port=5678 || true

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

kubectl -n ingress-nginx rollout status deployment/ingress-nginx-controller
