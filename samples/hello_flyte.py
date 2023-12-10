from flytekit import task, workflow


@task
def say_hello(input: str) -> str:
    return input


@workflow
def my_wf() -> str:
    res = say_hello(input="abc")
    return res


if __name__ == "__main__":
    print(f"Running my_wf() {my_wf()}")
