`timescale 1ns / 1ps

module uart_tb();

    // Inputs 
    reg clk;
    reg rst;
    reg wr_en;
    reg rdy_clr;
    reg [7:0] data_in;

    // Outputs
    wire busy;
    wire rdy;
    wire [7:0] data_out;

    // Instantiate the Top Module (uart_protocol)
    uart_protocol uut (
        .clk(clk), 
        .rst(rst), 
        .wr_en(wr_en), 
        .rdy_clr(rdy_clr), 
        .data_in(data_in), 
        .busy(busy), 
        .rdy(rdy), 
        .data_out(data_out)
    );

    // Clock generation (50MHz -> 20ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        wr_en = 0;
        rdy_clr = 0;
        data_in = 8'h0;

        // Wait for Global Reset
        #100;
        rst = 0;
        #50;

        // --- Test Case 1: Send 0xAB ---
        wait(!busy);           // Ensure TX is not busy
        data_in = 8'hAB;       // Data to send: 10101011
        wr_en = 1;             // Pulse write enable
        #20;
        wr_en = 0;
        
        $display("Status: Started Transmission of 0x%h", data_in);

        // Wait for Receiver to be Ready
        wait(rdy);
        $display("Status: Data Received: 0x%h", data_out);

        if (data_out == 8'hAB)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");

        // Clear Ready Flag
        #50;
        rdy_clr = 1;
        #20;
        rdy_clr = 0;

        #1000;
        $finish;
    end
      
endmodule