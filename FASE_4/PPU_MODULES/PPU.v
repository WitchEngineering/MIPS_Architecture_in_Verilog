module PPU (
    input CLK, 
    input RESET
    );

    //===========================================================================================================================//
    //================================================== SIGNALS ================================================================//
    //===========================================================================================================================//

    //==================================== IF STAGE SIGNALS ====================================//

    wire [31:0] IF_PC_IN;
    wire [31:0] IF_PC_OU;
    wire [31:0] IF_I;
    wire [31:0] IF_nPC_IN;
    wire [31:0] IF_nPC_OU;
    wire [31:0] IF_EX_J_MUX_OU;
    wire J;

    //==================================== ID STAGE SIGNALS ====================================//

    wire [31:0] ID_TAG_OU;
    wire [31:0] ID_PC_TAG;
    wire [31:0] ID_I;
    wire [31:0] ID_MUX_PA_OU;
    wire [31:0] ID_MUX_PB_OU;
    wire [31:0] ID_PC_EIGHT;
    wire [31:0] ID_PA;
    wire [31:0] ID_PB;
    wire [4:0] ID_RD;
    wire [1:0] RD_S;
    wire B;
    wire [1:0] SOH_OP;
    wire[3:0] ALU_OP;
    wire [1:0] Size;
    wire L;
    wire RF_LE;
    wire FOH_OP;
    wire [2:0] COND_OP;
    wire SE;
    wire RW;
    wire E;
    wire LINK;
    wire [1:0] MV;
    wire [1:0] ID_SR;
    wire ID_J;
    wire [20:0] ID_CONTROL_SIGNALS;

    //==================================== EX STAGE SIGNALS ====================================//

    wire LE;
    wire EX_J;
    wire [31:0] EX_TAG_OU;
    wire [31:0] EX_MUX_ALU;
    wire [1:0] A_S;
    wire [1:0] B_S;
    wire NOP;
    wire [31:0] EX_PC_EIGHT;
    wire [31:0] EX_PA;
    wire [31:0] EX_PB;
    wire [15:0] EX_IMM;
    wire [4:0] EX_SA;
    wire [20:0] EX_CONTROL_SIGNALS;
    wire [4:0] EX_RD;
    wire [31:0] FOH_OU;
    wire [31:0] SOH_OU;
    wire Zero;
    wire LE_ALU;
    wire EQ_ALU;
    wire GT_ALU;
    wire [31:0] EX_ALU_OU;
    wire EX_RF_LE_OU;

    //==================================== MEM STAGE SIGNALS ====================================//

    wire [31:0] MEM_PD;
    wire [31:0] MEM_PB;
    wire [31:0] MEM_ALU_OU;
    wire [4:0] MEM_RD;
    wire [6:0] MEM_CONTROL_SIGNALS;
    wire [31:0] MEM_DO;
    
    //==================================== WB STAGE SIGNALS ====================================//

    wire WB_RF_LE_OU;
    wire [31:0] WB_PD;
    wire [4:0] WB_RD;

    //===========================================================================================================================//
    //================================================== MODULES ================================================================//
    //===========================================================================================================================//

    //==================================== IF MODULES ====================================//

    reg32 PC_REG (
        .clk(CLK),
        .rst(RESET),
        .le(LE),
        .d(IF_PC_IN),
        .q(IF_PC_OU)
    );

    instruction_memory inst_memory (
        .A(IF_PC_OU[8:0]),
        .I(IF_I)
    );

    assign IF_nPC_IN = 4 + IF_PC_IN;

    reg32 #(.RESET_VAL(32'd4)) nPC_REG (
        .clk(CLK),
        .rst(RESET),
        .le(LE),
        .d(IF_nPC_IN),
        .q(IF_nPC_OU)
    );

    assign J = EX_J | ID_J;

    mux_n IF_J_MUX (
        .A0(IF_nPC_OU),
        .A1(IF_EX_J_MUX_OU),
        .S(J),
        .O(IF_PC_IN)
    );

    mux_n IF_EX_J_MUX (
        .A0(ID_TAG_OU),
        .A1(EX_TAG_OU),
        .S(EX_J),
        .O(IF_EX_J_MUX_OU)
    );

    pipe_reg_clear #(64) IF_ID_REGISTER (
        .clk(CLK),
        .CLR(EX_J),
        .LE(LE),
        .rst(RESET),
        .d({IF_PC_OU, IF_I}),
        .q({ID_PC_TAG, ID_I})
    );

    //==================================== ID MODULES ====================================//

    TAG TAG_ID (
        .PC(ID_PC_TAG),
        .I(ID_I),
        .RS(ID_MUX_PA_OU),
        .TAO(ID_TAG_OU)
    );

    assign ID_PC_EIGHT = ID_PC_TAG + 8;

    RegisterFile REG_FILE (
        .PA(ID_PA),
        .PB(ID_PB),
        .PW(WB_PD),
        .RA(ID_I[25:21]),
        .RB(ID_I[20:16]),
        .RW(WB_RD),
        .LE(WB_RF_LE_OU),
        .CLK(CLK)
    );

    mux4_n #(32) FWD_A (
        .A0(ID_PA),
        .A1(EX_MUX_ALU),
        .A2(MEM_PD),
        .A3(WB_PD),
        .S(A_S),
        .O(ID_MUX_PA_OU)
    );

    mux4_n #(32) FWD_B (
        .A0(ID_PB),
        .A1(EX_MUX_ALU),
        .A2(MEM_PD),
        .A3(WB_PD),
        .S(B_S),
        .O(ID_MUX_PB_OU)
    );

    mux4_n #(5) RD_MUX (
        .A0(ID_I[15:11]),
        .A1(ID_I[20:16]),
        .A2(5'b11111),
        .A3(5'b00000),
        .S(RD_S),
        .O(ID_RD)
    );

    control_unit control_unit_PPU (
        .I(ID_I),
        .RD_S(RD_S),
        .B(B),
        .SOH_OP(SOH_OP),
        .ALU_OP(ALU_OP),
        .Size(Size),
        .L(L),
        .RF_LE(RF_LE),
        .FOH_OP(FOH_OP),
        .COND_OP(COND_OP),
        .SE(SE),
        .RW(RW),
        .E(E),
        .LINK(LINK),
        .MV(MV),
        .ID_SR(ID_SR),
        .ID_J(ID_J),
        .INVALID(),
        .NAME()
    );

    mux_n #(21) CU_MUX (
        .A0({B, SOH_OP, ALU_OP, Size, L, RF_LE, FOH_OP, COND_OP, SE, RW, E, LINK, MV}),
        .A1(21'b0),
        .S(NOP),
        .O(ID_CONTROL_SIGNALS)
    );

    DHDU DHDU_PPU (
        .A_S(A_S),
        .B_S(B_S),
        .NOP(NOP),
        .LE(LE),
        .RA(ID_I[25:21]),
        .RB(ID_I[20:16]),
        .SR(ID_SR),
        .EX_L(EX_CONTROL_SIGNALS[11]),
        .EX_RD(EX_RD),
        .MEM_RD(MEM_RD),
        .WB_RD(WB_RD),
        .EX_RF_LE(EX_RF_LE_OU),
        .MEM_RF_LE(MEM_CONTROL_SIGNALS[3]),
        .WB_RF_LE(WB_RF_LE_OU)
    );

    pipe_reg #(175) ID_EX_REGISTER (
        .clk(CLK),
        .rst(RESET),
        .d({ID_PC_EIGHT, ID_TAG_OU, ID_MUX_PA_OU, ID_MUX_PB_OU, ID_I[15:0], ID_I[10:6], ID_RD, ID_CONTROL_SIGNALS}),
        .q({EX_PC_EIGHT, EX_TAG_OU, EX_PA, EX_PB, EX_IMM, EX_SA, EX_RD, EX_CONTROL_SIGNALS})
    );

    //==================================== EX MODULES ====================================//

    foh foh_PPU (
        .OA(FOH_OU),
        .RA(EX_PA),
        .SA(EX_SA),
        .OS1(EX_CONTROL_SIGNALS[9])
    );

    soh soh_PPU (
        .OB(SOH_OU),
        .RB(EX_PB),
        .I(EX_IMM),
        .OS2(EX_CONTROL_SIGNALS[19:18])
    );

    zero_detector ZD_PPU (
        .Z(Zero),
        .B(SOH_OU)
    );

    alu ALU_PPU (
        .Out(EX_ALU_OU),
        .OP(EX_CONTROL_SIGNALS[17:14]),
        .GT(GT_ALU),
        .EQ(EQ_ALU),
        .LE(LE_ALU),
        .A(FOH_OU),
        .B(SOH_OU)
    );

    condition_handler CD_PPU (
        .J(EX_J),
        .RF_LE_OU(EX_RF_LE_OU),
        .BI(EX_CONTROL_SIGNALS[20]),
        .RF_LE(EX_CONTROL_SIGNALS[10]),
        .MV(EX_CONTROL_SIGNALS[1:0]),
        .Z(Zero),
        .cond(EX_CONTROL_SIGNALS[8:6]),
        .ACC({LE_ALU, EQ_ALU, GT_ALU})
    );

    mux_n ALU_MUX (
        .A0(EX_ALU_OU),
        .A1(EX_PC_EIGHT),
        .S(EX_CONTROL_SIGNALS[2]),
        .O(EX_MUX_ALU)
    );

    pipe_reg #(76) EX_MEM_REGISTER (
        .clk(CLK),
        .rst(RESET),
        .d({EX_PB, EX_MUX_ALU, EX_RD, EX_CONTROL_SIGNALS[13:12], EX_CONTROL_SIGNALS[11], EX_RF_LE_OU, EX_CONTROL_SIGNALS[5], EX_CONTROL_SIGNALS[4], EX_CONTROL_SIGNALS[3]}),
        .q({MEM_PB, MEM_ALU_OU, MEM_RD, MEM_CONTROL_SIGNALS})
    );

    //==================================== MEM MODULES ====================================//

    data_memory DATA_MEM_PPU (
        .DI(MEM_PB),
        .A(MEM_ALU_OU[8:0]),
        .Size(MEM_CONTROL_SIGNALS[6:5]),
        .SE(MEM_CONTROL_SIGNALS[2]),
        .RW(MEM_CONTROL_SIGNALS[1]),
        .E(MEM_CONTROL_SIGNALS[0]),
        .DO(MEM_DO)
    );

    mux_n DATA_MEM_MUX (
        .A0(MEM_ALU_OU),
        .A1(MEM_DO),
        .S(MEM_CONTROL_SIGNALS[4]),
        .O(MEM_PD)
    );

    pipe_reg #(38) MEM_WB_REGISTER (
        .clk(CLK),
        .rst(RESET),
        .d({MEM_RD, MEM_PD, MEM_CONTROL_SIGNALS[3]}),
        .q({WB_RD, WB_PD, WB_RF_LE_OU})
    );

    //==================================== WB MODULES ====================================//
    

endmodule