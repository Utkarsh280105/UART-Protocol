`timescale 1ns / 1ps
module uart_receiver (
    input  wire clk,
    input  wire rst,
    input  wire rx_clk_en,   
    input  wire rx,         
    input  wire rdy_clr,

    output reg  [7:0] data_out,
    output reg        rdy
);

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state;
reg [3:0] sample_cnt;   
reg [2:0] bit_index;   
reg [7:0] data_buf;

always @(posedge clk) begin
 if (rst) begin
   state <= IDLE;
   sample_cnt  <= 0;
   bit_index   <= 0;
   data_buf    <= 0;
   data_out    <= 0;
   rdy         <= 0;
 end else begin

  if (rdy_clr)
    rdy <= 0;

case (state)

IDLE: begin
sample_cnt <= 0;
bit_index  <= 0;
  if (rx == 1'b0) begin
     state <= START;   
  end
end

START: begin
  if (rx_clk_en) begin
    if (sample_cnt == 4'd8) begin
      if (rx == 1'b0) begin
       sample_cnt <= 0;
       bit_index  <= 0;
       state <= DATA;
     end else begin
       state <= IDLE; // false start
     end
    end else begin
      sample_cnt <= sample_cnt + 1'b1;
    end
  end
end

DATA: begin
 if (rx_clk_en) begin
   if (sample_cnt == 4'd8) begin
     data_buf[bit_index] <= rx; 
    end
 if (sample_cnt == 4'd15) begin
    sample_cnt <= 0;
    if (bit_index == 3'd7)
      state <= STOP;
    else
      bit_index <= bit_index + 1'b1;
    end else begin
      sample_cnt <= sample_cnt + 1'b1;
      end
   end
end

STOP: begin
 if (rx_clk_en) begin
   if (sample_cnt == 4'd15) begin
     if (rx == 1'b1) begin
       data_out <= data_buf;
       rdy <= 1'b1;
     end
      sample_cnt <= 0;
      state <= IDLE;
   end else begin
      sample_cnt <= sample_cnt + 1'b1;
      end
    end
 end

default: state <= IDLE;
endcase
end
end

endmodule
