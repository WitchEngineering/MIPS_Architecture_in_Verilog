module data_memory(input [31:0] DI, input [8:0] A, input [1:0] Size, input SE, input RW, input E, output reg [31:0] DO);

  reg [7:0] Mem [0:511];

// Reading Operation 
  always @(*) begin

    DO = 32'b0; // Default: no read (RW = 1), avoids a latch

    if (RW == 0 && SE == 0) begin
    case (Size)
        2'b00: DO = {24'b0, Mem[A]};
        2'b01: DO = {16'b0, Mem[A], Mem [A + 1]};
        2'b10: DO = {Mem[A], Mem[A + 1], Mem[A + 2], Mem[A + 3]};
        default: DO = 32'b0;
      endcase
    end 

    if (RW == 0 && SE == 1) begin
      case (Size)
        2'b00: DO = $signed(Mem[A]);
        2'b01: DO = $signed({Mem[A], Mem[A + 1]});
        2'b10: DO = {Mem[A], Mem[A + 1], Mem[A + 2], Mem[A + 3]};
        default: DO = 32'b0;
      endcase
    end
  end

  // Writing Operation
  // RW = 1, E = 0 is no operation
  always @(*) begin

    if (RW == 1 && E == 1) begin
      case (Size)
        2'b00: Mem[A] = DI[7:0];
        2'b01: {Mem[A], Mem[A + 1]} = DI[15:0];
        2'b10: {Mem[A], Mem[A + 1], Mem[A + 2], Mem[A + 3]} = DI;
      endcase
    end
  end
endmodule

// 3x1 Multiplexer that has O = MEM_PD in the PPU 
module multiplexer_3x1 (input [31:0] Zero, input [31:0] One, input L, output reg [31:0] MEM_PD);
  always @(*) begin
    if (L == 1'b0)
      MEM_PD = Zero;
    else
      MEM_PD = One;
    end
endmodule