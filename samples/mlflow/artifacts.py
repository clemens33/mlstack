"""Artifact logging example."""

import argparse

import mlflow


def main(tracking_uri):
    # Set the tracking URI
    mlflow.set_tracking_uri(tracking_uri)

    print(f"Tracking at: {mlflow.get_tracking_uri()}")

    mlflow.set_experiment("artifact_sample1")

    with mlflow.start_run():
        mlflow.log_artifact(__file__)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="MLflow tracking example")
    parser.add_argument(
        "--tracking_uri",
        type=str,
        default="http://localhost:5000",
        help="The tracking URI for MLflow",
    )
    args = parser.parse_args()

    main(args.tracking_uri)
