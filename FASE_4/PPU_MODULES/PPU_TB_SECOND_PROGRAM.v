module PPU_TestBench_Second_Program;
    reg CLK, RESET;
    PPU dut (.CLK(CLK), .RESET(RESET));

    initial begin CLK = 0; forever #2 CLK = ~CLK; end
    initial begin RESET = 1; #3 RESET = 0; end

    wire signed [31:0] r1  = dut.REG_FILE.Q1;
    wire signed [31:0] r2  = dut.REG_FILE.Q2;
    wire signed [31:0] r3  = dut.REG_FILE.Q3;
    wire signed [31:0] r4  = dut.REG_FILE.Q4;
    wire signed [31:0] r5  = dut.REG_FILE.Q5;
    wire signed [31:0] r7  = dut.REG_FILE.Q7;
    wire signed [31:0] r8  = dut.REG_FILE.Q8;
    wire signed [31:0] r10 = dut.REG_FILE.Q10;
    wire signed [31:0] r12 = dut.REG_FILE.Q12;
    wire signed [31:0] r31 = dut.REG_FILE.Q31;
    wire [8:0] mem_addr = dut.MEM_ALU_OU[8:0];

    initial $monitor("t=%0t PC=%0d addr=%0d r1=%0d r2=%0d r3=%0d r4=%0d r5=%0d r7=%0d r8=%0d r10=%0d r12=%0d r31=%0d",
        $time, dut.IF_PC_OU, mem_addr, r1, r2, r3, r4, r5, r7, r8, r10, r12, r31);

    integer i;
    initial begin
        #224;
        for (i = 204; i < 248; i = i + 4)
            $display("%b %b %b %b", dut.DATA_MEM_PPU.Mem[i], dut.DATA_MEM_PPU.Mem[i+1],
                                    dut.DATA_MEM_PPU.Mem[i+2], dut.DATA_MEM_PPU.Mem[i+3]);
        #8 $finish;   // t = 232
    end
endmodule