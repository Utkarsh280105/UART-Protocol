`timescale 1ns/1ps

module test_protocol;

reg clk;
reg rst;
reg wr_en;
reg rdy_clr;
reg [7:0] data_in;

wire busy;
wire rdy;
wire [7:0] data_out;

wire uart_tx;

uart_protocol dut(
    .clk(clk),
    .rst(rst),

    .uart_rx(uart_tx),
    .uart_tx(uart_tx),

    .wr_en(wr_en),
    .rdy_clr(rdy_clr),
    .data_in(data_in),

    .busy(busy),
    .rdy(rdy),
    .data_out(data_out)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

task send_byte;
input [7:0] tx_data;
begin

    wait(!busy);

    @(posedge clk);
    data_in = tx_data;
    wr_en = 1'b1;

    @(posedge clk);
    wr_en = 1'b0;

    wait(rdy);

    @(posedge clk);
    rdy_clr = 1'b1;

    @(posedge clk);
    rdy_clr = 1'b0;

end
endtask

initial begin

    rst = 1'b1;
    wr_en = 1'b0;
    rdy_clr = 1'b0;
    data_in = 8'h00;

    #100;
    rst = 1'b0;

    #100;

    send_byte(8'hA5);  //165
    send_byte(8'h3C);  //60
    send_byte(8'hFF);  //255
    send_byte(8'hD1);  //209
    send_byte(8'h69);  //105

    #1000;
    $finish;

end

endmodule