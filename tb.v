//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//                               Name: Biplab Das S                                     //
//                                  BIST MODULE                                         //
//                   https://www.github.com/crazyhrzero8/BIST/                          //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module tb;

    localparam c2dr = 3;
    localparam CLK_PERIOD = 10; 
    localparam DATA_WIDTH = 32;
    reg clk;
    reg rst_n;
    reg enable;
    reg capture_start;
    reg pattern_sel;
    wire [DATA_WIDTH-1:0] data_out;
    wire valid_out;
    wire sync;

    bist #(
        .DATA_WIDTH(DATA_WIDTH),
        .c2dr(c2dr)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .capture_start(capture_start),
        .pattern_sel(pattern_sel),
        .data_out(data_out),
        .valid_out(valid_out),
        .sync(sync)
    );
    initial clk = 0;
    always #((CLK_PERIOD / 2)) clk = ~clk;

    initial begin
        rst_n = 0;
        #20; 
        rst_n = 1;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

    initial begin
        enable = 0;
        pattern_sel = 0;
        capture_start=1;
        #60;
        enable=1;
        #200;
        enable=0;
        pattern_sel=1;
        #20;
        enable =1;
        #100;
        enable=0;
        #10;
        enable=1;
        #50;
        pattern_sel=0;
        #100;
        enable=0;
        #10;
        enable=1;
        #100;
        enable=0;
        #20;
        enable=1;
        #100;
        enable=0;
        pattern_sel=1;
        #20;
        enable=1;
        #70;
        enable=0;
        #10;
        enable=1;
        pattern_sel=0;
        #80;
        enable=0;
        pattern_sel=0;
        #50;
        enable=1;
        pattern_sel=0;
        #20;
        enable=1;
        #70;
        enable=0;
        #10;
        enable=1;
        pattern_sel=1;
        #80;
        enable=0;
        pattern_sel=0;
        #45;
        enable=1;
        pattern_sel=0;
        #15;
        enable=1;
        #65;
        enable=0;
        #15;
        enable=1;
        pattern_sel=1;
        #10;
        enable=0;
        #45;
        enable=1;
        pattern_sel=0;
        #50;
        $stop(); 
    end


endmodule