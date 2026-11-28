module PPU_TestBench_First_Program;
    reg CLK, RESET;
    PPU dut (.CLK(CLK), .RESET(RESET));

    initial begin CLK = 0; forever #2 CLK = ~CLK; end
    initial begin RESET = 1; #3 RESET = 0; end

    wire signed [31:0] reg1_signed = dut.REG_FILE.Q1;
    wire signed [31:0] reg2_signed = dut.REG_FILE.Q2;
    wire signed [31:0] reg3_signed = dut.REG_FILE.Q3;
    wire signed [31:0] reg5_signed = dut.REG_FILE.Q5;
    wire [8:0] mem_addr = dut.MEM_ALU_OU[8:0];

    initial $monitor("t=%0t PC=%0d r1=%0d r2=%0d r3=%0d r5=%0d, memory_address=%0d",
        $time, dut.IF_PC_OU, reg1_signed, reg2_signed, reg3_signed, reg5_signed, mem_addr);

    initial begin
        #164 $display("%b %b %b %b", dut.DATA_MEM_PPU.Mem[44], dut.DATA_MEM_PPU.Mem[45],
                                dut.DATA_MEM_PPU.Mem[46], dut.DATA_MEM_PPU.Mem[47]);
        #4 $finish;   // t = 168
end
endmodule