module glitcher_fifo_to_uart_tx (
  input  logic       clk,
  input  logic       rst,

  input  logic        glitcher_dv,
  input  logic [7:0]  glitcher_byte,
  input logic         w_Tx_Done,
  input  logic        tx_busy,
  output logic        tx_dv,
  output logic [7:0]  tx_byte
);
   logic count_sent=0;
   logic [7:0] byte_in;
  logic [7:0] fifo [0:3];
  logic [1:0] wr_ptr, rd_ptr;
  logic [2:0] count=0;
    logic can_send;
  typedef enum logic [1:0] {IDLE, SEND, WRITE} state_t;
  state_t state;
//write to fifo


  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      rd_ptr  <= 0;
      state   <= IDLE;
      tx_dv   <= 0;
      tx_byte <= 8'd0;
       wr_ptr <= 0;
      
      can_send<=0;
    end else begin
      tx_dv <= 1'b0;  // Default: no send
       byte_in<=glitcher_byte;
      case (state)
        IDLE: begin
         if (glitcher_dv && count < 4) begin
         state<=WRITE; 
         end else if (!tx_busy && tx_dv==0 && can_send==1) begin
               state   <= SEND;
          end
        end

        SEND: begin
          
            if(count>0 )begin            
              tx_byte <= fifo[rd_ptr];
              rd_ptr <= rd_ptr + 1;
              tx_dv   <= 1'b1;    // Pulse again
              count  <= count- 1;
              state   <= IDLE;
            end else begin
              can_send=0;
              state <= IDLE;
            end
          end
       WRITE: begin      
       
       if (count<4) begin
          fifo[wr_ptr] <= byte_in;
          wr_ptr <= wr_ptr + 1;
          count  <= count + 1;
          end else begin
          can_send=1;
          state <=IDLE;
          end
       
      end
     
       
    default
    state<=IDLE;
          endcase
    end
  end

endmodule
