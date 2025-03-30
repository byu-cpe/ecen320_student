#***************************************************************************
# 
# Filename: implement.tcl
#
# Author: Your Name
# Description: This script reads in the checkpoint file and implements the
#              design. The design is optimized, placed, and routed.
#              The utilization is reported and the bitstream is written.
#              The checkpoint file is also written.
#
#***************************************************************************/

# Change message severity levels
source ../resources/messages.tcl

# Open the checkpoint file
open_checkpoint traffic_light_top_synth.dcp

# Implement the design
opt_design
place_design
route_design

# Generate the utilization report and bitstream
report_utilization -file utilization.rpt
write_bitstream -force traffic_light_top.bit
write_checkpoint -force traffic_light_top.dcp
