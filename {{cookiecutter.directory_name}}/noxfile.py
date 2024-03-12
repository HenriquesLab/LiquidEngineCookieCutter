import os
import shutil
import sys
from pathlib import Path

import nox

DIR = Path(__file__).parent.resolve()
PYTHON_ALL_VERSIONS = ["3.9", "3.10", "3.11"]
PYTHON_DEFAULT_VERSION = "3.10"

# Platform logic
if sys.platform == "darwin":
    PLATFORM = "macos"
elif sys.platform == "win32":
    PLATFORM = "win"
else:
    PLATFORM = "unix"


# Set nox options
nox.options.reuse_existing_virtualenvs = False

# Some platform specific actions
if PLATFORM == "macos":
    if os.environ.get("NPX_MACOS_INSTALL_DEPENDENCIES", False):
        os.system("brew install llvm libomp")

@nox.session(python=PYTHON_ALL_VERSIONS)
def test_source(session):
    """
    Run the test suite by directly calling pip install -e . and then pytest
    """
    extra_args = os.environ.get("NPX_PYTEST_ARGS", "")
    session.run("pip", "install", "-e", ".")
    if extra_args != "":
        extra_args = extra_args.split(" ")
        session.run("pytest", DIR.joinpath("tests"), *extra_args)
    else:
        session.run("pytest", DIR.joinpath("tests"))



