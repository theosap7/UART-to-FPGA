`timescale 1ns / 1ps

module glitcher_top (
    input logic clk_in1,      // Main system clock (FPGA clock)
    input logic rst, 
    input logic [7:0] a,
    input logic switch,
    //input logic [3:0] b,         // Reset button
    output logic [7:0] finout,// LED output
    input logic DV_1,
    output logic DV_3
);

   
    logic clk_b, clk_c;  // Clock wizard outputs
    logic cnt;           // Counter output for glitch control
    logic glitched_clk;  // Glitch-injected clock signal
    logic [7:0] sum;
    logic DV_2;
  
    clk_wiz_0 clk_gen (
        .clk_b(clk_b),
        .clk_c(clk_c),
        .clk_in1(clk_in1),
        .resetn(rst)
    );

  
    counter glitch_counter (
        .clk_in1(clk_in1),
        .cnt(cnt)
    );


    mux glitch_mux (
        .clk_b(clk_b),
        .clk_c(clk_c),
        .cnt(cnt),
        .clk_in1(clk_in1),
        .switch(switch),
        .glitched_clk(glitched_clk)
    );

  
    firstage glitch_firstage(
        
        .glitched_clk(glitched_clk),
        .rst(rst),
        .a(a),
       //.b(b),
        .sum(sum),
        .DV_1(DV_1),
        .DV_2(DV_2)
    );

 secstage glitch_secstage(
        
        .glitched_clk(glitched_clk),
        .rst(rst),
        .sum(sum),
       //.b(b),
        .finout(finout),
        .DV_3(DV_3),
        .DV_2(DV_2)
    );

endmodule

