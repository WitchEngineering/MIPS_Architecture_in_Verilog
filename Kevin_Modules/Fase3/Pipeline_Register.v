module pipe_reg #(parameter W = 1)(
    input clk,
    input rst,
    input [W-1:0] d,
    output reg [W-1:0] q
    );

    always @(posedge clk)
        if (rst) q <= {W{1'b0}};
        else q <= d;
endmodule