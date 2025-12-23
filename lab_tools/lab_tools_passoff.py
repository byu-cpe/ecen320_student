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

required_files = [
    "Makefile",
    "binary_adder/Makefile",
    "binary_adder/sim.tcl",
    "binary_adder/sim.png",
    "binary_adder/pre-synth-schematic.png",
    "binary_adder/post-synth-schematic.png",
    "logic_functions/Makefile",
    "logic_functions/pre-synth-schematic.png",
]


def main():
    # Check on vivado
    tester = test_suite_320.build_test_suite_320("lab_tools", start_date="01/20/2025")
    tester.add_required_tracked_files(required_files)
    tester.add_makefile_rule(
        "synth",
        ["synth.tcl"],
        ["synth.log", "binary_adder_synth.dcp"],
    )
    tester.add_makefile_rule(
        "implement_adder",
        ["implement_adder.tcl"],
        [
            "implement_adder.log",
            "binary_adder.bit",
            "binary_adder.dcp",
            "utilization.rpt",
        ],
    )

    status = tester.run_tests()
    RepoTestSuite.exit_with_status(status)


if __name__ == "__main__":
    main()
