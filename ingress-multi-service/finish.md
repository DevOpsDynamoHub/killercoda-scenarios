## Done

You created and validated an Ingress that routes traffic to two services on different paths.

**Key checks** you now know:
- Paths need `pathType: Prefix`
- Ingress requires a controller (we used NGINX)
- Use `Host` header + port‑forwarding to test without DNS
