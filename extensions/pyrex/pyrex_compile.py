#!/usr/bin/python

import Cython.Compiler.Main as main

import os, glob, sys


# if len (sys.argv) < 2:
#   pdynamo_pcore = os.getenv ("PDYNAMO_PCORE")
# else:
#   pdynamo_pcore = sys.argv[1]

current_directory  = os.getcwd ()
pxd_directories    = [current_directory, ]
# pxd_directories    = [current_directory, os.path.join (pdynamo_pcore, "extensions/pyrex")]

# Compile all files in the pyrex directory
sources = glob.glob (os.path.join (current_directory, "*.pyx"))

for source in sources:
    options = main.CompilationOptions (main.default_options)
    options.include_path.extend (pxd_directories)

    main.compile (source, options)
