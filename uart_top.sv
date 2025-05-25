module UART_Loopback_Top
  (input  logic i_Clk,       // Main Clock
   input logic  i_UART_RX,  // UART RX Data
   output logic o_UART_TX,   // UART TX Data
   input logic rst
 ); 
 
  //logic o_RX_DV;
  //logic [7:0] o_RX_Byte;
  wire w_TX_Active, w_TX_Serial;
  wire [7:0] w_Tx_Byte;
  wire w_Tx_DV;
  wire [7:0] w_RX_Byte;
  wire w_RX_DV;
  // 25,000,000 / 115,200 = 217
  
   logic [7:0] i_Glitcher_Byte;
  logic i_Glitcher_DV;
  //RX TO TO GLITCHER PIPELINE STAGE 
   always_ff @(posedge i_Clk ) begin
        if (!rst) begin
             i_Glitcher_DV <= 1'b0; 
             i_Glitcher_Byte <= 8'b00000000;
        end else begin
            i_Glitcher_DV<= w_RX_DV;
            i_Glitcher_Byte <= w_RX_Byte; // Update output one cycle later
        end
    end
     
     logic [7:0] i_Tx_Byte;
     logic i_Tx_DV;
  
  uart_rx #(.CLKS_PER_BIT(434)) UART_RX_Inst
  (.i_Clock(i_Clk),
   .i_Rx_Serial(i_UART_RX),
   .o_Rx_DV(w_RX_DV),
   .o_Rx_Byte(w_RX_Byte));
    
 uart_tx #(.CLKS_PER_BIT(434)) UART_TX_Inst
  (.i_Clock(i_Clk),
   .i_Tx_DV(i_Tx_DV),      // Pass RX to TX module for loopback
   .i_Tx_Byte(i_Tx_Byte),  // Pass RX to TX module for loopback
   .o_Tx_Active(w_TX_Active),
   .o_Tx_Serial(w_TX_Serial),
   .o_Tx_Done());
  

  //GLITCHER TO TO TX PIPELINE STAGE 
   always_ff @(posedge i_Clk ) begin
        if (!rst) begin
             i_Tx_DV <= 1'b0; 
             i_Tx_Byte <= 8'b00000000;
        end else begin
            i_Tx_DV<= w_Tx_DV;
            i_Tx_Byte <= w_Tx_Byte; // Update output one cycle later
        end
    end
  // Drive UART line high when transmitter is not active
  assign o_UART_TX =  w_TX_Active ? w_TX_Serial : 1'b1;
  
  glitcher_top glitcher_top (
   .clk_in1(i_Clk),
   .rst(rst),
   .a(i_Glitcher_Byte),
   .finout(w_Tx_Byte),
   .DV_1( i_Glitcher_DV),
   .DV_3(w_Tx_DV));

 
endmodule