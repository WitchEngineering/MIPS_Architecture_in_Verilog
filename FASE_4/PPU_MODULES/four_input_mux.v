module mux4_n #(parameter W = 32)(
    input  [W-1:0] A0, A1, A2, A3,
    input  [1:0]   S,
    output reg [W-1:0] O
);
    always @(*) begin
        case (S)
            2'b00:   O = A0;
            2'b01:   O = A1;
            2'b10:   O = A2;
            2'b11:   O = A3;
            default: O = {W{1'bx}};
        endcase
    end
endmodule