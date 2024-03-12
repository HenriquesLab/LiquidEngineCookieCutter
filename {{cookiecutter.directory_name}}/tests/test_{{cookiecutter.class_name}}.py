import numpy as np
from {{cookiecutter.package_name}}.{{cookiecutter.file_name}} import {{cookiecutter.class_name}}

def test_benchmarking_{{cookiecutter.class_name}}():
    # create a random input array
    nparray = np.random.random((100, 100)).astype(np.float32)

    # initialize your class
    my_liquid_engine_class = {{cookiecutter.class_name}}(testing=True)

    # benchmarks the implementations
    for _ in range(3):
        my_liquid_engine_class.benchmark(nparray)

def test_output_{{cookiecutter.class_name}}():

    nparray = np.eye(100).astype(np.float32)
    my_liquid_engine_class = {{cookiecutter.class_name}}()
    out = my_liquid_engine_class.run(nparray)

    assert np.allclose(out,np.ones(100))