/***************************************************************************
#
# Filename: sim_traffic_light.tcl
#
# Author: Your Name
# Description: This simulation script tests the traffic_light_top module.
#              It applies a 100 MHz clock, toggles the reset signal, and sets
#              a value for the 4-bit switch input (sw) to observe the transitions
#              of main_light and side_light over time.
#
****************************************************************************/

# ----------------------------------------------------------
# Check if a waveform configuration is already present
# ----------------------------------------------------------
set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
    # If no waveform configuration exists, create one and add top-level signals
    if { [llength [get_objects]] > 0 } {
        add_wave /
        set_property needs_save false [current_wave_config]
    } else {
        # Warning if no top-level signals are found
        send_msg_id Add_Wave-1 WARNING \
            "No top-level signals found. Simulator will start without a wave window. \
             If you want to open a wave window, go to 'File->New Waveform Configuration' \
             or type 'create_wave_config' in the Tcl console."
    }
}

# ----------------------------------------------------------
# Add an oscillating clock input with 10 ns period (100 MHz)
# ----------------------------------------------------------
add_force clk {0 0ns} {1 5ns} -repeat_every 10ns

# ----------------------------------------------------------
# Initial conditions for the reset signal
# ----------------------------------------------------------
# Start with reset asserted so that the FSM initializes properly.
add_force rst 1

# Set the switch input (sw) to a specific value (e.g., 4'b0010, decimal 2)
add_force sw 0010

# ----------------------------------------------------------
# Run the clock for 50 ns with reset asserted
# ----------------------------------------------------------
run 50ns

# ----------------------------------------------------------
# Deassert reset and run simulation to observe lights cycling with switch offset
# ----------------------------------------------------------
add_force rst 0
run 20ns

# The FSM uses an internal clock divider, so it may take several hundred ns to cycle.
run 2000ns

# ----------------------------------------------------------
# Optionally re-assert reset mid-simulation to observe behavior change
# ----------------------------------------------------------
puts "Re-asserting reset for 50 ns to observe mid-simulation behavior."
add_force rst 1
run 50ns

# Deassert reset again and continue simulation.
add_force rst 0
run 2000ns

# ----------------------------------------------------------
# End the simulation
# ----------------------------------------------------------
stop
