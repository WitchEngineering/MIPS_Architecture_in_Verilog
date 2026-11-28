module PPU_TestBench_Validation;
    reg CLK, RESET;
    PPU dut (.CLK(CLK), .RESET(RESET));

    wire signed [31:0] r16_signed = dut.REG_FILE.Q16;

    initial begin CLK = 0; forever #2 CLK = ~CLK; end
    initial begin RESET = 1; #3 RESET = 0; end

    initial $monitor("t=%0t PC=%0d r2=%0d r5=%0d r6=%0d r16=%0d r17=%0d r18=%0d",
        $time, dut.IF_PC_OU, dut.REG_FILE.Q2, dut.REG_FILE.Q5, dut.REG_FILE.Q6,
        r16_signed, dut.REG_FILE.Q17, dut.REG_FILE.Q18);

    initial begin
        #88 $display("%b %b %b %b", dut.DATA_MEM_PPU.Mem[76], dut.DATA_MEM_PPU.Mem[77],
                                    dut.DATA_MEM_PPU.Mem[78], dut.DATA_MEM_PPU.Mem[79]);
        #4 $finish;   // t = 92
    end
endmodule