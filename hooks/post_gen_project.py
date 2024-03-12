# Heavily based upon the napari-cookiecutter post_gen_project hooks:
# https://github.com/napari/cookiecutter-napari-plugin/blob/main/hooks/post_gen_project.py
# see also:
# https://cookiecutter.readthedocs.io/en/stable/advanced/hooks.html 

import os
import shutil
import subprocess
from pathlib import Path

ALL_TEMP_FOLDERS = ["licenses"]

def remove_temp_folders(temp_folders):
    for folder in temp_folders:
        #print("Removing temporary folder: %s", folder)
        shutil.rmtree(folder, ignore_errors=True)


if __name__ == "__main__":
    remove_temp_folders(ALL_TEMP_FOLDERS)

    msg = """ 
    _  _               ___
    | \| |__ _ _ _  ___| _ \_  ___ __
    | .` / _` | ' \/ _ \  _/ || \ \ /
    |_|\_\__,_|_||_\___/_|  \_, /_\_\\
        [ (( X )) ]     *|<|__/==/==
    |-- Python Nanoscopy Library --|
    Your Liquid Engine template is now ready! 
    Now all you need is to install it in your environment.

    1. Navigate using `cd` into your new directory 

     cd {{ cookiecutter.directory_name }}
     
    2. Use pip to install your package
     
     pip install -e .

    3. Verify installation was successfull

     pytest

    For more information check out our official documentation:

    https://github.com/HenriquesLab/NanoPyx/wiki 

    And repositories:

    https://github.com/HenriquesLab/NanoPyx 
    https://github.com/HenriquesLab/LiquidEngineCookieCutter
     
    """
    
    print(msg)