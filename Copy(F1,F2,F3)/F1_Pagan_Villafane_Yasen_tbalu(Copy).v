module tb_alu_test;

// Inputs (reg) and Outputs (wire) for (ALU)
  reg [31:0] A;
  reg [31:0] B;
  reg [3:0] OP;
  wire [31:0] Out;

  // Flags
  wire LE;
  wire EQ;
  wire GT;

// Inputs and Outputs for (SOH and FOH)

  reg [31:0] RA;
  reg [31:0] RB;
  reg [4:0] SA;
  reg [15:0] I;
  reg OS1;
  reg [1:0] OS2;
  wire [31:0] OA;
  wire [31:0] OB;

foh u_foh (.RA(RA), .SA(SA), .OS1(OS1), .OA(OA));
soh u_soh (.RB(RB), .I(I), .OS2(OS2), .OB(OB));
alu u_alu (.A(OA), .B(OB), .OP(OP), .GT(GT), .EQ(EQ), .LE(LE), .Out(Out));

initial begin

  /* Test for SOH and FOH (Not intended for demonstration)
  $display("== test_1: SOH ==");
  $monitor("RB=%b I=%b OS2=%b OB=%b ", RB, I, OS2, OB);

  RB = 32'b01110000000000000000000000000011;
  SA = 5'b00101;
  I = 16'b1111111111011000;
  
  OS2 = 2'b00; #2;
  OS2 = 2'b01; #2;
  OS2 = 2'b10; #2;

  #2;
  $display("== test_3: FOH ==");
  $monitor("RA=%b SA=%b OS1=%b OA=%b ", RA, SA, OS1, OA);
  RA = 32'b10011100000000000000000000100010;
  SA = 5'b00101;

  OS1 = 0; #2;
  OS1 = 1; #2;
  
  #2;
  */

  $display("==test_3: ALU ==");
  $monitor("OP=%b Out=%b LE=%b EQ=%b GT=%b", OP, Out, LE, EQ, GT);

  // Valores indicados en las instrucciones.
  RA = 32'b10011100000000000000000000100010;  
  RB = 32'b01110000000000000000000000000011;
  SA = 5'b00101;
  I = 16'b1111111111011000;

  // Test 1:
  // A = RA
  // B = RB
  // Probar los 16 códigos de OP

  OS1 = 1'b0;
  OS2 = 2'b00;
  #2;

  // Arithmetic and Logic Gates
  OP = 4'b0000; #2; // ADD
  OP = 4'b0001; #2; // SUB, BEQ and BNE
  OP = 4'b0010; #2; // AND, ANDI
  OP = 4'b0011; #2; // OR, ORI
  OP = 4'b0100; #2; // XOR, XORI
  OP = 4'b0101; #2; // NOR
  OP = 4'b0110; #2; // SLL, SLLV
  OP = 4'b0111; #2; // SRL, SRLV
  OP = 4'b1000; #2; // SLT, SLTI
  OP = 4'b1001; #2; // SRA, SRAV
  OP = 4'b1010; #2; // PASS A
  OP = 4'b1011; #2; // Pass B (LUI)
  OP = 4'b1100; #2; // MOVN
  OP = 4'b1101; #2; // MOVZ
  OP = 4'b1110; #2; // N/A
  OP = 4'b1111; #2; // N/A

  // Test 2
  // A = SA extendido a 32 bits
  // B = I con extensión de signo
  // Probar las operaciones de shift.

    OS1 = 1'b1;
    OS2 = 2'b01;

    OP = 4'b0110; #2; // SLL, SLLV
    OP = 4'b0111; #2; // SRL, SRLV
    OP = 4'b1001; #2; // SRA, SRAV

  // Test 3
  // OS2=10 coloca I en los 16 bits superiores.
  // Aquí se asume OS1=0.
  
        OS1 = 1'b0;
        OS2 = 2'b10;
  
        OP = 4'b0000; #2; // ADD

    $finish;
  end 
endmodule 

// Old Code: 

 // Custom Data (test)
  // A = 32'h9C000022; 
  // B = 32'h70000003;

  // OS1 = 0; #2;
  // OS2 = 2'b00; #2;
  // OS2 = 2'b01; #2;  // expect OB = FFFFFFD8 (sign-extended I)
  // OS2 = 2'b10; #2;  // expect OB = FFD80000 (LUI-style)
  // OS1 = 1; #2;

  // Reset to check the ALU:
  // OS1 = 0;
  // OS2 = 2'b00;
  // #2;