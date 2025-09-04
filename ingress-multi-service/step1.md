### Step 1 — Verify the services exist

List the two services:

```bash
kubectl get svc frontend-service backend-service
```

If they’re not ready yet, wait for the deployments to be available:

```bash
kubectl get deploy frontend-deploy backend-deploy
kubectl rollout status deploy/frontend-deploy
kubectl rollout status deploy/backend-deploy
```
