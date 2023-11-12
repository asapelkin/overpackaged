# Overpackaged

## Overview
This project serves as a demonstration of various methods of packaging a standalone Python application in a truly (i hope) portable way.
![Alt text](image.png)

## About the Experimental Application

The experimental application, named myapp, is written in Python and depends on:

- `pycurl`
- `click`
- `psycopg2`
- and `C` extension called myextension

`myapp` also includes a `myapp run` command which verifies that the dependencies are working correctly.

### Detailed Explanation
`psycopg2` and `pycurl` were deliberately chosen because they have system dependencies and C extensions, yet do not come with pre-built binary wheels. Therefore, they will be compiled on dev machine, which could lead to portability issues. These issues arise not just from system dependencies but also if your system has a newer version of glibc than the one that is broadly compatible.

The build scripts in the Overpackaged project address these problems by repacking (fixing) each dependency and `myapp` itself into a `manylinux` compliant wheel with [auditwheel](https://github.com/pypa/auditwheel) tool. This process ensures that the resulting wheels are portable across various Linux distributions that support the `manylinux` standard.

Moreover, the build process using tools like `PyOxidizer` and `Nuitka` takes place in a controlled environment, ensuring the generation of portable build artifacts. This method maintains consistency across different build environments and systems.


## Build artifacts
After the build `myapp` will be available as five different types of executables:

- `myapp.AppImage` – An AppImage containing both Python and `myapp`, allowing it to run on many Linux systems without installation.
- `myapp_nuitka_onefile` – A standalone executable compiled with [Nuitka](https://github.com/Nuitka/Nuitka). It includes all necessary shared libraries within a single file.
- `myapp_nuitka_as_folder/myapp` – Similar to the one-file version, but with shared libraries placed in the same directory rather than compiled into the binary.
- `pyoxidizer/myapp` – A binary produced by [PyOxidizer](https://github.com/indygreg/PyOxidizer) that packaging Python and `myapp` into a single executable, which extracts itself at runtime.
- `myapp.pex` – An executable created with [PEX](https://github.com/pantsbuild/pex) that **does not** include Python and requires a separate Python environment to run.


## Prerequisites
To build and test this project, you will need:

- docker
- make
- [hyperfine](https://github.com/sharkdp/hyperfine) (needed only for benchmarking)

## Building the Project
To build the whole project, run the following command:

```bash
make pyoxidizer nuitka pex appimage
```

**Or** to build only one of the executables:
```bash
make pyoxidizer
make nuitka
make pex
make appimage
```


## Benchmarking

To benchmark the performance of the packaged applications, use the following command:

```bash
make benchmark
```

This command will run `pyoxidizer`, `appimage` and two `nuitka` executables and compare two metrics among them - the startup time and full time

Output should look close to this:
```bash
Benchmarking startup time...

Summary
  pyoxidizer/myapp --help ran
    3.21 ± 0.26 times faster than myapp_nuitka_as_folder/myapp --help
    5.72 ± 0.71 times faster than myapp_nuitka_onefile --help
    7.04 ± 1.53 times faster than myapp.AppImage --help


Benchmarking full working time...

Summary
  pyoxidizer/myapp run ran
    1.58 ± 0.30 times faster than myapp_nuitka_as_folder/myapp run
    2.28 ± 0.42 times faster than myapp_nuitka_onefile run
    2.79 ± 0.54 times faster than myapp.AppImage run
```

## Portability Testing

To test the portability of the packaged applications across different Linux distributions, use:
```bash
make portability-test
```
This command will run  `pyoxidizer`, and `nuitka` made executables in following linux systems:
-  ubuntu:17.04
-  ubuntu:18.04
-  ubuntu:20.04
-  opensuse/leap:15.0
-  debian:9
-  debian:10

Output should look close to this:
```bash
Testing myapp_nuitka_onefile on ubuntu:17.04...
Success: myapp_nuitka_onefile passed on ubuntu:17.04
Testing pyoxidizer/myapp on ubuntu:17.04...
Success: pyoxidizer/myapp passed on ubuntu:17.04
... truncated ...
Success: pyoxidizer/myapp passed on debian:9
Testing myapp_nuitka_as_folder/myapp on debian:10...
Success: myapp_nuitka_as_folder/myapp passed on debian:10
Testing pyoxidizer/myapp on debian:10...
Success: pyoxidizer/myapp passed on debian:10
Total tests run: 18
Successes: 18
Failures: 0
```