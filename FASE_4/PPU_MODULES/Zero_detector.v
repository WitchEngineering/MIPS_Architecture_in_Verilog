module zero_detector (output Z, input [31:0] B);
    assign Z = (B == 32'b0);
endmodule