`timescale 1ns / 1ps

module tb_uart_loopback;

  // Parameters
  parameter int CLK_PERIOD_NS    = 10;         // 25 MHz → 40 ns period
  parameter int CLKS_PER_BIT     = 434;        // 25 MHz / 115200 baud
  parameter int BAUD_BIT_PERIOD  = CLK_PERIOD_NS * CLKS_PER_BIT;

  // DUT signals
  logic clk;
  logic rst;
  logic uart_rx;
  wire  uart_tx;

  // Instantiate DUT
  UART_Loopback_Top dut (
    .i_Clk      (clk),
    .rst      (rst),       // ← ADD this to match DUT
    .i_UART_RX  (uart_rx),
    .o_UART_TX  (uart_tx)
  );

  // Clock generation
  always #(CLK_PERIOD_NS / 2) clk = ~clk;

  // UART Byte transmitter task (LSB first, 1 start bit, 1 stop bit)
  task automatic send_uart_byte(input byte tx_byte);
    int i;
    begin
      // Start bit
      uart_rx = 1'b0;
      #(BAUD_BIT_PERIOD);

      // Data bits (LSB first)
      for (i = 0; i < 8; i++) begin
        uart_rx = tx_byte[i];
        #(BAUD_BIT_PERIOD);
      end

      // Stop bit
      uart_rx = 1'b1;
      #(BAUD_BIT_PERIOD);
    end
  endtask

  // Test process
  initial begin
    $display("[%0t] Starting UART Loopback Test...", $time);

    // Initialize signals
    clk = 0;
    rst = 0;
    uart_rx = 1'b1;  // Idle state

    // Apply reset for some cycles
    #(5 * CLK_PERIOD_NS);
    rst = 1;

    // Wait a bit more after reset
    #(5 * CLK_PERIOD_NS);

    // Send 3 bytes over UART
    send_uart_byte(8'hAA);  // 10101010
    #(10 * BAUD_BIT_PERIOD);

    send_uart_byte(8'hFF);  // 11111111
    #(10 * BAUD_BIT_PERIOD);

    send_uart_byte(8'hAA);  // 10101010
    #(10 * BAUD_BIT_PERIOD);

    $display("[%0t] Finished sending 3 bytes. Check waveform for loopback.", $time);
    #(20 * BAUD_BIT_PERIOD);

    $finish;
  end

endmodule
