<%!
import sys
import os

sys.path.append(os.getcwd())
from src.scripts.c2cl import extract_batch_code

c_function_names = [('_c_{{cookiecutter.file_name}}.c','_c_{{cookiecutter.file_name}}')]

headers, functions = extract_batch_code(c_function_names)

defines = []

%>

% for h in self.attr.headers:
${h}
% endfor

% for d in self.attr.defines:
#define ${d[0]} ${d[1]}
% endfor

% for f in self.attr.functions:
${f}

% endfor

__kernel void kernel_{{cookiecutter.file_name}}(__global float *inputimg, __global float *outputarr, int ncols) {

    int i = get_global_id(0);
    int nrows = get_global_size(0);

    float row_sum = 0.0;

    for (int j=0;j<ncols;j++){
        row_sum = row_sum + inputimg[i*ncols+j];
    }
    
    outputarr[i] = row_sum;
}
