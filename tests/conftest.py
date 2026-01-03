"""
Pytest configuration for ghflow tests.
"""

import pytest
import subprocess
from pathlib import Path


@pytest.fixture
def repo_root():
    """Get repository root directory"""
    return Path(__file__).parent.parent


@pytest.fixture
def skills_dir(repo_root):
    """Get skills directory"""
    return repo_root / ".claude" / "skills"


@pytest.fixture
def hello_world_fixture():
    """Get hello-world test fixture directory"""
    return Path(__file__).parent / "fixtures" / "hello-world"


def run_command(cmd, cwd=None, check=True):
    """Helper to run shell commands"""
    result = subprocess.run(
        cmd,
        shell=True,
        cwd=cwd,
        capture_output=True,
        text=True
    )

    if check and result.returncode != 0:
        raise Exception(
            f"Command failed: {cmd}\n"
            f"STDOUT: {result.stdout}\n"
            f"STDERR: {result.stderr}"
        )

    return result


@pytest.fixture
def run_cmd():
    """Fixture that provides run_command helper"""
    return run_command
