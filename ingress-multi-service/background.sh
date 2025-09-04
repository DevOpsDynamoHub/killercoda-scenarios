#!/bin/bash
# Runs once at scenario start

# Create frontend deployment + service
kubectl create deployment frontend-deploy --image=nginx
kubectl expose deployment frontend-deploy --name=frontend-service --port=80 --target-port=80

# Create backend deployment + service
kubectl create deployment backend-deploy --image=hashicorp/http-echo -- \
  -text="Hello from Backend"
kubectl expose deployment backend-deploy --name=backend-service --port=8080 --target-port=5678

# Install ingress-nginx controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/kind/deploy.yaml

# Wait for ingress controller to be ready
kubectl wait --namespace ingress-nginx \
  --for=condition=Ready pods \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s
