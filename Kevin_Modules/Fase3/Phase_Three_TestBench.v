module phase_three_tb;

    reg CLK, RST, S;

    wire [31:0] PC, I_PASG, I_MEM, TAO;

    wire [20:0] CS_MUX;
    wire[20:0] EX_CS;
    wire [6:0] MEM_CS;
    wire WB_RF_LE; 

    //Señales de control
    wire [1:0] RD_S, SOH_OP, Size, MV, ID_SR;
    wire [3:0] ALU_OP;
    wire [2:0] COND_OP;
    wire B, L, RF_LE, FOH_OP, SE, RW, E, LINK, ID_J, INVALID;
    wire [8*8-1:0] NAME;

    PASG PASG_PHTh (
        .CLK(CLK),
        .LE(1'b1),
        .RESET(RST),
        .J(1'b0),
        .CLR(1'b0),
        .INS(I_MEM),
        .TAI(32'b0),
        .RS(32'b0),
        .TAO(TAO),
        .I(I_PASG),
        .PC(PC)
    );

    instruction_memory ins_memory_PHTh (
        .A(PC[8:0]),
        .I(I_MEM)
    );

    control_unit control_unit_PHTh (
        .I(I_PASG),
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
        .INVALID(INVALID),
        .NAME(NAME)
    );

    wire [20:0] CS = {B, SOH_OP, ALU_OP, Size, L, RF_LE, FOH_OP, COND_OP, SE, RW, E, LINK, MV};
    
    mux_third_phase mux (
        .A0(CS),
        .A1(21'b0),
        .S(S),
        .O(CS_MUX)
    );

    pipe_reg #(21) ID_EX (
        .clk(CLK),
        .rst(RST),
        .d(CS_MUX),
        .q(EX_CS)
    );

    //Señales en EX
    wire EX_B = EX_CS[20];           
    wire [1:0] EX_SOH_OP = EX_CS[19:18];
    wire [3:0] EX_ALU_OP = EX_CS[17:14]; 
    wire [1:0] EX_Size = EX_CS[13:12];
    wire EX_L = EX_CS[11];           
    wire EX_RF_LE = EX_CS[10];
    wire EX_FOH_OP = EX_CS[9];       
    wire [2:0] EX_COND_OP = EX_CS[8:6];
    wire EX_SE = EX_CS[5];           
    wire EX_RW = EX_CS[4];
    wire EX_E = EX_CS[3];            
    wire EX_LINK = EX_CS[2];
    wire [1:0] EX_MV = EX_CS[1:0];

    pipe_reg #(7) EX_MEM (
        .clk(CLK),
        .rst(RST),
        .d({EX_Size, EX_SE, EX_RW, EX_E, EX_L, EX_RF_LE}), 
        .q(MEM_CS)
    );

    //Señales en MEM
    wire [1:0] MEM_Size = MEM_CS[6:5];
    wire MEM_SE = MEM_CS[4];
    wire MEM_RW = MEM_CS[3];
    wire MEM_E = MEM_CS[2];
    wire MEM_L = MEM_CS[1];
    wire MEM_RF_LE = MEM_CS[0];

    pipe_reg #(1) MEM_WB (
        .clk(CLK),
        .rst(RST),
        .d(MEM_CS[0]),
        .q(WB_RF_LE)
    );

    //Solo una señal en WB: WB_RF_LE

    always @(posedge CLK) begin
        if (RST !== 1'B1) begin
            $display("%0s, PC=%0d Time=%0t", NAME, $signed(PC)-4, $time);

            if (INVALID === 1'b1)
                $display("ALERTA: instruccion invalida en PC=%0d", PC - 4);

            $display("Etapa ID: RD_S=%b, B=%b, SOH_OP=%b, ALU_OP=%b, Size=%b, L=%b, RF_LE=%b, FOH_OP=%b, COND_OP=%b, SE=%b, RW=%b, E=%b, LINK=%b, MV=%b, ID_SR=%b, ID_J=%b",
                RD_S, B, SOH_OP, ALU_OP, Size, L, RF_LE, FOH_OP, COND_OP, SE, RW, E, LINK, MV, ID_SR, ID_J);

            $display("Etapa EX: B_EX=%b, SOH_OP_EX=%b, ALU_OP_EX=%b, Size_EX=%b, L_EX=%b, RF_LE_EX=%b, FOH_OP_EX=%b, COND_OP_EX=%b, SE_EX=%b, RW_EX=%b, E_EX=%b, LINK_EX=%b, MV_EX=%b",
                EX_B, EX_SOH_OP, EX_ALU_OP, EX_Size, EX_L, EX_RF_LE, EX_FOH_OP, EX_COND_OP, EX_SE, EX_RW, EX_E, EX_LINK, EX_MV);

            $display("Etapa MEM: Size_MEM=%b, SE_MEM=%b, RW_MEM=%b, E_MEM=%b, L_MEM=%b, RF_LE_MEM=%b",
                MEM_Size, MEM_SE, MEM_RW, MEM_E, MEM_L, MEM_RF_LE);

            $display("Etapa WB: RF_LE_WB=%b", WB_RF_LE);
        end
    end

    initial begin
    CLK = 0;
    forever #2 CLK = ~CLK;
    end

    initial begin
        RST = 1;
        S   = 0;
        #3  RST = 0;
        #69 S   = 1;      // t = 72
        #12 $finish;      // t = 84
    end
endmodule