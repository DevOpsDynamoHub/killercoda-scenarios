## Step 1: Verify Services

The cluster already has two services deployed:
- frontend-service (port 80)
- backend-service (port 8080)

Run the following:

```bash
kubectl get svc frontend-service backend-service
```{{execute}}

✅ You should see both services listed.
