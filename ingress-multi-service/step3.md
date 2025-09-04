## Step 3 — Test the routing

Port-forward the ingress controller:

```bash
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8081:80
```{{execute}}

Open a new terminal tab and test both paths:

```bash
# Frontend
curl -s -H "Host: app.example.com" http://localhost:8081/ | head -n 3

# Backend
curl -s -H "Host: app.example.com" http://localhost:8081/api | head -n 3
```{{execute}}

**Expected:**
- `/` shows the nginx default page (frontend).
- `/api` prints `Hello from Backend`.
