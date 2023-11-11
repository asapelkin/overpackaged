#!/usr/bin/env python3

import argparse
import os
import sys
import re


def parse_wheel_filename(filename):
    wheel_info = re.match(r'^(.+)-(.+)-(.+)-(.+)-(.+)\.whl$', filename)
    if not wheel_info:
        return None
    return {
        'distribution': wheel_info.group(1),
        'version': wheel_info.group(2),
        'build_tag': wheel_info.group(3),
        'python_tag': wheel_info.group(4),
        'abi_tag': wheel_info.group(5),
        'platform_tags': wheel_info.group(5).split('.'),
    }


def check_wheel_files(directory, allowed_tags):
    errors_num = 0
    wheels = [fn for fn in os.listdir(directory) if fn.endswith(".whl")]
    for filename in wheels:
        platform_tags = parse_wheel_filename(filename)['platform_tags']
        
        # Checking if any of the platform tags are in the allowed tags
        if not any(tag in allowed_tags for tag in platform_tags):
            print(
                f"Error: wheel package without supported platform tags was found: "
                f"{filename}. Package tags: [{', '.join(platform_tags)}], "
                f"supported tags: [{', '.join(allowed_tags)}]",
                file=sys.stderr
            )
            errors_num += 1
    return errors_num


def main():
    parser = argparse.ArgumentParser(
        description="This script accepts a wheelhouse"
        "directory and makes sure that only wheels "
        "with passed tags are in it."
    )
    parser.add_argument("directory", help="The directory containing the wheels.")
    parser.add_argument(
        "allowed_tags", nargs="+", help="The list of allowed platform tags."
    )
    args = parser.parse_args()

    errors_num = check_wheel_files(args.directory, args.allowed_tags)
    if errors_num > 0:
        sys.exit(errors_num)
    else:
        print("Wheelhouse is compatible with the provided tags.")


if __name__ == "__main__":
    main()
