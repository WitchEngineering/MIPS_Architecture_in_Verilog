// Half_Adder as I have seen.

// How it is shown to me the first time.

/*
module h*lf_adder (output S, C, input x, y);
xor (S, x, y);
and (C, x, y);
endmodule
*/

/* Lo que se quiera probar o alimentar se decalra con (reg) 
lo que se quiere sacar o lo que se quiere observar es declarando
(wire)
*/

module half_adder;

  reg x, y; // Mis entradas (inputs)
  wire S, C; // Los outputs

    // instantiate the module under test, connecting ports by name
  half_adder uut (.S(S), .C(C), .x(x), .y(y));

  initial begin
    $display("xy | SC");
    x = 0; y = 0; #3 $display("%b%b | %b$b", x, y, S, C);
    x = 0; y = 1; #3 $display("%b%b | %b$b", x, y, S, C);
    x = 1; y = 0; #3 $display("%b%b | %b$b", x, y, S, C);
    x = 1; y = 1; #3 $display("%b%b | %b$b", x, y, S, C);

  end
endmodule