`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2025 10:59:07 AM
// Design Name: 
// Module Name: secstage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module secstage(
input logic glitched_clk,
input logic rst,
input logic [7:0]  sum,
output logic [7:0] finout,
input logic DV_2,
output logic DV_3
    );
    //logic [4:0] temp;
          //  logic [4:0] outemp;
             // Sequential logic for one-cycle delay
            always_ff @(posedge glitched_clk) begin
                if (!rst) begin
                    finout <= 8'b00000000;  // Reset output to 0
                end else begin
                    finout<= sum;  // Update output one cycle later
                end
            end
    
                   always_ff @(posedge glitched_clk) begin
                if (!rst) begin
                    DV_3 <= 1'b0;  // Reset output to 0
                end else begin
                    DV_3<= DV_2;  // Update output one cycle later
                end
            end
    
endmodule
