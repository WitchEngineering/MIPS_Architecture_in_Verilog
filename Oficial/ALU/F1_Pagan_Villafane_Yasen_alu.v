/*=========================================================
Made by: Yasen A. Pagán Villafañe
Note: Code (English)
      Notes on top: (Spanish)

Initial value of the inputs: 

  RA = 10011100000000000000000000100010;
  RB = 01110000000000000000000000000011;
  SA = 00101;
  I = 1111111111011000;
  OS1= 0;
  OS2= 00;

  Unidades de tiempo: #2;

  ---

  RA = Registro A (32 bits)
  SA = Número de desplazamientos (5 bits)
  OS1 = Fist Operand Selector
  RB = Regsitro B (32 bits)
  I = immediate integer (16 bits)
  OS2 = Second Operand Selector (2 bits)
  OP = Código que indica la operación que debe realizar el ALU (4 bits)
  - Especifica un maximo de 16 operaciones
  - Es possible no tener que implementar 16 funciones
  Out = Resultado de operación del ALU (32 bits)

  ---

  Flags: 

  GT = Less than condition bit (1 bit)
  EQ = Equal condition bit (1 bit)
  LE = Less than condition bit (1 bit)

*/

//==============================================================================================//

/* ALU, FOH & SOH */ 

module foh (output reg [31:0] OA, input [31:0] RA, input [4:0] SA, input OS1);
  // assign OA  (this can't be done as it wires expression permanently with no block involved)
  always @(*) begin
    if (!OS1) // If it's not 0 = OA = RA (based on spec)
      OA = RA;
    else // If 1 then OA stacks 27 bit worth of 0 and SA's 4 bits to form a wider signal.
      OA = {27'b0, SA};
  end
endmodule

module soh (output reg [31:0] OB, input [31:0] RB, input [15:0] I, input [1:0] OS2);
  always @(*) begin
    case (OS2)
      2'b00: OB = RB; // Directly uses the RB 
      2'b01: OB = {{16{I[15]}}, I}; // Extended (I) by 16 bits (lower) 
      2'b10: OB = {I, 16'b0}; // LUI (takes I and adds 16 zeros to it (upper) (el hueso))
      // 2'b11: (Not used)
      default: 
      OB = 32'b0; // Saves all the other unused instructions
    endcase
  end
endmodule

module alu (output reg [31:0] Out, input [3:0] OP, output reg GT, output reg EQ, output reg LE, input [31:0] A, input [31:0] B);
  always @(*) begin
    case (OP)
       4'b0000: Out = A + B; // ADD, ADDI
       4'b0001: Out = A - B; // SUB, BEQ and BNE
       4'b0010: Out = A & B; // AND, ANDI
       4'b0011: Out = A | B; // OR, ORI
       4'b0100: Out = A ^ B; // XOR, XORI
       4'b0101: Out = ~ (A | B); // NOR
       4'b0110: Out = B << A[4:0]; // SLL, SLLV (left shift)
       4'b0111: Out = B >> A[4:0]; // SRL, SRLV (right shift)
       4'b1000: begin // SLT, SLTI
        if ($signed(A) < $signed(B))
          Out = 32'b1;
          else
        Out = 32'b0;
        end
      4'b1001: Out = $signed(B) >>> A[4:0]; // SRA, SRAV (Arithmetic right shift)
      4'b1010: Out = A; // Pass A
      4'b1011: Out = B; // Pass B (passes what is already done in LUI)
      4'b1100: Out = A; // MOVN
      4'b1101: Out = A; // MOVZ
      default: Out = 32'b0;
    endcase 
    // Fixed Added: Instead of assign each flag. Make
    // Each flag output reg and put it at the bottom
      LE = ($signed(Out) < 0);
      EQ = (Out == 32'b0);
      GT = ($signed(Out) > 0);
  end  
endmodule

// Zero Detector, 2x1 Multiplexer, CH