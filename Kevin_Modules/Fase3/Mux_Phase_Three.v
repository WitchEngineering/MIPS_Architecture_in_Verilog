module mux_third_phase (
    input [20:0] A0,
    input [20:0] A1,
    input S,
    output reg [20:0] O
    );
    
    always @(*) begin
        if (S)
            O = A1;
        else
            O = A0;
    end
endmodule