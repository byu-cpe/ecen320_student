#***************************************************************************
# 
# Filename: synth.tcl
#
# Author: Your Name
# Description: This script reads in the verilog file and synthesizes the
#              design. The design is synthesized with the xc7a35tcpg236-1
#              part and the verbose flag is set to true, then writes to the
#              checkpoint file.
#
#***************************************************************************/

# Change message severity levels
source ../resources/messages.tcl

# Read in the design
read_verilog -sv traffic_light.sv
read_verilog -sv traffic_light_top.sv

# Read in the constraints
read_xdc traffic_light.xdc

# Synthesize the design and write the checkpoint file
synth_design -top traffic_light_top -part xc7a35tcpg236-1 -verbose
write_checkpoint -force traffic_light_top_synth.dcp
