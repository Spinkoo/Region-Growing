#Build Cython version of the code

#Build command is : python setup.py build_ext --inplace

from setuptools import setup
from Cython.Build import cythonize

setup(
    name='Region Growing Cython',
    ext_modules=cythonize("c_RegionGrowing.pyx"),
    zip_safe=False,
)