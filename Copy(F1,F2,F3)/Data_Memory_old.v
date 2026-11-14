
module data_memory(input [31:0] DI, input [8:0] A, input [1:0] Size, input SE, input RW, input E, output reg [31:0] DO);

reg [7:0] Mem [0:511];
always @(*) begin
  // Reading Operation
  if (RW == 0 & SE == 0) begin
    if (Size == 2'b01)
      DO = {16'b0, Mem[A], Mem [A + 1]};
    else if (Size == 2'b10)
      DO = {Mem[A], Mem[A + 1], Mem[A + 2], Mem[A + 3]};
    else
      DO = {24'b0, Mem[A]};
    end

  if (RW == 0 & SE == 1) begin
    if (Size == 2'b01)
      DO = $signed({Mem[A], Mem[A + 1]}); // singextented-halfword
    else if (Size == 2'b10)
      DO = $signed({Mem[A], Mem[A + 1], Mem[A + 2], Mem[A + 3]});
    else
      DO = $signed(Mem[A]);
    end

  // Writing Operation

end
endmodule
