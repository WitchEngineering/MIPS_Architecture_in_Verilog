// Only need signed SLT which covers both SLT and SLTI

// Today we will do: The FOH and the SOH (unless the ALU is more simple)

// Prueba: 

module test_foh_2x1;
  reg[2:0] I;         // Las señales de exitación deben de ser tipo reg.
  wire OA;            // Salida debe ser tipo wire (OA = A en el ALU)
  wire Y;
  parameter sim_time = 100;
  test_foh_2x1 foh (Y,I[2],I[1],I[0]);
  initial #sim_time $finish;
  initial begin
  I = 3'b000;   // generando combinaciones ne la entrada.
  repeat (7)#101; // Cada 10 unidades de tiempo 
  end
  initial begin
  $display(" S  A  B  Y "); // header
  $monitor(" %b %b %b %b ", I[2], I[1], I[0], Y); // Imprime las señales
  end
endmodule

// module  mux_2x1 (output reg Y, input S, A, B);
// // Note: SA = B y RA = A

// always @ (S, A, B)

//   if (S) S = B;
//   else S = A;

// endmodule

