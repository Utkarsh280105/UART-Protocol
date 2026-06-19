`timescale 1ns / 1ps

module baud_rate_generator #(
    parameter integer clk_freq     = 100_000_000,
   parameter integer baud = 115200,
    parameter integer oversampling = 16
)(
    input  wire clk,
    input  wire rst,
    output reg  tx_en,
    output reg  rx_en
);

localparam integer tx_div = clk_freq / baud;
localparam integer rx_div = tx_div / oversampling;

localparam integer tx_div_count = (tx_div > 1) ? $clog2(tx_div) : 1;
localparam integer rx_div_count = (rx_div > 1) ? $clog2(rx_div) : 1;

reg [tx_div_count-1:0] tx_counter;
reg [rx_div_count-1:0] rx_counter;

always @(posedge clk) begin
if (rst) begin
tx_counter <= 0;
    tx_en      <= 0;
end else begin
    tx_en <= 0;
    if (tx_counter == tx_div-1) begin
        tx_counter <= 0;
        tx_en      <= 1;
    end else begin
        tx_counter <= tx_counter + 1'b1;
    end
end
end

always @(posedge clk) begin
    if (rst) begin
        rx_counter <= 0;
        rx_en      <= 0;
    end else begin
        rx_en <= 0;
        if (rx_counter == rx_div-1) begin
            rx_counter <= 0;
            rx_en      <= 1;
        end else begin
            rx_counter <= rx_counter + 1'b1;
        end
    end
end

endmodule
