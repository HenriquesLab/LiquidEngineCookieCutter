# Cookicutter of a Python package implementing NanoPyx's Liquid Engine

This repository exemplifies how to take advantage of [NanoPyx]'s Liquid Engine in your own python packages.  
Here you can find a minimal working example for a simple cython implementation.  
If you want to implement parallelized functions in Cython or PyOpenCL, please refer to their official documentation ([Cython] and [PyOpenCL])  
Also, if you want to use only pure python implementations, accelerated through numba, transonic and/or dask, you can simply create a .py file implementing your class and skip all Cython build steps and configurations.  
  
If you found this work useful, please cite: [preprint](https://www.biorxiv.org/content/10.1101/2023.08.13.553080v1) and  [![DOI](https://zenodo.org/badge/505388398.svg)](https://zenodo.org/badge/latestdoi/505388398)  
  
[Cython]: https://cython.readthedocs.io/en/latest/
[PyOpenCL]: https://documen.tician.de/pyopencl/
[NanoPyx]: https://github.com/HenriquesLab/NanoPyx