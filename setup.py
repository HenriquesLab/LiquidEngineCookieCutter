from setuptools import setup, find_packages, Extension
from Cython.Build import cythonize

setup(
    name='MyPackage',
    packages=find_packages(),
    build_ext={"inplace": 1},
    ext_modules=cythonize("src/MyPackage/MyLiquidEngine.pyx", annotate=True, language_level="3"),
    version="0.1.0"
)
