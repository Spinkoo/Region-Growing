#Build Cython version of the code


from setuptools import setup
from Cython.Build import cythonize

setup(
    name='Region Growing Cython',
    ext_modules=cythonize("c_RegionGrowing.pyx"),
    zip_safe=False,
)