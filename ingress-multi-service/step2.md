### Step 2 — Create the Ingress

Create `multi-service-ingress.yaml` with the following:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: multi-service-ingress
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 8080
```

Apply it:

```bash
kubectl apply -f multi-service-ingress.yaml
```

Inspect it if needed:

```bash
kubectl describe ingress multi-service-ingress
```
