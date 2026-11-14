//=====================================================================
// Test Bench for the forwarding muxes + the DHDU
// Alejandro Rodriguez Burgos
//
// Wires the DHDU to both 4x1 muxes the way they sit in the PPU, to
// check that the right operand comes out for every kind of hazard.
//
// Compile:
//   iverilog -o sim_fwd F4_Rodriguez_Burgos_Alejandro_fwd_mux.v \
//                       F4_Rodriguez_Burgos_Alejandro_DHDU.v \
//                       F4_Rodriguez_Burgos_Alejandro_tbfwd_mux.v
//   vvp sim_fwd
//=====================================================================
module tb_fwd_mux;

    // Values each stage would be presenting to the muxes
    localparam [31:0] VAL_RF_A  = 32'd100;   // PA from the Register File (stale)
    localparam [31:0] VAL_RF_B  = 32'd200;   // PB from the Register File (stale)
    localparam [31:0] VAL_EX    = 32'd111;   // EX_MUX_ALU
    localparam [31:0] VAL_MEM   = 32'd222;   // MEM_PD
    localparam [31:0] VAL_WB    = 32'd333;   // WB_PD

    reg  [4:0] RA, RB, EX_RD, MEM_RD, WB_RD;
    reg  [1:0] SR;
    reg        EX_L, EX_RF_LE, MEM_RF_LE, WB_RF_LE;

    wire [1:0] A_S, B_S;
    wire       NOP, LE;
    wire [31:0] OA, OB;

    integer errors = 0;

    DHDU dhdu (.A_S(A_S), .B_S(B_S), .NOP(NOP), .LE(LE),
               .RA(RA), .RB(RB), .SR(SR),
               .EX_L(EX_L), .EX_RD(EX_RD), .MEM_RD(MEM_RD), .WB_RD(WB_RD),
               .EX_RF_LE(EX_RF_LE), .MEM_RF_LE(MEM_RF_LE), .WB_RF_LE(WB_RF_LE));

    // Top mux: first operand, select A_S
    mux4x1 #(32) mux_A (.O(OA), .I0(VAL_RF_A), .I1(VAL_EX),
                        .I2(VAL_MEM), .I3(VAL_WB), .S(A_S));

    // Bottom mux: second operand, select B_S
    mux4x1 #(32) mux_B (.O(OB), .I0(VAL_RF_B), .I1(VAL_EX),
                        .I2(VAL_MEM), .I3(VAL_WB), .S(B_S));

    task check;
        input [8*44:1] name;
        input [31:0] exp_A, exp_B;
        begin
            if (OA === exp_A && OB === exp_B)
                $display("PASS | %0s | A_S=%b OA=%0d | B_S=%b OB=%0d", name, A_S, OA, B_S, OB);
            else begin
                $display("FAIL | %0s | got OA=%0d OB=%0d -- expected %0d / %0d",
                         name, OA, OB, exp_A, exp_B);
                errors = errors + 1;
            end
        end
    endtask

    task clear;
        begin
            RA=5'd1; RB=5'd2; SR=2'b11;
            EX_L=0; EX_RF_LE=0; MEM_RF_LE=0; WB_RF_LE=0;
            EX_RD=5'd0; MEM_RD=5'd0; WB_RD=5'd0;
        end
    endtask

    initial begin
        $display("========= FORWARDING MUXES + DHDU =========");
        $display("RF: A=%0d B=%0d  |  EX=%0d  MEM=%0d  WB=%0d",
                 VAL_RF_A, VAL_RF_B, VAL_EX, VAL_MEM, VAL_WB);
        $display("");

        // No hazard: both operands come from the Register File
        clear; #2;
        check("1. No hazard    -> RF", VAL_RF_A, VAL_RF_B);

        // First operand hazards with EX
        clear; EX_RF_LE=1; EX_RD=5'd1; #2;
        check("2. RA with EX   -> EX_MUX_ALU", VAL_EX, VAL_RF_B);

        // Second operand hazards with MEM
        clear; MEM_RF_LE=1; MEM_RD=5'd2; #2;
        check("3. RB with MEM  -> MEM_PD", VAL_RF_A, VAL_MEM);

        // First operand hazards with WB
        clear; WB_RF_LE=1; WB_RD=5'd1; #2;
        check("4. RA with WB   -> WB_PD", VAL_WB, VAL_RF_B);

        // Both operands hazard, from different stages
        clear; EX_RF_LE=1; EX_RD=5'd2; WB_RF_LE=1; WB_RD=5'd1; #2;
        check("5. RA with WB, RB with EX", VAL_WB, VAL_EX);

        // All three match: the most recent value wins (EX)
        clear; RB=5'd1; EX_RF_LE=1; MEM_RF_LE=1; WB_RF_LE=1;
        EX_RD=5'd1; MEM_RD=5'd1; WB_RD=5'd1; #2;
        check("6. Priority EX>MEM>WB", VAL_EX, VAL_EX);

        // The instruction reads no source registers: ignore everything
        clear; SR=2'b00; EX_RF_LE=1; EX_RD=5'd1; #2;
        check("7. SR=00 -> no forwarding", VAL_RF_A, VAL_RF_B);

        // Load-use: the DHDU stalls and the muxes stay on the RF
        clear; EX_L=1; EX_RF_LE=1; EX_RD=5'd1; #2;
        check("8. Load-use -> stall", VAL_RF_A, VAL_RF_B);
        if (NOP === 1'b1 && LE === 1'b0)
            $display("       (NOP=1 LE=0, the DHDU freezes IF/ID as it should)");
        else begin
            $display("FAIL | 8. the DHDU did not raise the stall");
            errors = errors + 1;
        end

        $display("");
        $display("===========================================");
        if (errors == 0) $display("RESULT: all tests passed.");
        else             $display("RESULT: %0d test(s) failed.", errors);
        $finish;
    end
endmodule
