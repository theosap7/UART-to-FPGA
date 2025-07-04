`timescale 1ns / 1ps
module counter 
(
    input logic clk_in1,
         
    output logic cnt
);
    
    localparam position = 2'b10;  // Set to 4 to trigger every 4 cycles
    logic [3:0] temp = 0;    // 4-bit counter (0 to 3 for 4-cycle pulse)

    always_ff @(posedge clk_in1) begin
       

            if (temp == position ) begin
                cnt <= 1;
                temp <= 0;   // Reset counter after reaching threshold
            end else begin
                cnt <= 0;
                temp <= temp + 1;
            end
        end
 

endmodule
