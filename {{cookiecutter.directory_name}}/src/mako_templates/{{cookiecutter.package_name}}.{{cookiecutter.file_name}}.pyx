<%!
schedulers = ['unthreaded','threaded','threaded_guided','threaded_dynamic','threaded_static']
%># cython: infer_types=True, wraparound=False, nonecheck=False, boundscheck=False, cdivision=True, language_level=3, profile=False, autogen_pxd=False

import numpy as np
cimport numpy as np
from cython.parallel import parallel, prange
from nanopyx.__liquid_engine__ import LiquidEngine

class {{cookiecutter.class_name}}(LiquidEngine):

    def __init__(self, clear_benchmarks=False, testing=False):
        self._designation = "{{cookiecutter.class_name}}"

        # change the runtypes you want to implement to True in the super().__init__() call.
        super().__init__(clear_benchmarks=clear_benchmarks, testing=testing, 
                        opencl_=False, unthreaded_=True, threaded_=False, threaded_static_=False, 
                        threaded_dynamic_=False, threaded_guided_=False,
                        njit_=False, python_=True, transonic_=False, cuda_=False, dask_=False)

        self._default_benchmarks = {'Unthreaded': {"(['shape(100, 100)', 'shape(5, 5)'], {})": [250000, 0.0002, 0.0002, 0.0002], "(['shape(500, 500)', 'shape(11, 11)'], {})": [30250000, 0.03, 0.03, 0.03]}, 'Python': {"(['shape(100, 100)', 'shape(5, 5)'], {})": [250000, 0.0002, 0.0002, 0.0002], "(['shape(500, 500)', 'shape(11, 11)'], {})": [30250000, 0.03, 0.03, 0.03]}} # do this in case you don't want to make running the benchmark method mandatory.
        # structure of this dictionary should follow this structure:
        # The benchmark file is read as dict of dicts.
        #     BENCHMARK DICT FOR A SPECIFIC METHOD
        #         |- RUN_TYPE #1
        #         |      |- ARGS_REPR #1
        #         |      |      |- [score, t2run#1, t2run#2, t2run#3, ...] last are newer. nan means fail
        #         |      |- ARGS_REPR #2
        #         |      |      |- [score, t2run#1, t2run#2, t2run#3, ...] last are newer. nan means fail
        #         |      (...)
        #         |- RUN_TYPE #2
        #         (...)
        # Example: {'OpenCL': {"(['shape(100, 100)', 'shape(5, 5)'], {})": [250000, 0.0097, 0.0032, 0.00365], "(['shape(500, 500)', 'shape(11, 11)'], {})": [30250000, 0.0074, 0.0073, 0.007]}, 'Threaded': {"(['shape(100, 100)', 'shape(5, 5)'], {})": [250000, 0.0002, 0.0001, 0.0001], "(['shape(500, 500)', 'shape(11, 11)'], {})": [30250000, 0.007, 0.006, 0.008}, 'Threaded_dynamic': {"(['shape(100, 100)', 'shape(5, 5)'], {})": [250000, 0.0001, 0.00015, 0.0002], "(['shape(500, 500)', 'shape(11, 11)'], {})": [30250000, 0.005, 0.005, 0.005]}, 'Threaded_guided': {"(['shape(100, 100)', 'shape(5, 5)'], {})": [250000, 0.0001, 0.0001, 0.0001], "(['shape(500, 500)', 'shape(11, 11)'], {})": [30250000, 0.005, 0.005, 0.005]}, 'Threaded_static': {"(['shape(100, 100)', 'shape(5, 5)'], {})": [250000, 0.00018, 0.00018, 0.0002], "(['shape(500, 500)', 'shape(11, 11)'], {})": [30250000, 0.005, 0.006, 0.006]}, 'Unthreaded': {"(['shape(100, 100)', 'shape(5, 5)'], {})": [250000, 0.0002, 0.0002, 0.0002], "(['shape(500, 500)', 'shape(11, 11)'], {})": [30250000, 0.03, 0.03, 0.03]}}

    def run(self, input_array, run_type=None):
        return self._run(input_array, run_type=run_type)

    % for sch in schedulers:
    def _run_${sch}(self, float[:, :] input_array):
        cdef float array_sum = 0.0

        cdef int rows = input_array.shape[0]
        cdef int cols = input_array.shape[1]

        cdef int i,j
        with nogil:
            % if sch=='unthreaded':
            for i in range(rows):
            % elif sch=='threaded':
            for i in prange(rows):
            % else:
            for i in prange(rows, schedule="${sch.split('_')[1]}"):
            % endif
                for j in range(cols):
                    array_sum = array_sum + input_array[i, j]

        return array_sum

    % endfor

    def _run_python(self, input_array):
        array_sum = 0.0

        for i in range(input_array.shape[0]):
            for j in range(input_array.shape[1]):
                array_sum = array_sum + input_array[i, j]

        return array_sum