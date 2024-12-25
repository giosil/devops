# Kubernetes Dashboard

Add kubernetes-dashboard repository:

`helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/`

Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart:

`helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard`

To create Ingress write `kubernetes-dashboard-ingress.yaml` file:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubernetes-dashboard-ingress
  namespace: kubernetes-dashboard
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  ingressClassName: nginx
  rules:
  - host: kubernetes.isedev.it
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: kubernetes-dashboard-kong-proxy
            port:
              number: 443
```

and apply:

`kubectl apply -f kubernetes-dashboard-ingress.yaml`

Alternatively, to access Dashboard by port-forward:

`kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443`

### Generate Bearer Token

To bind role `admin` to service account `default`

`kubectl create clusterrolebinding default-admin-binding --clusterrole=admin --serviceaccount=default:default`

To create token for service account `default` in namespace (-n) `default`

`kubectl -n default create token default --duration=200000h`

### Configure local nginx proxy instead of create an Ingress

To configure local nginx to proxy (on 6443) kubernetes dashboard exposed by port-forward (on 8443):

```
http {
    server {
        listen 6443 ssl;
        server_name 10.20.25.90;

        ssl_certificate c:/nginx-1.26.2/certs/nginx-selfsigned.crt;
        ssl_certificate_key c:/nginx-1.26.2/certs/nginx-selfsigned.key;

        location / {
            proxy_pass https://localhost:8443;
            proxy_ssl_verify off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

To generate self signed certificates:

`openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout nginx-selfsigned.key -out nginx-selfsigned.crt`
