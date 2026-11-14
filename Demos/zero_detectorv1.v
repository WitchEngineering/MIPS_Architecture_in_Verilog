module zero_detector (output reg Z, input [31:0] B);
  if (B | 32'b0) begin
      Z = 1'b01; // Esta mal porque, no se puede declarar de esta forma
    end else begin
      Z = 0'b0;
  end
endmodule

// $display("==test_zero_detector: Reductor ==");
// $monitor("r_or=%b r_and=%b r_nor=%b", r_or, r_and, LE, r_nor);
