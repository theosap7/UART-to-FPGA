module UART_Loopback_Top (
  input  logic i_Clk,       // Main Clock
  input  logic i_UART_RX,   // UART RX Data
  output logic o_UART_TX,   // UART TX Data
  input  logic rst
); 

  wire        w_TX_Active, w_TX_Serial;
  wire [7:0]  w_RX_Byte;
  wire        w_RX_DV;
      wire [7:0] i_Tx_Byte;  
      wire i_Tx_DV;
      wire w_Tx_Done;
  // UART Receiver
  uart_rx #(.CLKS_PER_BIT(868)) UART_RX_Inst (
    .i_Clock(i_Clk),
    .i_Rx_Serial(i_UART_RX),
    .o_Rx_DV(w_RX_DV),
    .o_Rx_Byte(w_RX_Byte)
  );

  // UART Transmitter
  uart_tx #(.CLKS_PER_BIT(868)) UART_TX_Inst (
    .i_Clock(i_Clk),
    .i_Tx_DV(i_Tx_DV),
    .i_Tx_Byte(i_Tx_Byte),
    .o_Tx_Active(w_TX_Active),
    .o_Tx_Serial(w_TX_Serial),
    .o_Tx_Done(w_Tx_Done)
  );

  // Drive UART TX line
  assign o_UART_TX = w_TX_Active ? w_TX_Serial : 1'b1;

  // === FIFO: RX to Glitcher ===
  logic [7:0] fifo_to_glitcher_byte;
  logic       fifo_to_glitcher_dv;

  rx_fifo_to_glitcher u_rx_fifo (
    .clk(i_Clk),
    .rst(rst),
    .rx_dv(w_RX_DV),
    .rx_byte(w_RX_Byte),
    .glitcher_dv(fifo_to_glitcher_dv),
    .glitcher_byte(fifo_to_glitcher_byte)
  );

  // === Glitcher ===
  wire [7:0] w_Tx_Byte;
  wire       w_Tx_DV;

  glitcher_top glitcher_top (
    .clk_in1(i_Clk),
    .rst(rst),
    .a(fifo_to_glitcher_byte),
    .finout(w_Tx_Byte),
    .DV_1(fifo_to_glitcher_dv),
    .DV_3(w_Tx_DV)
  );

  // === FIFO: Glitcher to UART TX ===
  logic [7:0] glitcher_to_tx_byte;
  logic       glitcher_to_tx_dv;

  glitcher_fifo_to_uart_tx u_tx_fifo (
    .clk(i_Clk),
    .rst(rst),
    .glitcher_dv(w_Tx_DV),
    .glitcher_byte(w_Tx_Byte),
    .tx_busy(w_TX_Active),
    .w_Tx_Done(w_Tx_Done),
    .tx_dv(glitcher_to_tx_dv),
    .tx_byte(glitcher_to_tx_byte)
  );

  assign i_Tx_DV   = glitcher_to_tx_dv;
  assign i_Tx_Byte = glitcher_to_tx_byte;

endmodule
