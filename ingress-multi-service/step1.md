### Step 1 : Verify the services exist

List the two services:
```bash
kubectl get svc frontend-service backend-service
```{{execute}}

If they’re not ready yet, wait for the deployments:
```bash
kubectl get deploy frontend-deploy backend-deploy
kubectl rollout status deploy/frontend-deploy
kubectl rollout status deploy/backend-deploy
```{{execute}}
