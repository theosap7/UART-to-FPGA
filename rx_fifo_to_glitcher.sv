module rx_fifo_to_glitcher (
  input  logic       clk,
  input  logic       rst,

  // UART RX input
  input  logic        rx_dv,
  input  logic [7:0]  rx_byte,

  // Glitcher output
  output logic        glitcher_dv,
  output logic [7:0]  glitcher_byte
);

  typedef enum logic [1:0] {
    IDLE,
    WRITE,
    BURST
  } state_t;

  state_t state;
  logic [2:0] write_ptr =0;
  logic [2:0] read_ptr=0;
  logic [7:0] fifo [0:3];

  // State machine
  always_ff @(posedge clk or negedge rst) begin
    if (!rst)
      state <= IDLE;
    else begin
         
         glitcher_dv <= 0;
         glitcher_byte <= 8'd0;
      case (state)
        IDLE:  
         if (rx_dv)        begin
         state <= WRITE;
      
       end
        WRITE:
          begin
            fifo[write_ptr] <= rx_byte;
             write_ptr <= write_ptr + 1;
                 if (write_ptr == 2'b11)begin
                
                 state <= BURST;
                 
                 end else begin
                 state<=IDLE;
                 end
           end
       
        BURST: 
        begin
         write_ptr<=1'b0;
            if (read_ptr >3) begin
                state <= IDLE;
                read_ptr <= 1'b0;
                 glitcher_dv <= 0;
                   glitcher_byte <= 8'd0;
            end else begin
                glitcher_dv <= 1;
                glitcher_byte <= fifo[read_ptr];
                read_ptr <= read_ptr + 1;
            end
            end
            
        default
                state<=IDLE;
      endcase
   
    end
  end


     
    
 




endmodule
