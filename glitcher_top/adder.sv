`timescale 1ns / 1ps
/*module adder (
    input logic glitched_clk,  // Clock input
    input logic rst,           // Active-low reset
    input logic [3:0] a,       // 4-bit input A
    input logic [3:0] b,       // 4-bit input B
    output logic [4:0] sum     // 5-bit sum (to accommodate carry-out)
);

    logic [4:0] temp;  // Pipeline register stage 1

    // Stage 1: Compute sum and store in temp
    always_ff @(posedge  glitched_clk ) begin
        if (!rst) begin
            temp <= 5'b00000;  // Reset temp
        end else begin
            temp <= a + b;     // Compute sum
        end
    end

    // Stage 2: Store temp into sum (delayed by 1 cycle)
    always_ff @(posedge glitched_clk ) begin
        if (!rst) begin
            sum <= 5'b00000;   // Reset sum
        end else begin
            sum <= temp;       // Pipeline temp to sum (1 cycle delay)
        end
    end

endmodule
*/
module firstage (
    input logic DV_1,
    input logic [7:0] a,  // 4-bit input
    input logic glitched_clk,            // Clock signal
    input logic rst,          // Reset signal
    output logic [7:0] sum ,// 4-bit delayed output
    output logic DV_2
);

    // Register to store the delayed value

    // Sequential logic for one-cycle delay
    always_ff @(posedge glitched_clk ) begin
        if (!rst) begin
            sum <= 8'b00000000;  // Reset output to 0
        end else begin
            sum<= a;  // Update output one cycle later
        end
    end

    // Assign the delayed value to output
    
                
             always_ff @(posedge glitched_clk ) begin
                    if (!rst) begin
                        DV_2 <= 1'b0;  // Reset output to 0
                    end else begin
                        DV_2<=DV_1;  // Update output one cycle later
                    end
    end

endmodule
