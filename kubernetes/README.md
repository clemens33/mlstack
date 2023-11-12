# Kubernetes

Sample deploying mlflow on local kubernetes cluster.

## Local Cluster

Starts [kind](https://kind.sigs.k8s.io/) local (run from kubernetes directory)

```bash
mkdir -p ./data && \
kind create cluster --config kind-config-mlstack.yaml && \
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

(Optional) Enable ingress - using [ingress nginx](https://kind.sigs.k8s.io/docs/user/ingress/#ingress-nginx) deploy ingress (Roles, RoleBinding, ServiceAccounts etc.) - you do not want to write this manually

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

Add relevant helm repos

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami && \
helm repo add clemens33 https://clemens33.github.io/mlflow && \
helm repo add flyteorg https://flyteorg.github.io/flyte
```

Deploy using kustomize and helm

```bash
kubectl kustomize --enable-helm | kubectl apply -f -
```

**Access**

* mlflow: <http://localhost:8888/mlflow/#/>
* minio: <http://localhost:8888/>

### Others

Templates only

```bash
kubectl kustomize --enable-helm > _ml-stack.yaml
```

Undeploy

```bash
kubectl kustomize --enable-helm | kubectl delete -f -
```

Port forwards (for minio console not working - port forward does not support web sockets - <https://github.com/minio/console/issues/2539>)

```bash
kubectl port-forward svc/ml-minio 9000:9000 9001:9001
```

Port forwards for postgres

```bash
kubectl port-forward svc/ml-postgres 5432:5432
```

Port forwards for mlflow

```bash
kubectl port-forward svc/ml-mlflow 5000:80
```

Port forwards for flyte

```bash
kubectl port-forward svc/ml-flyte-grpc 8089:8089
kubectl port-forward svc/ml-flyte-http 8088:8088
```

Delete kind cluster

```bash
kind delete cluster --name mlstack
```
