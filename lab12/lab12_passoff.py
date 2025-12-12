#!/usr/bin/python3

# Manages file paths
import pathlib
import sys

sys.dont_write_bytecode = (
    True  # Prevent the bytecodes for the resources directory from being cached
)
# Add to the system path the "resources" directory relative to the script that was run
resources_path = pathlib.Path(__file__).resolve().parent.parent / "resources"
sys.path.append(str(resources_path))

from repo_test_suite import RepoTestSuite
import test_suite_320
import repo_test


def main():
    tester = test_suite_320.build_test_suite_320(
        "lab12", max_repo_files=30, start_date="03/31/2025"
    )
    tester.add_required_tracked_files(
        [
            "char_gen.sv",
            "sim_char_gen.tcl",
            "sim_char_gen.png",
            "char_gen_top.sv",
            "sim_char_gen_top.tcl",
            "sim_char_gen_top.png",
            "mymessage.txt",
            "fontrom.png",
        ]
    )
    tester.add_Makefile_rule(
        "sim_char_gen_tb", ["char_gen.sv"], ["sim_char_gen_tb.log"]
    )
    tester.add_build_test(
        repo_test.FileRegexCheck(
            tester,
            "sim_char_gen_tb.log",
            "Simulation done with 0 errors",
            "Char Gen Testbench Test",
            error_on_match=False,
            error_msg="Char Gen Testbench failed",
        )
    )
    tester.add_Makefile_rule("mymessage.mem", ["mymessage.txt"], ["mymessage.mem"])
    tester.add_Makefile_rule(
        "synth",
        ["char_gen.sv", "char_gen_top.sv"],
        ["synthesis.log", "char_gen_top_synth.dcp"],
    )
    tester.add_Makefile_rule(
        "implement",
        ["char_gen_top_synth.dcp"],
        [
            "implement.log",
            "char_gen_top.bit",
            "char_gen_top.dcp",
            "utilization.rpt",
            "timing.rpt",
        ],
    )
    status = tester.run_tests()
    RepoTestSuite.exit_with_status(status)


if __name__ == "__main__":
    main()
