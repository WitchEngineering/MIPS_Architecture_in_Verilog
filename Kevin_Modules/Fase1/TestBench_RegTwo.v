module Reg2_tb;

    reg [31:0] load_val;
    reg [31:0] load_val2;
    reg rst;
    reg clr;
    reg le;
    reg clk;

    wire [31:0] out1;
    wire [31:0] out2;

    reg64 reg_tb_tb (
        .D0(load_val),
        .D1(load_val2),
        .clk(clk),
        .rst(rst),
        .le(le),
        .clr(clr),
        .Q0(out1),
        .Q1(out2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        rst = 0;
        clr = 0;
        le = 0;
        load_val = 32'b0;
        load_val2 = 32'b0;
        #10;
        #10;
        #10;
        load_val = 32'b00000000000000000000000000000000;
        load_val2 = 32'b11111111111111111111111111111111;
        #10;
        #10 ;
        le = 1;
        #10;
        le = 0;
        #10;
        rst = 1;
        #10;
        rst = 0;
        #10;
        load_val = 32'b11111111111111111111111111111111;
        load_val2 = 32'b00000000000000000000000000000000;
        #10;
        le = 1;
        #10;
        le = 0;
        #10;
        clr = 1;
        #10;
        clr = 0;
        #10;
        #20 $finish;
    end

    initial
        $monitor("time=%0d clk=%b load_val=%0d load_val2=%0d, rst=%b clr=%b le=%b  out1=%0d out2=%0d", $time, clk, load_val, load_val2, rst, clr, le, out1, out2);

endmodule