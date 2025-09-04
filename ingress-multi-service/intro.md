# Ingress: Expose a Multi‑Service App

Goal: Use **one Ingress** to route `/` to `frontend-service:80` and `/api` to `backend-service:8080`.

Environment: A Kubernetes cluster with kubectl preconfigured. This scenario auto‑installs the NGINX Ingress Controller and preps frontend/backend services.
