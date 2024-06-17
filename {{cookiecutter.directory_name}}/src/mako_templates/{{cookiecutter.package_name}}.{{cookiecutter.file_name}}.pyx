<%!
schedulers = ['unthreaded','threaded','threaded_guided','threaded_dynamic','threaded_static']
%># cython: infer_types=True, wraparound=False, nonecheck=False, boundscheck=False, cdivision=True, language_level=3, profile=False, autogen_pxd=False

import numpy as np
cimport numpy as np
from cython.parallel import parallel, prange
from liquid_engine import LiquidEngine
from liquid_engine.__opencl__ import cl, cl_array

cdef extern from "_c_{{cookiecutter.file_name}}.h":
    float _c_{{cookiecutter.file_name}}(float x, float y) nogil

class {{cookiecutter.class_name}}(LiquidEngine):

    def __init__(self, clear_benchmarks=False, testing=False, verbose=True):
        self._designation = "{{cookiecutter.class_name}}"

        # change the runtypes you want to implement to True in the super().__init__() call.
        super().__init__(clear_benchmarks=clear_benchmarks, testing=testing,verbose=True)

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

    def benchmark(self,input_array,run_type=None):
        return super().benchmark(input_array)

    % for sch in schedulers:
    def _run_${sch}(self, float[:, :] input_array):
        cdef float[:] array_sum = np.empty((input_array.shape[0],)).astype(np.float32)

        cdef int rows = input_array.shape[0]
        cdef int cols = input_array.shape[1]
        cdef float row_sum

        cdef int i,j
        with nogil:
            % if sch=='unthreaded':
            for i in range(rows):
            % elif sch=='threaded':
            for i in prange(rows):
            % else:
            for i in prange(rows, schedule="${sch.split('_')[1]}"):
            % endif
                row_sum = 0.0
                for j in range(cols):
                    row_sum = _c_{{cookiecutter.file_name}}(row_sum,input_array[i, j])
                array_sum[i] = row_sum

        return np.asarray(array_sum).astype(np.float32)

    % endfor

    def _run_python(self, input_array):
        array_sum = np.empty((input_array.shape[0],))

        for i in range(input_array.shape[0]):
            row_sum = 0.0
            for j in range(input_array.shape[1]):
                row_sum = row_sum + input_array[i, j]

            array_sum[i] = row_sum

        return array_sum

    def _run_opencl(self, input_array, dict device):

        cl_ctx = cl.Context([device['device']])
        dc = device['device']
        cl_queue = cl.CommandQueue(cl_ctx)

        code = self._get_cl_code("{{cookiecutter.file_name}}.cl", device['DP'])
        prg = cl.Program(cl_ctx,code).build()
        knl_{{cookiecutter.file_name}} = prg.kernel_{{cookiecutter.file_name}}

        rows = input_array.shape[0]
        cols = input_array.shape[1]

        input_cl = cl.Buffer(cl_ctx, cl.mem_flags.READ_ONLY, input_array.nbytes)
        cl.enqueue_copy(cl_queue, input_cl, input_array).wait()

        output_array = np.empty((input_array.shape[0],)).astype(np.float32)
        output_cl = cl.Buffer(cl_ctx, cl.mem_flags.READ_ONLY, output_array.nbytes)

        knl_{{cookiecutter.file_name}}(cl_queue,
                                       (rows,),
                                       None,
                                       input_cl,
                                       output_cl,
                                       np.int32(cols))

        cl_queue.finish()
        cl.enqueue_copy(cl_queue, output_array, output_cl).wait()

        return output_array


    def _compare_runs(self, output_1, output_2):
        if np.allclose(output_1,output_2):
            return True
        else:
            return False