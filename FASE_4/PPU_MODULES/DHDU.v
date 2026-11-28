module DHDU (
    output reg [1:0] A_S,
    output reg [1:0] B_S,
    output reg NOP,
    output reg LE,

    input [4:0] RA,
    input [4:0] RB,
    input [1:0] SR,

    input EX_L,
    input [4:0] EX_RD,
    input [4:0] MEM_RD,
    input [4:0] WB_RD,
    input EX_RF_LE,
    input MEM_RF_LE,
    input WB_RF_LE
);

    wire SRA = SR[1];
    wire SRB = SR[0];
    wire RA_nz = (RA != 5'd0);
    wire RB_nz = (RB != 5'd0);

    always @ (*) begin

        // Load-use:
        if (EX_L & ((SRA & RA_nz & (RA == EX_RD)) | (SRB & RB_nz & (RB == EX_RD)))) begin
            LE  = 1'b0;
            NOP = 1'b1;
            A_S = 2'b00;
            B_S = 2'b00;
        end

        else begin
            LE  = 1'b1;
            NOP = 1'b0;

            if (SRA) begin
                if      (EX_RF_LE & RA_nz & (RA == EX_RD))  A_S = 2'b01;
                else if (MEM_RF_LE & RA_nz & (RA == MEM_RD)) A_S = 2'b10;
                else if (WB_RF_LE & RA_nz & (RA == WB_RD))  A_S = 2'b11;
                else A_S = 2'b00;
            end
            else A_S = 2'b00;

            if (SRB) begin
                if      (EX_RF_LE & RB_nz & (RB == EX_RD))  B_S = 2'b01;
                else if (MEM_RF_LE & RB_nz & (RB == MEM_RD)) B_S = 2'b10;
                else if (WB_RF_LE & RB_nz & (RB == WB_RD))  B_S = 2'b11;
                else B_S = 2'b00;
            end
            else B_S = 2'b00;
        end
    end

endmodule
