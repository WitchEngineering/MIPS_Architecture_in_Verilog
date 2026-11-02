module Reg_tb;

    reg [31:0] load_value;
    reg rst;
    reg le;
    reg clk;

    wire [31:0] out;

    reg32 reg_tb (
        .clk(clk),
        .rst(rst),
        .le(le),
        .d(load_value),
        .q(out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        rst = 0;
        load_value = 32'b0;
        le = 0;
        #10;
        #10;
        #10 load_value = 32'b100;
        #10 le = 1;
        #10 le = 0;
        #10;
        #10;
        #10 rst = 1;
        #10;
        #10;
        #10 rst = 0;
        #10;
        #10; 
        #10 load_value = 32'b111;
        #10 le = 1;
        #10 le = 0;
        #10;

        #20 $finish;
    end


    initial
        $monitor("time=%0d clk=%b load_val=%0d rst=%b le=%b out=%0d", $time, clk, load_value, rst, le, out);
        
endmodule