#!/usr/bin/env python
from __future__ import print_function
import os
import sys

#
#  spit out the current working directory to stdout in the peculiar
#  form that docker for windows seems to want bash for windows to emit
#
#  Keith R. Brafford
#  https://github.com/kbrafford/containerized_multimake
#

#  >>> import os
#  >>> print os.getcwd()
#  C:\Users\Public\github\rscode
#
#  >>> fix_dir(os.getcwd())
#  '/c/Users/Public/github/rscode'

def fix_dir(cwd):
    """Returns the current working directory.
    If run from Windows the path format is changed to bash/docker format
    otherwise it is left as-is.
    
    >>> fix_dir(os.getcwd())
    '/c/Users/Public/github/rscode'
    """
    if sys.platform == "win32":
        cwd = cwd.replace("\\","/").replace(":","")
        if not cwd.startswith("/"):
            cwd = "/" + cwd
        cwd = "/" + cwd[1].lower() + cwd[2:]
    return cwd

cwd = fix_dir(os.getcwd())

print(cwd)
