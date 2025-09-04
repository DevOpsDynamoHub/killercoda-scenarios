### Step 3 — Test the routing

Port-forward the Ingress controller and test with Host header:

```bash
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8081:80
```{{execute}}

Open a **second tab** (Tab+ in the UI) and run:
```bash
curl -s -H "Host: app.example.com" http://localhost:8081/ | head -n 3
curl -s -H "Host: app.example.com" http://localhost:8081/api | head -n 3
```{{execute}}
