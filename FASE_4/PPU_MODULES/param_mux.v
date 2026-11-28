module mux_n #(parameter W = 32)(input [W-1:0] A0, A1, input S, output [W-1:0] O);
    assign O = S ? A1 : A0;
endmodule