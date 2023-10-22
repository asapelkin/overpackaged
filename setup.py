from setuptools import setup, Extension

setup(
    name='myapp',
    version='0.1',
    py_modules=['myapp'],
    install_requires=[
        'Click',
        'pycurl',
        'psycopg2',
    ],
    entry_points='''
        [console_scripts]
        myapp=myapp:cli
    ''',
    ext_modules=[Extension('myextension', ['myextension.c'])],
)
