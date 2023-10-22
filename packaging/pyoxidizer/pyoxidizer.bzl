def make_exe():
    dist = default_python_distribution()
    policy = dist.make_python_packaging_policy()
    policy.extension_module_filter = "all"
    policy.include_distribution_sources = True
    policy.include_distribution_resources = False
    policy.include_test = False

    python_config = dist.make_python_interpreter_config()
    python_config.run_command = "from myapp import main; main()"

    exe = dist.to_python_executable(
        name="myapp",
        packaging_policy=policy,
        config=python_config,
    )

    # exe.add_python_resources(exe.read_virtualenv("/home/magn/projs/piterpy2023/myapp/myapp_pyoxidizer/pox_venv"))
    exe.add_python_resources(exe.read_package_root(CWD, ["myapp"]))
    exe.add_python_resources(exe.pip_install(["pycurl", "Click", "psycopg2"]))
        
    exe.add_library("/usr/lib/libcurl.so")
    exe.add_library("/usr/lib/libssl.so")
    exe.add_library("/usr/lib/libpq.so")
    return exe

register_target("exe", make_exe)
# Resolve whatever targets the invoker of this configuration file is requesting
# be resolved.
resolve_targets()