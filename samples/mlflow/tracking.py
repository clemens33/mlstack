"""Sample code for tracking."""

import argparse
import random

import mlflow


def run_experiment():
    # parameters
    n = random.random()
    mlflow.log_param("n", n)

    # metrics
    for i in range(100):
        value = n / (i + 1)

        mlflow.log_metric("metric1", value=value, step=i)


def main(tracking_uri):
    mlflow.set_tracking_uri(tracking_uri)

    print(f"{mlflow.get_tracking_uri()}")

    _ = mlflow.set_experiment("tracking_sample1")

    with mlflow.start_run():
        run_experiment()


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
