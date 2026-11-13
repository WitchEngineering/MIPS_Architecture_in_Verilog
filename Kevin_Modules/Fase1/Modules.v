module reg32 #(parameter RESET_VAL = 32'd0)(
    input clk,
    input rst,
    input le,
    input [31:0] d,
    output reg [31:0] q
    );

    always @(posedge clk) begin
        if (rst)
            q <= RESET_VAL;
        else if (le)
            q <= d;
    end
endmodule

module mux (
    input [31:0] A0,
    input [31:0] A1,
    input S,
    output reg [31:0] O
    );
    
    always @(*) begin
        if (S)
            O = A1;
        else
            O = A0;
    end
endmodule

module sum (
    input [31:0] i,
    output reg [31:0] R
    );

    always @(*) begin
        R = i + 4;
    end
endmodule

module reg64(
    input [31:0] D0,
    input [31:0] D1,
    input clk,
    input rst,
    input le,
    input clr,
    output reg [31:0] Q0,
    output reg [31:0] Q1
    );

    always @(posedge clk) begin
        if (rst | clr) begin
            Q0 <= 32'd0;
            Q1 <= 32'd0;
        end
        else if (le) begin
            Q0 <= D0;
            Q1 <= D1;
        end
    end
endmodule 

module TAG (
    input [31:0] PC,
    input [31:0] I,
    input [31:0] RS,
    output reg [31:0] TAO
    );

    wire [31:0] nextPC = PC + 4;

    wire [5:0] opcode = I[31:26];
    wire [5:0] funct = I[5:0];
    wire [15:0] offset = I[15:0];
    wire [25:0] idx = I[25:0];

    always @(*) begin
        case (opcode) 
            6'b000100, 6'b000001, 6'b000111, 6'b000110, 6'b000101: begin
                TAO = nextPC + ({{16{offset[15]}}, offset} << 2);
            end
            6'b000010, 6'b000011: begin
                TAO = {nextPC[31:28], idx, 2'b00};
            end
            6'b000000: begin
                case(funct)
                    6'b001001, 6'b001000: begin
                        TAO = RS;
                    end
                    default: TAO = 32'd0;
                endcase
            end
            default: TAO = 32'd0;
        endcase
    end
endmodule

module PASG (
        input CLK,
        input LE,
        input RESET,
        input J,
        input CLR,
        input [31:0] INS,
        input [31:0] TAI,
        input [31:0] RS,
        output [31:0] TAO,
        output [31:0] I,
        output [31:0] PC
    );

    wire [31:0] nPC_out;
    wire [31:0] mux_out;
    wire [31:0] sum_out;
    wire [31:0] PLR_out0;

    reg32 #(.RESET_VAL(32'd4)) PASG_nPC (
        .clk(CLK),
        .rst(RESET),
        .le(LE),
        .d(sum_out),
        .q(nPC_out)
    );

    sum PASG_sum (
        .i(mux_out),
        .R(sum_out)
    );

    mux PASG_mux (
        .A0(nPC_out),
        .A1(TAI),
        .S(J),
        .O(mux_out)
    );

    reg32 PASG_PC (
        .clk(CLK),
        .rst(RESET),
        .le(LE),
        .d(mux_out),
        .q(PC)
    );

    reg64 PASG_PLR (
        .D0(PC),
        .D1(INS),
        .clk(CLK),
        .rst(RESET),
        .le(LE),
        .clr(CLR),
        .Q0(PLR_out0),
        .Q1(I)
    );

    TAG PASG_TAG (
        .PC(PLR_out0),
        .I(I),
        .RS(RS),
        .TAO(TAO)
    );

endmodule