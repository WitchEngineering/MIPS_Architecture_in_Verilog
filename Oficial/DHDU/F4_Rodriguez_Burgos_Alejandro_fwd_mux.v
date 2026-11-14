module mux4x1 #(parameter N = 32)
    (output reg [N-1:0] O,
     input [N-1:0] I0, I1, I2, I3,
     input [1:0] S);

    always @ (*)
        case (S)
            2'b00: O = I0;
            2'b01: O = I1;
            2'b10: O = I2;
            2'b11: O = I3;
        endcase

endmodule
