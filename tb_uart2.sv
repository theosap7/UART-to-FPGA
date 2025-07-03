`timescale 1ns / 1ps

module tb_uart_loopback_alt;

  // Parameters
  parameter int CLK_PERIOD_NS   = 10;      // 100 MHz clock = 10ns period
  parameter int CLKS_PER_BIT    = 868;     // 100 MHz / 115200
  parameter int BAUD_PERIOD_NS  = CLKS_PER_BIT * CLK_PERIOD_NS;

  // DUT signals
  logic clk;
  logic rst;
  logic uart_rx;
  wire  uart_tx;

  // DUT instance
  UART_Loopback_Top dut (
    .i_Clk     (clk),
    .rst       (rst),
    .i_UART_RX (uart_rx),
    .o_UART_TX (uart_tx)
  );

  // Clock generation: 100 MHz
  always #(CLK_PERIOD_NS/2) clk = ~clk;

  // UART byte transmission task (1 start, 8 data, 1 stop bit)
  task automatic uart_send_byte(input byte b);
    begin
      // Start bit
      uart_rx = 1'b0;
      #(BAUD_PERIOD_NS);

      // Data bits (LSB first)
      for (int i = 0; i < 8; i++) begin
        uart_rx = b[i];
        #(BAUD_PERIOD_NS);
      end

      // Stop bit
      uart_rx = 1'b1;
      #(BAUD_PERIOD_NS);
    end
  endtask

  initial begin
    $display("[%0t] Starting testbench...", $time);
    clk = 0;
    rst = 0;
    uart_rx = 1'b1;  // Idle line

    // Apply reset for 100 ns
    #(10 * CLK_PERIOD_NS);
    rst = 1;
    #(50 * CLK_PERIOD_NS);
    rst = 0;
    #(20 * CLK_PERIOD_NS);
    rst = 1;  // Final release

    fork
      begin : tx_thread
        // Send 3 bytes
        #(20 * CLK_PERIOD_NS);
        uart_send_byte(8'hC3);  // 11000011
        

        uart_send_byte(8'h5A);  // 01011010
        

        uart_send_byte(8'h99);  // 10011001
        
        uart_send_byte(8'hB3);  // 11000011
         //  #(20 * CLK_PERIOD_NS);
        //uart_send_byte(8'h11);  // 11000011
        

       // uart_send_byte(8'h9A);  // 01011010
        

        //uart_send_byte(8'h77);  // 10011001
        
         //uart_send_byte(8'h28);  // 11000011
      end

      begin : monitor_timeout
        // Timeout watcher for end of test
        #(1000 * BAUD_PERIOD_NS);
        $display("[%0t] Test complete. Inspect UART_TX waveform.", $time);
        $finish;
      end
    join
  end

endmodule
