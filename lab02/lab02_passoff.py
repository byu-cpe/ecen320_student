#!/usr/bin/python3

# Manages file paths
import pathlib
import sys

sys.dont_write_bytecode = True # Prevent the bytecodes for the resources directory from being cached
# Add to the system path the "resources" directory relative to the script that was run
resources_path = pathlib.Path(__file__).resolve().parent.parent  / 'resources'
sys.path.append( str(resources_path) )

import test_suite_320
import repo_test

def main():
    tester = test_suite_320.build_test_suite_320("lab02", max_repo_files = 10)
    # Add a test that checks to make sure the vivado tools are available in the executing environment
    #  (check_exec_test)
    # tester.add_make_test("about")
    # tester.add_make_test("reverse")
    # tester.add_make_test("upper")
    # tester.add_make_test("lineno")
    # tester.add_make_test("bottom")
    # tester.add_file_checks(["reverse.txt", "upper.txt", "upper.txt", "lineno.txt", "bottom.txt"])
    tester.run_tests()

if __name__ == "__main__":
    main()