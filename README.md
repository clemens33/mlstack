# ML Stack

Machine learning stack including workflow engine, experiment tracking, model registry, model serving, and more.

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

To test flyte locally using the local development cluster perform the following steps - (adapted from [here](https://github.com/davidmirror-ops/flyte-the-hard-way/blob/main/docs/on-premises/002-install-local-flyte.md)).

Make sure the hosts entry for the fully qualified domain name (FQDN) is set to the minio service!

```shell
...
127.0.0.1       ml-minio.default.svc.cluster.local
...
```

```bash
pyflyte run samples/hello_flyte.py my_wf
```

