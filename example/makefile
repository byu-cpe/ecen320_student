#***************************************************************************
# 
# Filename: makefile
#
# Author: Your Name
# Description: Makefile for traffic_light for running, testing, and cleaning up.
#
#***************************************************************************/

.PHONY: all sim sim_traffic_light sim_traffic_light_tb pre_synth synth implement bit clean

all: synth implement

sim: sim_traffic_light

sim_traffic_light:
	xvlog traffic_light.sv -sv --nolog
	xelab traffic_light -debug typical --nolog --timescale 1ns/1ps
	xsim traffic_light -gui -tclbatch sim_traffic_light.tcl -log sim_traffic_light.log
	# xsim traffic_light -gui --nolog

sim_traffic_light_tb:
	xvlog traffic_light.sv tb_traffic_light.sv -sv --nolog
	xelab tb_traffic_light -debug typical --nolog --timescale 1ns/1ps
	xsim tb_traffic_light -log sim_traffic_light_tb.log --runall
	# xsim tb_traffic_light -gui --nolog

pre_synth:
	vivado -source pre_synth_schematic.tcl -log pre_synth_schematic.log -nojournal -notrace

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

bit:
	python3 ../resources/openocd.py traffic_light_top.bit

clean:
	rm -f *.log
	rm -f *.jou
	rm -f *.wdb
	rm -f *.pb
	rm -f *.rpt
	rm -f *.dcp
	rm -f *.txt
	rm -f *.bit
	rm -rf xsim.dir/*
	rm -rf .Xil/*
