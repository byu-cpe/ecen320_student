#!/usr/bin/python3

# Manages file paths
import pathlib
import sys

# Add to the system path the "resources" directory relative to the script that was run
resources_path = pathlib.Path(__file__).resolve().parent.parent  / 'resources'
sys.path.append( str(resources_path) )

import test_suite_320

def main():
    tester = test_suite_320.build_test_suite_320("lab01", max_repo_files = 5)
    tester.add_make_test("about")
    tester.add_make_test("reverse")
    tester.add_make_test("upper")
    tester.add_make_test("lineno")
    tester.add_make_test("bottom")
    tester.run_tests()

if __name__ == "__main__":
    main()