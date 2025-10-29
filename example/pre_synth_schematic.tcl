#***************************************************************************
# 
# Filename: pre_synth_schematic.tcl
#
# Author: Your Name
# Description: This script reads in the verilog file and synthesizes the
#              design. The design is synthesized with the xc7a35tcpg236-1
#              part and the verbose flag is set to true.
#
#***************************************************************************/

# Read in the design
read_verilog -sv traffic_light.sv
read_verilog -sv traffic_light_top.sv

# Synthesize the design
synth_design -top traffic_light_top -rtl -rtl_skip_mlo -part xc7a35tcpg236-1 -verbose
