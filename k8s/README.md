# Kubernetes Cheat Sheet

To create kubernetes objects:

- `kubectl apply -f manifest.yaml` - Create objects by manifest
- `kubectl apply -f manifest.yaml --dry-run=client` - Check manifest
- `kubectl apply -f manifest.yaml --dry-run=server` - Check manifest in cluster

To manage pod:

- `kubectl run wxdsb --image=wxdsb:latest` - Run pod from an image
- `kubectl get pods` - To view pods
- `kubectl get events` - To view events in case of debug
- `kubectl logs -f wxdsb` - To view and follow the logs of pod
- `kubectl exec -ti wxdsb -- bash` - To get a shell to the running container
- `kubectl port-forward wxdsb 9090:8080` - Expose (locally) web app by port-forward to local port 9090
- `kubectl delete pod wxdsb` - To delete pod

## Other commands

- `kubectl config view` - Displays merged kubeconfig settings or a specified kubeconfig file
- `kubectl config get-contexts` - Displays contexts defined in kubeconfig
- `kubectl config use-context <context-name>` - Set current-context
- `kubectl cluster-info` - Display addresses of the master and services
- `kubectl get nodes` - Provides essential information about the nodes in your Kubernetes cluster 
- `kubectl get nodes -o wide` - Provides more information about the nodes in your Kubernetes cluster
- `kubectl get namespaces --show-labels` - To view namespaces
- `kubectl get all -l app.kubernetes.io/managed-by=Helm'` - To view all objects with label app.kubernetes.io/managed-by=Helm
- `kubectl get pods` - To view pods
- `kubectl --context=<context-name> get pods` - To view pods of `context-name` context
- `kubectl get pods -l app.kubernetes.io/name=wxdsb` - To view pods with label app.kubernetes.io/name=wxdsb
- `kubectl get pods -o yaml` - To view pods information in yaml format
- `kubectl get pods -o json` - To view pods information in json format
- `kubectl get pods --all-namespaces` - To view pods of all namespaces
- `kubectl get pv` - List PersistentVolumes
- `kubectl get pvc` - List PersistentVolumeClaims
- `kubectl get events` - To view events in case of debug
- `kubectl events --types=Warning` - To view Warning events
- `kubectl get deployments -l app=wxdsb` - To view deployments by label app=wxdsb
- `kubectl describe deployments/wxdsb` - To view details of deployment
- `kubectl logs -f deployments/wxdsb` - To view and follow the logs of web app
- `kubectl logs -f -l app=wxdsb` - To view and follow the logs of deployment by label app
- `kubectl exec -ti deployments/wxdsb -- bash` - To get a shell to the running first pod of deployment
- `kubectl exec deployments/wxdsb -- env` - To print environment variable from first pod of deployment
- `kubectl port-forward deployments/wxdsb 9090:8080` - Expose (locally) web app by port-forward to local port 9090
- `kubectl expose deployments/wxdsb --type="NodePort" --port=8080 --target-port=8080` - Expose (internally) web app by service.
- `kubectl get services -l app=wxdsb` - To view service and port assigned
- `kubectl run -i --tty busybox --image=busybox:latest -- sh` - Run pod as interactive shell
- `kubectl create job hello --image=busybox:latest -- echo "Hello World"` - Create a Job which prints "Hello World"
- `kubectl create cronjob hello --image=busybox:latest --schedule="*/1 * * * *" -- echo "Hello World"` - Create a CronJob that prints "Hello World" every minute
- `kubectl get jobs --watch` - Watch jobs
- `kubectl label pods wxdsb group=test` - # Add a Label
- `kubectl label pods wxdsb group=test --overwrite` - # Overwrite a Label
- `kubectl label pods wxdsb group-` - # Remove a label
- `kubectl describe pods` - To describe pds
- `kubectl describe deployment wxdsb` - To describe deployment
- `kubectl describe service wxdsb-service` - To describe service
- `kubectl describe ingress wxdsb-ingress` - To describe ingress
- `kubectl delete -f wxdsb.yaml` - Delete all kubernetes objects defined in yaml file
- `kubectl delete ingress wxdsb-ingress` - To delete ingress
- `kubectl delete service wxdsb-service` - To delete service
- `kubectl delete persistentvolumeclaim wxdsb-pvc` - To delete PersistentVolumeClaim
- `kubectl delete configmap wxdsb-env` - To delete configmap
- `kubectl delete secret  wxdsb-sec` - To delete secret
- `kubectl delete deployment wxdsb` - To delete deployment
- `kubectl delete namespace dew` - To delete the namespace `dew`
- `kubectl delete namespace dew --force` - To delete the namespace `dew` (forced)
- `kubectl scale --replicas=3 rs/wxdsb` - Scale a replicaset named `wxdsb` to 3
- `kubectl cp test.txt wxdsb:/data01` - Copy local file `test.txt` to remote directory `/data01` of pod named `wxdsb`
- `kubectl cp wxdsb:/data01/test.txt .` - Copy remote file `/data01/test.txt` of pod named `wxdsb` in local current (.) directory
- `kubectl create deployment wxdsb-dep --image=wxdsb:latest` - Simple way to create a deployment 
- `kubectl run wxdsb-dep --image=wxdsb:latest --port=8080` - Alternative way to create a deployment 

## Update Kubernetes deployment

- `kubectl set image deployment/wxdsb main=wxdsb:1.0.0` - Rolling update `main` container of `wxdsb` deployment, updating the image
- `kubectl rollout history deployment/wxdsb` - Check the history of deployments including the revision
- `kubectl rollout undo deployment/wxdsb` - Rollback to the previous deployment
- `kubectl rollout undo deployment/wxdsb --to-revision=2` - Rollback to a specific revision
- `kubectl rollout status -w deployment/wxdsb` - Watch rolling update status of `wxdsb` deployment until completion
- `kubectl rollout restart deployment/sira-drupal` - Rolling restart of the `wxdsb` deployment

## Install Ingress-Nginx to your Docker Desktop Kubernetes

First check current context:

- `kubectl config current-context` - To view current-context
- `kubectl config use-context docker-desktop` - To set current-context

Install ingress nginx controller:

- `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.3/deploy/static/provider/cloud/deploy.yaml`

See https://github.com/kubernetes/ingress-nginx for more information.

## Create Ingress https

Create private key and certificate:

`openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout tls.key -out tls.crt`

Create Secret tls:

`kubectl create secret tls wdemo-dew-org-tls-secret --cert=tls.crt --key=tls.key`

or

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: wdemo-dew-org-tls-secret
type: kubernetes.io/tls
data:
  tls.crt: <CERTIFICATO_BASE64>
  tls.key: <CHIAVE_BASE64>
```

Create Ingress:

`kubectl apply -f wdemo-dew-org-ingress.yaml`

wdemo-dew-org-ingress.yaml:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: wdemo-dew-org-ingress
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - wdemo.dew.org
      secretName: wdemo-dew-org-tls-secret
  rules:
    - host: wdemo.dew.org
      http:
        paths:
          - path: /
            pathType: ImplementationSpecific
            backend:
              service:
                name: wdemo-dew-org-service
                port:
                  number: 8080
```

## REST API Kubernetes

`kubectl proxy --port=8080` - Start API proxy on local port 8080

- Nodes:
	- http://localhost:8080/api/v1/nodes
- Workloads:
	- http://localhost:8080/api/v1/namespaces/default/pods
		- http://localhost:8080/api/v1/namespaces/default/pods?labelSelector=app=wxdsb
		- http://localhost:8080/api/v1/namespaces/default/pods/wxdsb
		- http://localhost:8080/api/v1/namespaces/default/pods/wxdsb/log
	- http://localhost:8080/apis/apps/v1/namespaces/default/deployments
	- http://localhost:8080/apis/apps/v1/namespaces/default/deployments?labelSelector=app=wxdsb
	- http://localhost:8080/apis/apps/v1/namespaces/default/replicasets
	- http://localhost:8080/apis/batch/v1/namespaces/default/jobs
	- http://localhost:8080/apis/batch/v1/namespaces/default/cronjobs
- Config:
	- http://localhost:8080/api/v1/namespaces/default/configmaps
	- http://localhost:8080/api/v1/namespaces/default/secrets
- Network:
	- http://localhost:8080/api/v1/namespaces/default/services
	- http://localhost:8080/api/v1/namespaces/default/endpoints
	- http://localhost:8080/apis/networking.k8s.io/v1/namespaces/default/ingresses
	- http://localhost:8080/apis/networking.k8s.io/v1/ingressclasses
- Storage:
	- http://localhost:8080/apis/storage.k8s.io/v1/storageclasses
	- http://localhost:8080/api/v1/namespaces/default/persistentvolumeclaims
	- http://localhost:8080/api/v1/persistentvolumes
- Events:
	- http://localhost:8080/api/v1/namespaces/default/events
- Access Control:
	- http://localhost:8080/api/v1/namespaces/default/serviceaccounts
- Namespaces:
	- http://localhost:8080/api/v1/namespaces
- Exposed port pod:
	. http://localhost:8080/api/v1/namespaces/default/pods/$POD_NAME:8080/proxy/

## Deploy application with Helm

In `helm` folder do the following:

- `helm install wxdsb ./wxdsb` - this install `wxdsb` application from project folder
- `helm list` - this show all releases
- `helm get all wxdsb` - this show all info of `wxdsb` application
- `helm uninstall wxdsb` - this uninstall `wxdsb` application

Other commands:

- `helm create wxdsb` - this will create `wxdsb` project folder
- `helm lint wxdsb` - this will check `wxdsb` project folder
- `helm template wxdsb ./wxdsb` - this render chart templates locally and display the output
- `helm show all ./wxdsb` - this will show all information of the chart
- `helm status wxdsb` - this will display the status of the named release
- `helm history sira-drupal` - this will prints historical revisions for a given release
- `helm package wxdsb` - this will create package from `wxdsb` project folder (`wxdsb-0.1.0.tgz`)
- `helm install wxdsb ./wxdsb-0.1.0.tgz` - this install `wxdsb` application from package
- `helm upgrade wxdsb ./wxdsb-0.1.0.tgz` - this upgrade `wxdsb` application from package
- `helm upgrade -i wxdsb ./wxdsb-0.1.0.tgz` - this upgrade `wxdsb` application with `-i` (install if name doesn't exist)

Get ReplicaSet without Pods:

`kubectl get rs -o jsonpath='{.items[?(@.status.replicas==0)].metadata.name}'`

## Kubernetes Dashboard

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
  - host: kubernetes.dew.org
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

From Docker using Alpine:

`docker run -it --rm --name alpine alpine:latest sh`

or

`kubectl run alpine --rm -it --image=alpine:latest --restart=Never -- sh`

Install openssl

`# apk add --no-cache openssl`

## To enable access to Kubernetes (onboarding)

Let `gsilvestris` be the user and `prova` the project (groupname).

### Generate CSR

`openssl genrsa -out gsilvestris.key 4096`

`openssl req -new -key gsilvestris.key -nodes -out gsilvestris.csr -subj "/CN=gsilvestris/O=prova"`

### Create CSR in Kubernetes

```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
    name: gsilvestris-csr
spec:
    request: <BASE64_USER_CSR>
    signerName: kubernetes.io/kube-apiserver-client
    usages:
    - client auth
```

### Approve CSR

`kubectl certificate approve gsilvestris-csr`

### Get certificate

`kubectl get csr gsilvestris-csr -o jsonpath='{.status.certificate}'`

### Create config

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: <BASE64_CA_CERT>
    server: https://kubernetes.docker.internal:6443
  name: docker-desktop
contexts:
- context:
    cluster: docker-desktop
    user: docker-desktop
  name: docker-desktop
current-context: docker-desktop
kind: Config
preferences: {}
users:
- name: gsilvestris
  user:
    client-certificate-data: <BASE64_USER_CERT>
    client-key-data: <BASE64_USER_KEY>
```