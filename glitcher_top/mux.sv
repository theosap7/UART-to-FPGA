`timescale 1ns / 1ps //////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2025 12:27:58 PM
// Design Name: 
// Module Name: mux
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


//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 12:01:11 PM
// Design Name: 
// Module Name: mux
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


module mux(
input logic clk_b,
input logic clk_c,
input logic cnt,
input logic clk_in1,
output logic glitched_clk
    );
    
  logic  sel ;
  always_comb begin
  sel =cnt & clk_c & clk_in1;
  end
  
    always_comb begin
    
    if (sel ==1)
    glitched_clk= clk_b;
    else
    glitched_clk=clk_in1;
    end
endmodule


