module TAG_TB;

    reg [31:0] PC;
    reg [31:0] I;
    reg [31:0] RS;

    wire [31:0] TAO;

    TAG tag_tb (
        .PC(PC),
        .I(I),
        .RS(RS),
        .TAO(TAO)
    );

    initial begin
        PC = 32'd4;
        I = 32'b00010000000100000000000000000001;
        RS = 32'd8;
        #10;
        #10;
        PC = 32'd16;
        I = 32'b00001010000000000000000000000000;
        RS = 32'd7;
        #10;
        PC = 32'd12;
        I = 32'b00000000001000100001100000001001;
        RS = 32'd11;
        #10;
        PC = 32'd20;
        I = 32'b00000000001000100001100000001000;
        RS = 32'd22;
        #10;
        PC = 32'd24;
        I = 32'b00000000001000100001100000100000;
        RS = 32'd26;
        #10;
    end

    initial
        $monitor("time=%0t PC=%0d I=%b RS=%0d TAO=%0d", $time, PC, I, RS, TAO);

endmodule