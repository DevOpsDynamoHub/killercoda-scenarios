### Step 3 — Test the routing

Port‑forward the Ingress Controller service locally and use the `Host` header to simulate DNS:

```bash
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8081:80
```

In a **separate terminal tab** (or background the previous command), test both paths:

```bash
curl -s -H "Host: app.example.com" http://localhost:8081/ | head -n 3
curl -s -H "Host: app.example.com" http://localhost:8081/api | head -n 3
```

You should see the frontend content for `/` and backend content for `/api`.
