// Run from this folder:
// iverilog -o ch_sim -s tb_condition_handler F1_Pagan_Villafane_Yasen_alu.v CH_test_bench.v
// vvp ch_sim

module tb_condition_handler;
  // Inputs
  reg MV;
  reg BI;
  reg RF_LE;
  reg Z;
  reg [2:0] cond;

  // Flags (the 3 flags that the ALU sends to the CH as ACC)
  reg LE;
  reg EQ;
  reg GT;
  wire [2:0] ACC = {LE, EQ, GT}; // CC[2:0] in the diagram

  // Outputs
  wire J;
  wire RF_LE_OU;
  wire ch_LE;
  wire ch_EQ;
  wire ch_GT;

  condition_handler u_ch (.J(J), .MV(MV), .Z(Z), .RF_LE_OU(RF_LE_OU), .RF_LE(RF_LE), .BI(BI), .cond(cond), .ACC(ACC), .LE(ch_LE), .EQ(ch_EQ), .GT(ch_GT));

  initial begin
    $dumpfile("CH_test_bench.vcd");
    $dumpvars(0, tb_condition_handler);

    $display("==test_5: CH ==");
    $monitor("%0t BI=%b MV=%b cond=%b LE=%b EQ=%b GT=%b Z=%b RF_LE=%b -> J=%b RF_LE_OU=%b", $time, BI, MV, cond, LE, EQ, GT, Z, RF_LE, J, RF_LE_OU);

    MV = 0; BI = 0; RF_LE = 0; Z = 0; cond = 3'b000;
    LE = 0; EQ = 0; GT = 0;
    #2;

    // Idle (BI = 0, MV = 0): J = 0 and RF_LE passes to RF_LE_OU
    $display("-- Idle: expect J=0, RF_LE_OU = RF_LE --");
    RF_LE = 1; #2;
    RF_LE = 0; #2;

    // Branches (BI = 1): RF_LE = 1 to see that RF_LE_OU is not touched
    BI = 1; MV = 0; RF_LE = 1;

    $display("-- BEQ (000): expect J=1 only when EQ --");
    cond = 3'b000;
    LE = 0; EQ = 1; GT = 0; #2; // J=1
    LE = 1; EQ = 0; GT = 0; #2; // J=0
    LE = 0; EQ = 0; GT = 1; #2; // J=0

    $display("-- BNE (001): expect J=1 when not EQ --");
    cond = 3'b001;
    LE = 0; EQ = 1; GT = 0; #2; // J=0
    LE = 1; EQ = 0; GT = 0; #2; // J=1
    LE = 0; EQ = 0; GT = 1; #2; // J=1

    $display("-- BLEZ (010): branch if <= 0 --");
    cond = 3'b010;
    // TODO: test the 3 flag combinations (LE, EQ, GT) for BLEZ and write the J you expect next to each one
    

    $display("-- BGTZ (011): expect J=1 only when GT --");
    cond = 3'b011;
    LE = 0; EQ = 1; GT = 0; #2; // J=0
    LE = 1; EQ = 0; GT = 0; #2; // J=0
    LE = 0; EQ = 0; GT = 1; #2; // J=1

    $display("-- BLTZ (100): expect J=1 only when LE --");
    cond = 3'b100;
    LE = 0; EQ = 1; GT = 0; #2; // J=0
    LE = 1; EQ = 0; GT = 0; #2; // J=1
    LE = 0; EQ = 0; GT = 1; #2; // J=0

    $display("-- BGEZ (101): expect J=1 when GT or EQ --");
    cond = 3'b101;
    LE = 0; EQ = 1; GT = 0; #2; // J=1
    LE = 1; EQ = 0; GT = 0; #2; // J=0
    LE = 0; EQ = 0; GT = 1; #2; // J=1

    $display("-- BI with unused cond (110, 111): expect J=0 --");
    LE = 0; EQ = 1; GT = 0;
    cond = 3'b110; #2;
    cond = 3'b111; #2;

    // Conditional moves (MV = 1): J must stay 0
    BI = 0; MV = 1;
    LE = 1; EQ = 0; GT = 0;

    $display("-- MOVZ (110): expect RF_LE_OU = Z --");
    cond = 3'b110;
    RF_LE = 1; Z = 1; #2; // RF_LE_OU=1
    RF_LE = 1; Z = 0; #2; // RF_LE_OU=0
    RF_LE = 0; Z = 1; #2; // RF_LE_OU=1

    $display("-- MOVN (111): expect RF_LE_OU = ~Z --");
    cond = 3'b111;
    RF_LE = 1; Z = 1; #2; // RF_LE_OU=0
    RF_LE = 1; Z = 0; #2; // RF_LE_OU=1
    RF_LE = 0; Z = 0; #2; // RF_LE_OU=1

    $display("-- MV with a non-move cond (000): expect RF_LE_OU=0 --");
    RF_LE = 1; cond = 3'b000; #2;

    $display("-- BI and MV both 1: BI has priority (BEQ with EQ) --");
    BI = 1; MV = 1; RF_LE = 1; Z = 0; cond = 3'b000;
    LE = 0; EQ = 1; GT = 0; #2; // J=1, RF_LE_OU=1

    $finish;
  end
endmodule
