module test_RegisterFile;

    
    reg  [31:0] PW;
    reg  [4:0]  RA, RB, RW;
    reg         LE, CLK;

  
    wire [31:0] PA, PB;

  
    RegisterFile RF (PA, PB, PW, RA, RB, RW, LE, CLK);

    
    initial begin
        CLK = 1'b0;
        forever #2 CLK = ~CLK;
    end


    initial begin
        LE = 1'b1;
        PW = 32'd30;
        RW = 5'd0;
        RA = 5'd0;
        RB = 5'd31;

       
        repeat (31) begin
            #4  PW = PW + 1;
                RW = RW + 1;
                RA = RA + 1;
                RB = RB + 1;   
        end

       
        #4  LE = 1'b0;
            PW = 32'd55;
            RW = 5'd0;
            RA = 5'd0;
            RB = 5'd31;

        
        repeat (4) begin
            #4  PW = PW + 1;
                RW = RW + 1;
                RA = RA + 1;
                RB = RB + 1;
        end

        #4  $finish;
    end

    initial begin
        $display("  Time  LE   RA   RB   RW     PW           PA           PB");
        $monitor("%5d   %b  %3d  %3d  %3d  %5d  %11d  %11d",
                 $time, LE, RA, RB, RW, PW, PA, PB);
    end

endmodule
