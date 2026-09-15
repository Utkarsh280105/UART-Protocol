`timescale 1ns / 1ps 
module uart_protocol(
    input clk,
    input rst,

    input uart_rx,
    output uart_tx,

    input wr_en,
    input rdy_clr,
    input [7:0] data_in,

    output busy,
    output rdy,
    output [7:0] data_out
);
        
wire rx_clk_en;
wire tx_clk_en;




baud_rate_generator brg(.clk(clk ), .rst(rst), .rx_en(rx_clk_en),.tx_en(tx_clk_en));

uart_transmitter ut(.clk(clk), .rst(rst), .wr_en(wr_en), .tx_clk_en(tx_clk_en), .data_in(data_in),
                   .busy(busy), .tx(uart_tx));
                   
uart_receiver ur(.clk(clk), .rst(rst), .rdy_clr(rdy_clr), .rx(uart_rx), .rx_clk_en(rx_clk_en),
                 .rdy(rdy ), .data_out(data_out));                  
        
endmodule
