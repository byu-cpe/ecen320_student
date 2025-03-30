/***************************************************************************
* 
* Filename: traffic_light.sv
*
* Author: Your Name
* Description: This module implements a finite state machine for controlling
*              traffic lights. It cycles through states to control the main 
*              and side lights, allowing a green light for a set duration on 
*              either road. The 4-bit switch input (sw) is used as an offset 
*              for the timing of each state.
*
****************************************************************************/

module traffic_light #(
    parameter MAIN_GO_TIME   = 5,
    parameter MAIN_WAIT_TIME = 2,
    parameter SIDE_GO_TIME   = 5,
    parameter SIDE_WAIT_TIME = 2
)(
    input logic clk,
    input logic rst,
    input logic [3:0] sw,          // 4-bit switch input; sw values used as timing offset
    output logic [2:0] main_light, // Format: {Red, Yellow, Green} for main road
    output logic [2:0] side_light  // Format: {Red, Yellow, Green} for side road
);

    // ------------------------------------------------------------
    // Local signal declarations
    // ------------------------------------------------------------
    // localparam for the timer register bit width; 4 bits can count up to 15.
    localparam TIMER_WIDTH = 4;

    // Define FSM states using a typedef enum logic.
    typedef enum logic [1:0] {
        MAIN_GO,    // Main road green
        MAIN_WAIT,  // Main road yellow
        SIDE_GO,    // Side road green
        SIDE_WAIT   // Side road yellow
    } traffic_state_t;
    traffic_state_t current_state, next_state;

    // timer_reg holds the counter value for the duration in the current state.
    logic [TIMER_WIDTH-1:0] timer_reg;
    // state_transition is asserted when the timer reaches the specified threshold.
    logic state_transition;



    // ------------------------------------------------------------
    // timer register
    // ------------------------------------------------------------
    // S13: This always_ff block updates timer_reg on each clock cycle.
    // If rst is asserted or a state transition occurs, timer_reg is reset to 0.
    // Otherwise, it increments directly by 1.
    always_ff @(posedge clk) begin
        if (rst) begin
            timer_reg <= 0;
        end else begin
            if (state_transition) begin
                timer_reg <= 0;
            end else begin
                timer_reg <= timer_reg + 1;
            end
        end
    end



    // ------------------------------------------------------------
    // state machine
    // ------------------------------------------------------------

    // This always_ff block updates current_state based on the computed next_state.
    // On reset, current_state is initialized to MAIN_GO.
    always_ff @(posedge clk) begin
        if (rst) begin
            current_state <= MAIN_GO;
        end else begin
            current_state <= next_state;
        end
    end

    // Computes the next state of the FSM and determines whether a state transition
    // should occur (via state_transition). It also sets the relevant output
    // values for main_light and side_light based on the current state.
    always_comb begin
        // Default assignments to prevent latches.
        next_state = current_state;
        state_transition = 0;

        // Default both lights to Red.
        main_light = 3'b100;
        side_light = 3'b100;

        // Use the switch value (sw) as an offset for each state's duration.
        // For example, effective MAIN_GO duration = MAIN_GO_TIME + sw.
        case (current_state)
            MAIN_GO: begin
                main_light = 3'b001; // Main road green
                if (timer_reg >= (MAIN_GO_TIME + sw - 1)) begin
                    next_state = MAIN_WAIT;
                    state_transition = 1;
                end
            end

            MAIN_WAIT: begin
                main_light = 3'b010; // Main road yellow
                if (timer_reg >= (MAIN_WAIT_TIME + sw - 1)) begin
                    next_state = SIDE_GO;
                    state_transition = 1;
                end
            end

            SIDE_GO: begin
                side_light = 3'b001; // Side road green
                if (timer_reg >= (SIDE_GO_TIME + sw - 1)) begin
                    next_state = SIDE_WAIT;
                    state_transition = 1;
                end
            end

            SIDE_WAIT: begin
                side_light = 3'b010; // Side road yellow
                if (timer_reg >= (SIDE_WAIT_TIME + sw - 1)) begin
                    next_state = MAIN_GO;
                    state_transition = 1;
                end
            end

            // An optional default case can be added if needed.
            // default: begin
            //     next_state = MAIN_GO;
            //     state_transition = 1;
            // end
        endcase
    end

endmodule
