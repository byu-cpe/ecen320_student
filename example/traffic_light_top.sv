/***************************************************************************
* 
* Filename: traffic_light_top.sv
*
* Author: Your Name
* Description: This is a top-level module for a traffic light system.
*              It divides the incoming 100MHz clock to generate a slow clock,
*              receives a 4-bit switch input (sw) from the board, and instantiates
*              the traffic_light FSM to control the traffic lights.
*
****************************************************************************/

module traffic_light_top(
    input logic clk,              // 100MHz clock input from FPGA board
    input logic rst,              // Active-high synchronous reset (connects to a button)
    input logic [3:0] sw,         // 4-bit switch input (e.g., from the Basys3 board)
    output logic [2:0] main_light,// 3-bit output for the main road light (LED 0-2)
    output logic [2:0] side_light // 3-bit output for the side road light (LED 3-5)
);
    // ------------------------------------------------------------
    // Local signal declarations
    // ------------------------------------------------------------
    localparam DIVISOR = 25000000; 
    // If clk = 100MHz, dividing by 25,000,000 yields ~4Hz slow clock.
    localparam DIVISOR_WIDTH = $clog2(DIVISOR);

    // divider_count is used to generate the slow clock.
    logic [DIVISOR_WIDTH-1:0] divider_count;
    logic slow_clk;



    // ------------------------------------------------------------
    // Drive slow_clk
    // ------------------------------------------------------------

    // Increment divider_count.
    always_ff @(posedge clk) begin
        if (rst) begin
            divider_count <= 0;
        end else begin
            divider_count <= divider_count + 1;
        end
    end

    // Assign slow_clk to the most significant bit of divider_count,
    // producing a slow clock derived from the fast clk.
    always_comb begin
        slow_clk = divider_count[DIVISOR_WIDTH-1];
    end



    // ------------------------------------------------------------
    // traffic_light FSM
    // ------------------------------------------------------------

    // Instantiate the traffic_light module (with parameter override) to
    // generate the main_light and side_light outputs. The FSM is driven by the
    // slow_clk and uses the switch input (sw) to adjust state durations.
    traffic_light #(
        .MAIN_GO_TIME   (6),
        .MAIN_WAIT_TIME (3),
        .SIDE_GO_TIME   (6),
        .SIDE_WAIT_TIME (3)
    ) traffic_light_inst (
        .clk(slow_clk),
        .rst(rst),
        .sw(sw),
        .main_light(main_light),
        .side_light(side_light)
    );

endmodule
