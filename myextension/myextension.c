#include <Python.h>
#include <stdio.h>
#include <string.h>

static PyObject* print_string(PyObject* self, PyObject* args) {
    const char* src;
    char dest[50];
    if (!PyArg_ParseTuple(args, "s", &src))
        return NULL;
    // strlcpy(dest, src, sizeof(dest));// uncomment this to fail with  undefined symbol: strlcpy
    // printf("String: %s\n", dest);
    Py_RETURN_NONE;
}

static PyMethodDef MyExtensionMethods[] = {
    {"print_string", print_string, METH_VARARGS, "Copy and print string using strlcpy."},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef myextensionmodule = {
    PyModuleDef_HEAD_INIT,
    "myextension",
    NULL,
    -1,
    MyExtensionMethods
};

PyMODINIT_FUNC PyInit_myextension(void) {
    return PyModule_Create(&myextensionmodule);
}
