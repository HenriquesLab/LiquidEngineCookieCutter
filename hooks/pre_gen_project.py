# Heavily based upon the napari-cookiecutter pre_gen_project hooks:
# https://github.com/napari/cookiecutter-napari-plugin/blob/main/hooks/pre_gen_project.py
# see also:
# https://cookiecutter.readthedocs.io/en/stable/advanced/hooks.html 

import re
import sys

if not re.match(r"^[a-z][_a-z0-9]+$", "{{cookiecutter.package_name}}"):
    link = "https://www.python.org/dev/peps/pep-0008/#package-and-module-names"
    print("Package name should be pep-8 compliant.")
    print(f"More info: {link}")
    sys.exit(1)

if re.search(r"_", "{{cookiecutter.package_name}}"):
    print("PyPI.org and pip discourage package names with underscores.")
    sys.exit(1)