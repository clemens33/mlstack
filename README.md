# mlstack

(work in progress)

ML Infrastructure stack and playground for local (for now) machine learning development. Including workflow engine, experiment tracking, model serving (upcoming), and more.

Includes the following components:

* [flyte](https://flyte.org/)
* [mlflow](https://mlflow.org/)

## Quick Start

Install [poetry](https://python-poetry.org/docs/#installation) and [flytectl](https://docs.flyte.org/projects/cookbook/en/latest/index.html)

```bash
poetry install
```

## Kubernetes

For local development cluster and how to start refer to [kubernetes/README.md](kubernetes/README.md).

## Flyte

To test flyte locally using the [local development cluster](kubernetes/README.md) perform the following steps - (inspired [by](https://github.com/davidmirror-ops/flyte-the-hard-way/blob/main/docs/on-premises/002-install-local-flyte.md)).

Make sure the hosts entry for the fully qualified domain name (FQDN) is set to the storage service (e.g. minio). Pyflyte gets the minio endpoint from the flyteadmin service. In the cluster flyte is configured to use a particular storage service which is forwarded to the client(pyflyte). If the FQDN is not set to the storage service the client will not be able to connect to the storage service.

```bash
127.0.0.1       ml-minio.default.svc.cluster.local
```

Make sure your flyte config is defined - default in `~/.flyte/config` - see [flyte docs](https://docs.flyte.org/projects/flytekit/en/latest/configuration.html) for more details.

```bash
mkdir -p ~/.flyte && \
cat << EOF > ~/.flyte/config
admin:
  # grpc endpoint
  endpoint: localhost:8089
  authType: Pkce
  insecure: true
logger:
  show-source: true
  level: 6
EOF
```

Make sure that the flyte/flyteadmin service is running and corresponding ports are forwarded (see [kubernetes/README.md](kubernetes/README.md)).

Executes a flyte workflow remotely.

```bash
pyflyte run --remote samples/hello_flyte.py my_wf
```
