### Step 2 — Create the Ingress

The manifest is already on the VM at `/root/multi-service-ingress.yaml`.

Apply it:
```bash
kubectl apply -f /root/multi-service-ingress.yaml
```{{execute}}

Inspect it:
```bash
kubectl describe ingress multi-service-ingress
```{{execute}}
