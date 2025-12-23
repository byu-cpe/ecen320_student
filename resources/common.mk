.ONESHELL:

work:
	mkdir -p work

sim: work
	@if [ -z "$(MODULE_NAME)" ]; then echo "Error: MODULE_NAME not set"; exit 1; fi
	@if [ -z "$(SV_FILES)" ]; then echo "Error: SV_FILES not set"; exit 1; fi
	cd work
	xvlog $(addprefix ../,$(SV_FILES)) -sv --nolog
	xelab $(MODULE_NAME) -debug typical --nolog -L unisims_ver --timescale 1ns/1ps $(foreach PARAM,$(SIM_PARAMS),--generic_top '$(PARAM)')
	xsim $(MODULE_NAME) -tclbatch ../sim.tcl -log sim.log $(if $(filter 1,$(NOGUI)),,-gui)

sim_nogui:
	$(MAKE) NOGUI=1 sim

sim_tb: work
	@if [ -z "$(SV_FILES)" ]; then echo "Error: SV_FILES not set"; exit 1; fi
	cd work
	xvlog ../tb.sv $(addprefix ../,$(SV_FILES)) -sv --nolog
	xelab tb -debug typical --nolog -L unisims_ver --timescale 1ns/1ps $(foreach PARAM,$(SIM_PARAMS),--generic_top '$(PARAM)')
	xsim tb -log sim_tb.log --runall

pre_synth_schematic: work
	@if [ -z "$(MODULE_NAME)" ]; then echo "Error: MODULE_NAME not set"; exit 1; fi
	@if [ -z "$(SV_FILES)" ]; then echo "Error: SV_FILES not set"; exit 1; fi
	cd work
	export MODULE_NAME=$(MODULE_NAME)
	export SV_FILES="$(addprefix ../,$(SV_FILES))"
	vivado -source ../$(REPO_PATH)/resources/presynth_schematic.tcl -notrace -nojournal

synth: work work/synth.dcp
work/synth.dcp: $(SV_FILES) basys3.xdc
	@if [ -z "$(REPO_PATH)" ]; then echo "Error: REPO_PATH not set"; exit 1; fi
	@if [ -z "$(MODULE_NAME)" ]; then echo "Error: MODULE_NAME not set"; exit 1; fi
	@if [ -z "$(SV_FILES)" ]; then echo "Error: SV_FILES not set"; exit 1; fi
	cd work 
	export REPO_PATH=$(REPO_PATH)
	export MODULE_NAME=$(MODULE_NAME)
	export SV_FILES="$(addprefix ../,$(SV_FILES))"
	export XDC_PATH="../basys3.xdc"
	vivado -mode batch -source ../$(REPO_PATH)/resources/synth.tcl -log synth.log -nojournal -notrace

open_synth_checkpoint: work/synth.dcp
	cd work
	vivado synth.dcp -notrace -nojournal

implement: work work/implement.dcp
work/implement.dcp: work/synth.dcp
	cd work
	vivado -mode batch -source ../$(REPO_PATH)/resources/implement.tcl -log implement.log -nojournal -notrace

open_implement_checkpoint: work/implement.dcp
	cd work
	vivado implement.dcp -notrace -nojournal

download: work/implement.dcp
	cd work
	python3 ../$(REPO_PATH)/resources/openocd.py design.bit

clean:
	rm -rf work