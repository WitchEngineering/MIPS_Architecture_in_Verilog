module control_unit (
    input [31:0] I,
    output reg [1:0] RD_S,
    output reg B,
    output reg [1:0] SOH_OP,
    output reg [3:0] ALU_OP,
    output reg [1:0] Size,
    output reg L,
    output reg RF_LE,
    output reg FOH_OP,
    output reg [2:0] COND_OP,
    output reg SE,
    output reg RW,
    output reg E,
    output reg LINK,
    output reg [1:0] MV,
    output reg [1:0] ID_SR,
    output reg ID_J,
    output reg INVALID,
    output reg [8*8-1:0] NAME
    );

    wire [5:0] opcode = I[31:26];
    wire [4:0] rs = I[25:21];
    wire [4:0] rt = I[20:16];
    wire [5:0] func = I[5:0];

    always @(*) begin

        //Default, NOP
        RD_S = 2'b00;
        B = 0;
        SOH_OP = 2'b00;
        ALU_OP = 4'b0000;
        Size = 2'b00;
        L = 0;
        RF_LE = 0;
        FOH_OP = 0;
        COND_OP = 3'b000;
        SE = 0;
        RW = 0;
        E = 0;
        LINK = 0;
        MV = 2'b00;
        ID_SR = 2'b00;
        ID_J = 0;
        INVALID = 0;
        NAME = "NOP";

        if(^I === 1'bx) begin
            NAME = "---";
        end
        else if (I == 32'b0) begin
            NAME = "NOP";
        end
        else begin
            case (opcode)
                6'b000000: case (func)
                    6'b100000: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0000;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "ADD";
                    end

                    6'b100010: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0001;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "SUB";
                    end

                    6'b100100: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0010;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "AND";
                    end

                    6'b100101: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0011;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "OR";
                    end

                    6'b100110: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0100;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "XOR";
                    end

                    6'b100111: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0101;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "NOR";
                    end

                    6'b101010: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b1000;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "SLT";
                    end

                    6'b001011: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b1100;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b01;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "MOVN";
                    end

                    6'b001010: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b1101;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b10;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "MOVZ";
                    end

                    6'b000000: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0110;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 1;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b01;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "SLL";
                    end

                    6'b000011: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b1001;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 1;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b01;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "SRA";
                    end

                    6'b000010: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0111;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 1;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b01;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "SRL";
                    end

                    6'b000100: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0110;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "SLLV";
                    end

                    6'b000111: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b1001;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "SRAV";
                    end

                    6'b000110: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0111;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "SRLV";
                    end

                    6'b001001: begin
                        RD_S = 2'b10;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0000;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 1;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 1;
                        MV = 2'b00;
                        ID_SR = 2'b10;
                        ID_J = 1;
                        INVALID = 0;
                        NAME = "JALR";
                    end

                    6'b001000: begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0000;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 0;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b10;
                        ID_J = 1;
                        INVALID = 0;
                        NAME = "JR";
                    end

                    default: begin
                        INVALID = 1;
                        NAME = "INVALID";
                    end
                endcase

                6'b001000: begin
                    RD_S = 2'b01;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0000;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "ADDI";
                end

                6'b001100: begin
                    RD_S = 2'b01;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0010;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "ANDI";
                end

                6'b001101: begin
                    RD_S = 2'b01;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0011;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "ORI";
                end

                6'b001110: begin
                    RD_S = 2'b01;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0100;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "XORI";
                end

                6'b001010: begin
                    RD_S = 2'b01;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b1000;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "SLTI";
                end

                6'b001111: begin
                    RD_S = 2'b01;
                    B = 0;
                    SOH_OP = 2'b10;
                    ALU_OP = 4'b1011;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b00;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "LUI";
                end

                6'b100011: begin
                    RD_S = 2'b01;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0000;
                    Size = 2'b10;
                    L = 1;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "LW";
                end

                6'b100001: begin
                    RD_S = 2'b01;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0000;
                    Size = 2'b01;
                    L = 1;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 1;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "LH";
                end

                6'b100101: begin
                    RD_S = 2'b01;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0000;
                    Size = 2'b01;
                    L = 1;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "LHU";
                end

                6'b100000: begin
                    RD_S = 2'b01;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0000;
                    Size = 2'b00;
                    L = 1;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 1;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "LB";
                end

                6'b100100: begin
                    RD_S = 2'b01;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0000;
                    Size = 2'b00;
                    L = 1;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "LBU";
                end

                6'b101011: begin
                    RD_S = 2'b00;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0000;
                    Size = 2'b10;
                    L = 0;
                    RF_LE = 0;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 1;
                    E = 1;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b11;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "SW";
                end

                6'b101001: begin
                    RD_S = 2'b00;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0000;
                    Size = 2'b01;
                    L = 0;
                    RF_LE = 0;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 1;
                    E = 1;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b11;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "SH";
                end

                6'b101000: begin
                    RD_S = 2'b00;
                    B = 0;
                    SOH_OP = 2'b01;
                    ALU_OP = 4'b0000;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 0;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 1;
                    E = 1;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b11;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "SB";
                end

                6'b000100: begin
                    if(rs == 5'b0 && rt == 5'b0) begin
                        RD_S = 2'b00;
                        B = 0;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0000;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 0;
                        FOH_OP = 0;
                        COND_OP = 3'b000;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b00;
                        ID_J = 1;
                        INVALID = 0;
                        NAME = "B";
                    end else begin 
                        RD_S = 2'b00;
                        B = 1;
                        SOH_OP = 2'b00;
                        ALU_OP = 4'b0001;
                        Size = 2'b00;
                        L = 0;
                        RF_LE = 0;
                        FOH_OP = 0;
                        COND_OP = 3'b010;
                        SE = 0;
                        RW = 0;
                        E = 0;
                        LINK = 0;
                        MV = 2'b00;
                        ID_SR = 2'b11;
                        ID_J = 0;
                        INVALID = 0;
                        NAME = "BEQ";
                    end
                end

                6'b000001: begin
                    case (rt)
                        5'b10001:
                            if(rs == 5'b0) begin
                                RD_S = 2'b10;
                                B = 0;
                                SOH_OP = 2'b00;
                                ALU_OP = 4'b0000;
                                Size = 2'b00;
                                L = 0;
                                RF_LE = 1;
                                FOH_OP = 0;
                                COND_OP = 3'b000;
                                SE = 0;
                                RW = 0;
                                E = 0;
                                LINK = 1;
                                MV = 2'b00;
                                ID_SR = 2'b00;
                                ID_J = 1;
                                INVALID = 0;
                                NAME = "BAL";
                            end else begin
                                RD_S = 2'b10;
                                B = 1;
                                SOH_OP = 2'b00;
                                ALU_OP = 4'b1010;
                                Size = 2'b00;
                                L = 0;
                                RF_LE = 1;
                                FOH_OP = 0;
                                COND_OP = 3'b011;
                                SE = 0;
                                RW = 0;
                                E = 0;
                                LINK = 1;
                                MV = 2'b00;
                                ID_SR = 2'b10;
                                ID_J = 0;
                                INVALID = 0;
                                NAME = "BGEZAL";
                            end

                        5'b00001: begin
                            RD_S = 2'b00;
                            B = 1;
                            SOH_OP = 2'b00;
                            ALU_OP = 4'b1010;
                            Size = 2'b00;
                            L = 0;
                            RF_LE = 0;
                            FOH_OP = 0;
                            COND_OP = 3'b011;
                            SE = 0;
                            RW = 0;
                            E = 0;
                            LINK = 0;
                            MV = 2'b00;
                            ID_SR = 2'b10;
                            ID_J = 0;
                            INVALID = 0;
                            NAME = "BGEZ";
                        end
                    
                        5'b00000: begin
                            RD_S = 2'b00;
                            B = 1;
                            SOH_OP = 2'b00;
                            ALU_OP = 4'b1010;
                            Size = 2'b00;
                            L = 0;
                            RF_LE = 0;
                            FOH_OP = 0;
                            COND_OP = 3'b100;
                            SE = 0;
                            RW = 0;
                            E = 0;
                            LINK = 0;
                            MV = 2'b00;
                            ID_SR = 2'b10;
                            ID_J = 0;
                            INVALID = 0;
                            NAME = "BLTZ";
                        end

                        5'b10000: begin
                            RD_S = 2'b10;
                            B = 1;
                            SOH_OP = 2'b00;
                            ALU_OP = 4'b1010;
                            Size = 2'b00;
                            L = 0;
                            RF_LE = 1;
                            FOH_OP = 0;
                            COND_OP = 3'b100;
                            SE = 0;
                            RW = 0;
                            E = 0;
                            LINK = 1;
                            MV = 2'b00;
                            ID_SR = 2'b10;
                            ID_J = 0;
                            INVALID = 0;
                            NAME = "BLTZAL";
                        end

                        default: begin
                            INVALID = 1;
                            NAME = "INVALID";
                        end
                    endcase
                end

                6'b000111: begin
                    RD_S = 2'b00;
                    B = 1;
                    SOH_OP = 2'b00;
                    ALU_OP = 4'b1010;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 0;
                    FOH_OP = 0;
                    COND_OP = 3'b001;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "BGTZ";
                end

                6'b000110: begin
                    RD_S = 2'b00;
                    B = 1;
                    SOH_OP = 2'b00;
                    ALU_OP = 4'b1010;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 0;
                    FOH_OP = 0;
                    COND_OP = 3'b110;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b10;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "BLEZ";
                end

                6'b000101: begin
                    RD_S = 2'b00;
                    B = 1;
                    SOH_OP = 2'b00;
                    ALU_OP = 4'b0001;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 0;
                    FOH_OP = 0;
                    COND_OP = 3'b101;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b11;
                    ID_J = 0;
                    INVALID = 0;
                    NAME = "BNE";
                end

                6'b000010: begin
                    RD_S = 2'b00;
                    B = 0;
                    SOH_OP = 2'b00;
                    ALU_OP = 4'b0000;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 0;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 0;
                    MV = 2'b00;
                    ID_SR = 2'b00;
                    ID_J = 1;
                    INVALID = 0;
                    NAME = "J";
                end

                6'b000011: begin
                    RD_S = 2'b10;
                    B = 0;
                    SOH_OP = 2'b00;
                    ALU_OP = 4'b0000;
                    Size = 2'b00;
                    L = 0;
                    RF_LE = 1;
                    FOH_OP = 0;
                    COND_OP = 3'b000;
                    SE = 0;
                    RW = 0;
                    E = 0;
                    LINK = 1;
                    MV = 2'b00;
                    ID_SR = 2'b00;
                    ID_J = 1;
                    INVALID = 0;
                    NAME = "JAL";
                end

                default: begin
                    INVALID = 1;
                    NAME = "INVALID";
                end
            endcase
        end
    end
endmodule