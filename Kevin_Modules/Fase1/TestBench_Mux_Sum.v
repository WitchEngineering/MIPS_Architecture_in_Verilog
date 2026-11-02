module fetch_tb;

    //Señales que yo le pongo los valores van como reg
    reg [31:0] nPC_val;
    reg [31:0] TAI_val;
    reg J;

    //Señales que observo van como wire
    wire [31:0] sum_out;
    wire [31:0] mux_out;

    sum u_sum(
        .i(nPC_val),
        .R(sum_out)
    );

    mux u_mux (
        .A0(sum_out),
        .A1(TAI_val),
        .S(J),
        .O(mux_out)
    );

    initial begin
        nPC_val = 32'd0;
        TAI_val = 32'd100;
        J = 0;
        #10 nPC_val = 32'd4;
        #10 J = 1;
        #10 nPC_val = 32'd20;
        #10 $finish;
    end

    initial 
        $monitor("time=%0t nPC=%0d J=%b sum_out=%0d mux_out=%0d",  $time, nPC_val, J, sum_out, mux_out);

endmodule
