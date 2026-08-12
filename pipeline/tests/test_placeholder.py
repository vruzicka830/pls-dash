"""Exercises the toolchain (pytest/ruff/mypy) against a real function.

Delete this once there's actual pipeline code with its own tests — it exists
only to prove the scaffolding works end to end.
"""

from pls_dash import hello


def test_hello() -> None:
    assert hello() == "Hello from pls-dash!"
