`timescale 1ns / 1ps

module uart_transmitter (
    input  wire       clk,
    input  wire       rst,
    input  wire       wr_en,// it is used to define the start of uart transmission and load data into buffer
    input  wire       tx_clk_en,   
    input  wire [7:0] data_in,
    output reg        tx,
    output wire       busy   // it is used to prevent overwriting data in mid transmission
);

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state;
reg [2:0] bit_index;
reg [7:0] data_buffer;

always @(posedge clk) begin
 if (rst) begin
     state <= IDLE;
     tx <= 1'b1;   
     bit_index <= 0;
     data_buffer <= 0;
  end else begin
case (state)

IDLE: begin
tx <= 1'b1;
 if (wr_en) begin
    data_buffer <= data_in;
    bit_index <= 0;
    state <= START;
  end
end

START: begin
tx <= 1'b0;     // start bit  
 if (tx_clk_en) begin
    state <= DATA;    
  end
end

DATA: begin
tx <= data_buffer[bit_index]; // lsb first
 if (tx_clk_en) begin
    if (bit_index == 3'd7) begin
       bit_index <= 0;
       state <= STOP;
    end else begin
       bit_index <= bit_index + 1'b1;
     end
   end
end

STOP: begin
tx <= 1'b1;  // stop bit
if (tx_clk_en) begin
   state <= IDLE;
   end
end

default: state <= IDLE;
endcase
end
end

assign busy = (state != IDLE);

endmodule
