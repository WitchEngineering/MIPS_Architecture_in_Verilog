module pipe_reg_clear #(parameter W = 1)(
    input clk,
    input CLR,
    input LE,
    input rst,
    input [W-1:0] d,
    output reg [W-1:0] q
    );

    always @(posedge clk)
        if (rst | CLR) q <= {W{1'b0}};
        else if (LE)q <= d;
endmodule