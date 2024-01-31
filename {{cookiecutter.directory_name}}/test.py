import numpy as np
from {{cookiecutter.package_name}}.{{cookiecutter.file_name}} import {{cookiecutter.class_name}}

# create a random input array
nparray = np.random.random((100, 100)).astype(np.float32)

# initialize your class
my_liquid_engine_class = {{cookiecutter.class_name}}(testing=True)

# benchmarks the implementations
my_liquid_engine_class.benchmark(nparray)

