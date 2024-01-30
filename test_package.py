import numpy as np
from MyPackage.MyLiquidEngine import MyLiquidEngineClass

# create a random input array
nparray = np.random.random((100, 100)).astype(np.float32)

# initialize your class
my_liquid_engine_class = MyLiquidEngineClass()

# benchmarks the implementations
my_liquid_engine_class.benchmark(nparray)

# runs the fastest implementation
print(my_liquid_engine_class.run(nparray))

# runs the Threaded implementation
print(my_liquid_engine_class.run(nparray, run_type="Python"))
