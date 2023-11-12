"""Sample mlflow example without plugin."""


from flytekit import task, workflow, FlyteContextManager
from flytekit.bin.entrypoint import get_one_of
import random

import mlflow

# TODO flyte imagespec

@task
def run_experiment(experiment_name: str | None = None) -> str:
    """Dummy experiment."""

    params = FlyteContextManager.current_context().user_space_params
    ctx = FlyteContextManager.current_context()

    experiment = experiment_name or "local workflow"
    run_name = None

    if not ctx.execution_state.is_local_execution():
        experiment = f"{get_one_of('FLYTE_INTERNAL_EXECUTION_WORKFLOW', '_F_WF')}" or experiment_name
        run_name = f"{params.execution_id.name}.{params.task_id.name.split('.')[-1]}"
    else:
        # requires local port forwarding

        mlflow.set_tracking_uri("http://localhost:5000")

    mlflow.set_experiment(experiment)
    with mlflow.start_run(run_name=run_name):
        n = random.random()
        mlflow.log_param("n", n)

        # metrics
        for i in range(100):
            value = n/(i+1)
            
            mlflow.log_metric("metric1", value=value, step=i)

    return experiment

@workflow
def experiment() -> str:
    return run_experiment()    

if __name__ == "__main__":
    print(f"Running experiment: {ml_pipeline()}")