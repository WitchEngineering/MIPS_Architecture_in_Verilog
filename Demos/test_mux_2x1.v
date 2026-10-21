module test_mux_2x1;
reg [2:0] i; //Las señales de excitación deben ser tipo reg
wire Y; //Las salidas deben ser tipo wire
parameter sim_time = 100; //Declaración de una constante
mux_2x1 mux1 (Y, i[2], i[1], i[0]); // Instanciación del módulo del Mux

initial #sim_time $finish; // Especifica cuando termina simulación

initial begin
  i = 3'b000; // Genera las combinaciones de las entradas
  repeat (7)#101 = i + 3'b001; // cada 10 unidades de tiempo
end
initial begin
$display ("' S A B Y");
//imprime header
$monitor (" %b %b %b %b ", i[2], i[1], i[0], Y); //imprime las señales
end
endmodule