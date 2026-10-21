/*
Initial value of the inputs: 

  RA = 10011100000000000000000000100010;
  RB = 01110000000000000000000000000011;
  SA = 00101;
  I = 1111111111011000;
  OS1= 0;
  OS2= 00;

  Unidates de tiempo: #2

  ---

  RA = Registro (32 bits)
  SA = Número de desplazamientos (5 bits)
  OS1 = Fist Operand Selector
  RB = Regsitro B (32 bits)
  I = immediate integer (16 bits)
  OS2 = Second Operand Selector (2 bits)
  OP (op_code) = Código que indica la operación que debe realizar el ALU (4 bits)
  - Especifica un maximo de 16 operaciones
  - Es possible no tener que implementar 16 funciones
  Out = Resultado de operación del ALU (32 bits)
  
    Note: Los op_code son de 4 bits (possibles códigos son 16)

  Ojo: Como los opcodes de las instrucciones son de 6 bits más
  los bits de los opcodes secundario, no es posible y no es necesario tener una correspondencia de
  uno a uno de los opcodes de las instrucciones y los opcodes que maneja el ALU.

  Ojo: Ustedes pueden
  escoger la codificación de la señal OP de ALU que deseen para cada operación.
  --

  Flags: 

  GT = Less than condition bit (1 bit)
  EQ = Equal condition bit (1 bit)
  LE = Less than condition bit (1 bit)
  
  Note: OP = debe tener uno de los 16 códigos de operación.
  */

module foh (output reg [31:0] OA, input [31:0] RA, input [4:0] SA, input OS1);
  // assign OA  (this can't be done as it wires expression permanently with no block involved)
  always @(*) begin
    // If it's not 0 = OA = RA (based on spec)
    if (!OS1)
      OA = RA;
    else 
    // If 1 then OA is the sum of 27 bit worth of 0 and SA = 4 bits
      OA = {27'b0, SA};
  end
endmodule

module soh (output reg [31:0] OB, input [31:0] RB, input [15:0] I, input [1:0] OS2);
  always @(*) begin
  
    /* 
    There independent and as such can't be cheked sequentialy
    Also OS2 can't be checked with a a i bit integer.

    if (OS2 == 0)
      OB = RB;
    if (OS2 == 1'b01)
      OB = I;
    if (OS2 == 1'b10)
      OB = {15'b0, I};
    else 
      OB = OS2;
    */
    
    case (OS2)
      2'b00: OB = RB; // Directly uses the RB 
      2'b01: OB = {{16{I[15]}}, I}; // Extended (I) by 16 bits so it now goes 32 bit
      2'b10: OB = {I, 16'b0}; // this is LUI 
      default: 
      OB = 32'b0; // for the other 11 unused instructions
    endcase
  end
endmodule

module alu (output reg [31:0] Out, input [3:0] OP, output GT, output EQ, output LE, input [31:0] A, input [31:0] B);
  always @(*) begin
    case (OP)
      // Original: 
      /*
      4'b0000: Out = A + B; // ADD, ADDI (Load/ Store Address)
      4'b0001: Out = B << A[4:0]; // SLL, SLLV
      4'b0010: Out = A - B; // SUB, BEQ and BNE
      4'b0011: Out = B >> A[4:0]; // SRL, SRLV (fills with 0)
      4'b0100: Out = A & B; // AND, ANDI
      4'b0101: Out = A | B; // OR, ORI
      4'b0110: Out = A ^ B; // XOR, XORI
      4'b0111: Out = ~ (A | B); // NOR
      */

      /*
      4'b1000: Out = $signed(B) >>> A[4:0]; // SRA, SRAV
      4'b1001: begin // SLT, SLTI
        if ($signed(A) < $signed(B))
          Out = 32'b1; // Se supone que termine de dn?
          else
        Out = 32'b0;
      end
      4'b1010: Out = A; // Pass A
      4'b1011: Out = B; // Pass B (LUI)
      4'b1100: Out = A; // MOVN: rt-check done outside the ALU
      4'b1101: Out = A; // MOVZ: rt-check done outside the ALU
      default: Out = 32'b0;
      */ 

      /* Inmeddiate ALU Instructions (Old Code)
      4'b1000: Out = {16'b0, A}; // ADDI
      4'b1100: Out = A & 16'b0; // ANDI
      4'b1101: Out = A | 16'b0; // XORI

      Falta hacer un (SLT, MOVN y MOVZ)
      case (A < B) // SLT
        4'b1010: Out = 1;
      endcase
      case (!(A < B)) // SLT (else case)
        4'b1010: Out = 0;
      endcase 

      case (A != 0) // MOVN
        4'b1011: Out = A; // it's rs
      endcase

      case (A == 0) // MOVZ
        4'b1010: Out = A;   // it's rs    // this is weird
      endcase

      case (A < 16'b0) // SLTI 
        4'b1010: Out = 1;
      endcase

      case (!(A < 16'b0)) // SLTI (else case)
        4'b1010: Out = 0; 
      endcase
      */ 

      // New: 
       4'b0000: Out = A + B; // ADD, ADDI (Load/ Store Address)
       4'b0001: Out = A - B; // SUB, BEQ and BNE
       4'b0010: Out = A & B; // AND, ANDI
       4'b0011: Out = A | B; // OR, ORI
       4'b0100: Out = A ^ B; // XOR, XORI
       4'b0101: Out = ~ (A | B); // NOR
       4'b0110: Out = B << A[4:0]; // SLL, SLLV
       4'b0111: Out = B >> A[4:0]; // SRL, SRLV (fills with 0)
       4'b1000: begin // SLT, SLTI
        if ($signed(A) < $signed(B))
          Out = 32'b1;
          else
        Out = 32'b0;
        end
      4'b1001: Out = $signed(B) >>> A[4:0]; // SRA, SRAV
      4'b1010: Out = A; // Pass A
      4'b1011: Out = B; // Pass B (LUI)
      4'b1100: Out = A; // MOVN: rt-check done outside the ALU
      4'b1101: Out = A; // MOVZ: rt-check done outside the ALU
      default: Out = 32'b0;
    endcase 
  end

  assign LE = ($signed(Out) < 0);
  assign EQ = (Out == 32'b0);
  assign GT = ($signed(Out) > 0);

endmodule

/* test for the system */

// module tb_alu_test;
//   reg [31:0] RA;
//   reg [31:0] RB;
//   reg [4:0] SA;
//   reg [15:0] I;
//   reg OS1;
//   reg [1:0] OS2;
//   reg [3:0] OP;
//   reg [31:0] A;
//   reg [31:0] B;
//   wire [31:0] Out;
//   wire LE;
//   wire EQ;
//   wire GT;
//   wire [31:0] OA;
//   wire [31:0] OB;

// alu u_alu (.A(OA), .B(OB), .OP(OP), .GT(GT), .EQ(EQ), .LE(LE), .Out(Out));
// foh u_foh (.RA(RA), .SA(SA), .OS1(OS1), .OA(OA));
// soh u_soh (.RB(RB), .I(I), .OS2(OS2), .OB(OB));

// initial begin
//   $monitor("OP=%b Out=%b LE=%b EQ=%b GT=%b", OP, Out, LE, EQ, GT);
//   RA = 32'b10011100000000000000000000100010;
//   RB = 32'b01110000000000000000000000000011;
//   SA = 5'b00101;
//   I = 16'b1111111111011000;

//   OS1 = 0; #2;
//   OS2 = 2'b00; #2; // In here we expect: OA = RA and OB = RB
//   OS2 = 2'b01; #2;  // expect OB = FFFFFFD8 (sign-extended I)
//   OS2 = 2'b10; #2;  // expect OB = FFD80000 (LUI-style)
//   OS1 = 1; #2;  // expect OA = 00000005

//     $finish;
//   end 
// endmodule 