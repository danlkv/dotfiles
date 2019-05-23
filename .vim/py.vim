function! CallCurrentPyFunc()
py3 << EOF
import vim
import importlib.util
import sys
import os

dirpath = os.getcwd()
sys.path.append(dirpath)
print("current directory is : " + dirpath)

# load file as module
file_name = vim.current.buffer.name
spec = importlib.util.spec_from_file_location("vim_callee", file_name)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

# get name of function on current line
line = vim.current.line
fname = line.split()[-1].split('(')[0]

# call the function using __dict__
print(f"Calling function {fname} from {file_name}")
module.__dict__[fname]()
EOF
endfunction

nmap <C-c>p :call CallCurrentPyFunc()<CR>

