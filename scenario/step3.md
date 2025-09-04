## Step 3: Test the Ingress

Port-forward the ingress controller:

```bash
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8081:80
```{{execute}}

Open a new terminal tab and run:

```bash
curl -s -H "Host: app.example.com" http://localhost:8081/ | head -n 5
curl -s -H "Host: app.example.com" http://localhost:8081/api | head -n 5
```{{execute}}

✅ `/` returns the nginx default page.  
✅ `/api` returns “Hello from Backend”.
