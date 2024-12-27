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
    # start_date is used as the "freeze" date for the starter code. Make sure they have the starter code before this date.
    tester = test_suite_320.build_test_suite_320("lab01", start_date="09/01/2021")
    tester.required_files(["aboutme.txt", "netid.jpg"]) # Makefile is assumed
    tester.add_Makefile_rule("about")
    tester.add_Makefile_rule("reverse", ["reverse.txt"])
    tester.add_Makefile_rule("upper", ["upper.txt"])
    tester.add_Makefile_rule("lineno", ["lineno.txt"])
    tester.add_Makefile_rule("bottom", ["bottom.txt"])
    # tester.postbuild_file_checks(["reverse.txt", "upper.txt", "upper.txt", "lineno.txt", "bottom.txt"])
    tester.run_tests()

if __name__ == "__main__":
    main()