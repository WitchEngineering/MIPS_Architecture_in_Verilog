module Register32 (output reg [31:0] Q, input [31:0] D, input LE, input Clk);

    always @ (posedge Clk)
        if (LE) Q <= D;

endmodule



module BinaryDecoder5x32 (output reg [31:0] O, input [4:0] D, input E);

    always @ (D, E)
        if (E) O = 32'h00000001 << D;  
        else   O = 32'h00000000;        

endmodule



module Mux32x1 (output reg [31:0] Y,
                input      [4:0]  S,
                input      [31:0] I0,  I1,  I2,  I3,  I4,  I5,  I6,  I7,
                input      [31:0] I8,  I9,  I10, I11, I12, I13, I14, I15,
                input      [31:0] I16, I17, I18, I19, I20, I21, I22, I23,
                input      [31:0] I24, I25, I26, I27, I28, I29, I30, I31);

    always @ (*)
        case (S)
            5'd0  : Y = I0;    5'd1  : Y = I1;    5'd2  : Y = I2;    5'd3  : Y = I3;
            5'd4  : Y = I4;    5'd5  : Y = I5;    5'd6  : Y = I6;    5'd7  : Y = I7;
            5'd8  : Y = I8;    5'd9  : Y = I9;    5'd10 : Y = I10;   5'd11 : Y = I11;
            5'd12 : Y = I12;   5'd13 : Y = I13;   5'd14 : Y = I14;   5'd15 : Y = I15;
            5'd16 : Y = I16;   5'd17 : Y = I17;   5'd18 : Y = I18;   5'd19 : Y = I19;
            5'd20 : Y = I20;   5'd21 : Y = I21;   5'd22 : Y = I22;   5'd23 : Y = I23;
            5'd24 : Y = I24;   5'd25 : Y = I25;   5'd26 : Y = I26;   5'd27 : Y = I27;
            5'd28 : Y = I28;   5'd29 : Y = I29;   5'd30 : Y = I30;   5'd31 : Y = I31;
        endcase

endmodule



module RegisterFile (output [31:0] PA, PB,
                     input  [31:0] PW,
                     input  [4:0]  RA, RB, RW,
                     input         LE, CLK);


    wire [31:0] Q0,  Q1,  Q2,  Q3,  Q4,  Q5,  Q6,  Q7;
    wire [31:0] Q8,  Q9,  Q10, Q11, Q12, Q13, Q14, Q15;
    wire [31:0] Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23;
    wire [31:0] Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31;

    wire [31:0] E;

    BinaryDecoder5x32 DEC (E, RW, LE);

    
    Register32 R0  (Q0,  PW, E[0],  CLK);
    Register32 R1  (Q1,  PW, E[1],  CLK);
    Register32 R2  (Q2,  PW, E[2],  CLK);
    Register32 R3  (Q3,  PW, E[3],  CLK);
    Register32 R4  (Q4,  PW, E[4],  CLK);
    Register32 R5  (Q5,  PW, E[5],  CLK);
    Register32 R6  (Q6,  PW, E[6],  CLK);
    Register32 R7  (Q7,  PW, E[7],  CLK);
    Register32 R8  (Q8,  PW, E[8],  CLK);
    Register32 R9  (Q9,  PW, E[9],  CLK);
    Register32 R10 (Q10, PW, E[10], CLK);
    Register32 R11 (Q11, PW, E[11], CLK);
    Register32 R12 (Q12, PW, E[12], CLK);
    Register32 R13 (Q13, PW, E[13], CLK);
    Register32 R14 (Q14, PW, E[14], CLK);
    Register32 R15 (Q15, PW, E[15], CLK);
    Register32 R16 (Q16, PW, E[16], CLK);
    Register32 R17 (Q17, PW, E[17], CLK);
    Register32 R18 (Q18, PW, E[18], CLK);
    Register32 R19 (Q19, PW, E[19], CLK);
    Register32 R20 (Q20, PW, E[20], CLK);
    Register32 R21 (Q21, PW, E[21], CLK);
    Register32 R22 (Q22, PW, E[22], CLK);
    Register32 R23 (Q23, PW, E[23], CLK);
    Register32 R24 (Q24, PW, E[24], CLK);
    Register32 R25 (Q25, PW, E[25], CLK);
    Register32 R26 (Q26, PW, E[26], CLK);
    Register32 R27 (Q27, PW, E[27], CLK);
    Register32 R28 (Q28, PW, E[28], CLK);
    Register32 R29 (Q29, PW, E[29], CLK);
    Register32 R30 (Q30, PW, E[30], CLK);
    Register32 R31 (Q31, PW, E[31], CLK);

   
    Mux32x1 MUXA (PA, RA,
                  Q0,  Q1,  Q2,  Q3,  Q4,  Q5,  Q6,  Q7,
                  Q8,  Q9,  Q10, Q11, Q12, Q13, Q14, Q15,
                  Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23,
                  Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31);

    
    Mux32x1 MUXB (PB, RB,
                  Q0,  Q1,  Q2,  Q3,  Q4,  Q5,  Q6,  Q7,
                  Q8,  Q9,  Q10, Q11, Q12, Q13, Q14, Q15,
                  Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23,
                  Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31);

endmodule
