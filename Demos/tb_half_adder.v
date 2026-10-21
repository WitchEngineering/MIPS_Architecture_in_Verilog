module half_adder;

  reg x, y; // Mis entradas (inputs)
  wire S, C; // Los outputs

  half_adder uut (.S(S), .C(C), .x(x), .y(y));

endmodule