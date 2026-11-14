module tb_DHDU;

    reg  [4:0] RA, RB, EX_RD, MEM_RD, WB_RD;
    reg  [1:0] SR;
    reg        EX_L, EX_RF_LE, MEM_RF_LE, WB_RF_LE;
    wire [1:0] A_S, B_S;
    wire       NOP, LE;

    integer errors = 0;

    DHDU uut (.A_S(A_S), .B_S(B_S), .NOP(NOP), .LE(LE),
              .RA(RA), .RB(RB), .SR(SR),
              .EX_L(EX_L), .EX_RD(EX_RD), .MEM_RD(MEM_RD), .WB_RD(WB_RD),
              .EX_RF_LE(EX_RF_LE), .MEM_RF_LE(MEM_RF_LE), .WB_RF_LE(WB_RF_LE));

    // Compares the outputs against the expected values

    task check;
        input [8*40:1] name;
        input [1:0] eA, eB;
        input eNOP, eLE;
        begin
            if (A_S===eA && B_S===eB && NOP===eNOP && LE===eLE)
                $display("PASS | %0s | A_S=%b B_S=%b NOP=%b LE=%b", name, A_S, B_S, NOP, LE);
            else begin
                $display("FAIL | %0s | got A_S=%b B_S=%b NOP=%b LE=%b -- expected A_S=%b B_S=%b NOP=%b LE=%b",
                          name, A_S, B_S, NOP, LE, eA, eB, eNOP, eLE);
                errors = errors + 1;
            end
        end
    endtask

    // Clears the pipeline and sets the default values for the inputs 
    task clear;
        begin
            RA=5'd1; RB=5'd2; SR=2'b11;
            EX_L=0; EX_RF_LE=0; MEM_RF_LE=0; WB_RF_LE=0;
            EX_RD=5'd0; MEM_RD=5'd0; WB_RD=5'd0;
        end
    endtask

    initial begin
        $display("================ DHDU TEST BENCH ================");

        // 1. No hazards
        clear; #2;
        check("1. No hazard", 2'b00, 2'b00, 1'b0, 1'b1);

        // 2. RA hazard with the instruction in EX
        clear; EX_RF_LE=1; EX_RD=5'd1; #2;
        check("2. RA hazard with EX", 2'b01, 2'b00, 1'b0, 1'b1);

        // 3. RB hazard with the instruction in MEM
        clear; MEM_RF_LE=1; MEM_RD=5'd2; #2;
        check("3. RB hazard with MEM", 2'b00, 2'b10, 1'b0, 1'b1);

        // 4. RA hazard with the instruction in WB
        clear; WB_RF_LE=1; WB_RD=5'd1; #2;
        check("4. RA hazard with WB", 2'b11, 2'b00, 1'b0, 1'b1);

        // 5. All three stages match
        clear; RB=5'd1; EX_RF_LE=1; MEM_RF_LE=1; WB_RF_LE=1;
        EX_RD=5'd1; MEM_RD=5'd1; WB_RD=5'd1; #2;
        check("5. Priority EX>MEM>WB", 2'b01, 2'b01, 1'b0, 1'b1);

        // 6. A different hazard on each operand at the same time
        clear; EX_RF_LE=1; EX_RD=5'd2; WB_RF_LE=1; WB_RD=5'd1; #2;
        check("6. RA with WB and RB with EX", 2'b11, 2'b01, 1'b0, 1'b1);

        // 7. The instruction reads no source registers (SR=00)
        clear; SR=2'b00; EX_RF_LE=1; EX_RD=5'd1; MEM_RF_LE=1; MEM_RD=5'd2; #2;
        check("7. SRA=0 and SRB=0", 2'b00, 2'b00, 1'b0, 1'b1);

        // 8. Only the first operand is used
        clear; SR=2'b10; EX_RF_LE=1; EX_RD=5'd1; MEM_RF_LE=1; MEM_RD=5'd2; #2;
        check("8. SRA=1, SRB=0", 2'b01, 2'b00, 1'b0, 1'b1);

        // 9. LOAD-USE on RA: the load in EX writes the register ID needs
        clear; EX_L=1; EX_RF_LE=1; EX_RD=5'd1; #2;
        check("9. Load-use on RA", 2'b00, 2'b00, 1'b1, 1'b0);

        // 10. LOAD-USE on RB
        clear; EX_L=1; EX_RF_LE=1; EX_RD=5'd2; #2;
        check("10. Load-use on RB", 2'b00, 2'b00, 1'b1, 1'b0);

        // 11. Load in EX but ID does not use its destination
        clear; EX_L=1; EX_RF_LE=1; EX_RD=5'd7; MEM_RF_LE=1; MEM_RD=5'd1; #2;
        check("11. Load in EX, no conflict", 2'b10, 2'b00, 1'b0, 1'b1);

        // 12. Load in EX but the instruction in ID uses no sources (SR=00)
        clear; SR=2'b00; EX_L=1; EX_RF_LE=1; EX_RD=5'd1; #2;
        check("12. Load-use with SR=00", 2'b00, 2'b00, 1'b0, 1'b1);

        // 13. Sequence from the validation program (ADDI r5 ahead of LB r16,0(r5))
        //     ID = LB r16,0(r5): RA=r5, no second source register
        //     EX = ADDI r5,r0,76 (not a load, writes r5)
        clear; RA=5'd5; RB=5'd0; SR=2'b10; EX_RF_LE=1; EX_RD=5'd5; #2;
        check("13. Validation: forward from EX", 2'b01, 2'b00, 1'b0, 1'b1);

        // 14-15. Same r5, now in MEM and then in WB
        clear; RA=5'd5; RB=5'd0; SR=2'b10; MEM_RF_LE=1; MEM_RD=5'd5; #2;
        check("14. Validation: forward from MEM", 2'b10, 2'b00, 1'b0, 1'b1);
        clear; RA=5'd5; RB=5'd0; SR=2'b10; WB_RF_LE=1; WB_RD=5'd5; #2;
        check("15. Validation: forward from WB", 2'b11, 2'b00, 1'b0, 1'b1);

        $display("================================================");
        if (errors == 0) $display("RESULT: all tests passed.");
        else             $display("RESULT: %0d test(s) failed.", errors);
        $finish;
    end
endmodule
