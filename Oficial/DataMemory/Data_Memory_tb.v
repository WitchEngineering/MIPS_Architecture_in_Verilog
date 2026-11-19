module tb_data_memory;

  // Inputs
  reg [31:0] DI;
  reg [8:0] A;
  reg [1:0] Size;
  reg SE;
  reg RW;
  reg E;

  // Output
  wire [31:0] DO;

  // 3x1 Mux (Inputs and Outputs)

  reg [31:0] Zero;
  // reg [31:0] One; 
  reg L; 

  wire [31:0] MEM_PD;

  data_memory u_dut (.DI(DI), .A(A), .Size(Size), .SE(SE), .RW(RW), .E(E), .DO(DO));
   // Needs to be the same name as the component
                      // Zero = MEM_ALU_OU , One = DO
  multiplexer_3x1 u_mux_3x1 (.Zero(Zero), .One(DO), .L(L), .MEM_PD(MEM_PD));

  // Size encodings
  localparam BYTE = 2'b00, HALF = 2'b01, WORD = 2'b10;

  // Read task: RW = 0
  task read(input [8:0] addr, input [1:0] sz, input se_in);
    begin
      RW = 0; E = 0; A = addr; Size = sz; SE = se_in; L = 1; Zero = {23'b0, A};
      #10;
      $display("%0t  READ  A=%0d Size=%b SE=%b -> DO=%h", $time, A, Size, SE, DO);
    end
  endtask

  // Write task: RW = 1, E = 1, then return to no-op (E = 0)
  task write(input [8:0] addr, input [1:0] sz, input [31:0] data);
    begin
      RW = 1; E = 1; A = addr; Size = sz; SE = 0; DI = data; L = 0; Zero = {23'b0, A};
      #10;
      $display("%0t  WRITE A=%0d Size=%b DI=%h", $time, A, Size, DI);
      E = 0;
      #10;
    end
  endtask

  integer i;

  initial begin
    $dumpfile("Data_Memory_tb.vcd");
    $dumpvars(0, tb_data_memory);

    // Reset Line: 
    DI = 0; A = 0; Size = 0; SE = 0; RW = 0; E = 0; L = 0; Zero = 0;

    $display("==Test: Mux_3x1 ==");
    $monitor("Zero=%b One=%b, L=%b, MEM_PD=%b", Zero, DO, L, MEM_PD);

    // Preload memory (one byte per whitespace binary value)
    $readmemb("Data_Preload.txt", u_dut.Mem);

    $display("--- Preloaded memory (first 16 bytes) ---");
    for (i = 0; i < 16; i = i + 1)
    $display("Mem[%0d] = %h", i, u_dut.Mem[i]);

    $display("--- Read word at 0, 4, 8, 12 ---");
    read(0, WORD, 0);
    read(4, WORD, 0);
    read(8, WORD, 0);
    read(12, WORD, 0);

    $display("--- Read signed byte (SE=1) at 0 and 3 ---");
    read(0, BYTE, 1);
    read(3, BYTE, 1);

    $display("--- Read unsigned byte (SE=0) at 0 and 3 ---");
    read(0, BYTE, 0);
    read(3, BYTE, 0);

    $display("--- Read signed halfword (SE=1) at 4 and 6 ---");
    read(4, HALF, 1);
    read(6, HALF, 1);

    $display("--- Writes ---");
    write(0, BYTE, 32'h000000A6);
    write(2, BYTE, 32'h000000DD);
    write(4, HALF, 32'h0000ABCD);
    write(6, HALF, 32'h0000EF01);
    write(12, WORD, 32'h33445566);

    $display("--- Read word at 0, 4, 12 ---");
    read(0,  WORD, 0);
    read(4,  WORD, 0);
    read(12, WORD, 0);

    $finish;
  end
endmodule