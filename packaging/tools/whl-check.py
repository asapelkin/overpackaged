#!/usr/bin/env python3

import argparse
import os
import sys
from wheel_filename import parse_wheel_filename


def check_wheel_files(directory, allowed_tags):
    errors_num = 0
    for filename in os.listdir(directory):
        if not filename.endswith(".whl"):
            print(
                f"Error: non-wheel file found: {filename}",
                file=sys.stderr
            )
            errors_num += 1
            continue
        platform_tags = parse_wheel_filename(filename).platform_tags
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


if __name__ == "__main__":
    main()
