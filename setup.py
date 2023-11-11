from setuptools import setup, find_packages, Extension

setup(
    name='myapp',
    version='4.2',
    packages=find_packages(),
    install_requires=[
        'Click',
        'pycurl',
        'psycopg2',
    ],
    entry_points='''
        [console_scripts]
        myapp=myapp.myapp:cli
    ''',
    ext_modules=[Extension('myextension', ['myextension/myextension.c'])],
)
