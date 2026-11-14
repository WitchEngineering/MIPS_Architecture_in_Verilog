wire [3:0] x = 4'b0100;

wire r_or = |x; // 0 | 1 | 0 | 0 = 1 
wire r_and  = &x;   // 0 & 1 & 0 & 0 = 0
wire r_nor  = ~|x;  // NOT de (OR de todos) = 0

$display("==test_A: Reductor ==");
$monitor("r_or=%b r_and=%b r_nor=%b", r_or, r_and, LE, r_nor);
