
def make_exe():
    dist = default_python_distribution(python_version='3.8')
    policy = dist.make_python_packaging_policy()
    policy.allow_files = True
    policy.resources_location_fallback = "filesystem-relative:lib"
    policy.set_resource_handling_mode("files")

    python_config = dist.make_python_interpreter_config()
    python_config.module_search_paths = ["$ORIGIN/lib"]
    python_config.run_command = "from myapp import myapp; myapp.cli()"

    exe = dist.to_python_executable(
        name="myapp",
        config=python_config,
        packaging_policy=policy,
    )

    resources = exe.pip_install(["myapp"])

    for resource in resources:
        resource.add_location = "filesystem-relative:lib"
        exe.add_python_resource(resource)

    return exe

def make_embedded_resources(exe):
    return exe.to_embedded_resources()

def make_install(exe):
    files = FileManifest()
    files.add_python_resource(".", exe)
    return files

register_target("exe", make_exe)
register_target("resources", make_embedded_resources, depends=["exe"], default_build_script=True)
register_target("install", make_install, depends=["exe"], default=True)

resolve_targets()