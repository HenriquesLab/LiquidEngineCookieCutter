# LiquidEngineCookiecutter

Liquid Engine template made using [cookiecutter](https://cookiecutter.readthedocs.io/en/stable/)!

It helps create a python package and implements a simple class that subclasses the [Nanopyx Liquid Engine](https://github.com/HenriquesLab/NanoPyx)

## How to use

### Install cookiecutter

```bash 
pip install cookiecutter
```

### Generate package folder structure

First, navigate to a folder where you want your package to live. 

```bash
cookiecutter https://github.com/HenriquesLab/LiquidEngineCookieCutter
```

Cookiecutter will ask you for information regarding the package you want to create. 

After this step is complete a new folder will appear in your working directory. 

### Install the new package

First navigate to the newly created folder:

```bash
cd MyLiquidEngineFolder
pip install -e .
```
    
This installation should also install the newest version of nanopyx and required dependencies. To test if everything went according to plan you can try to run the provided test script

```bash
cd MyLiquidEngineFolder
python test.py
```

You now have a minimal working example of a Liquid Engine class. 

NOTE: After any modification to the Liquid Engine class (or any other .pyx file) you will need to recompile

```bash
python setup.py build_ext --inplace
```