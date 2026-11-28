module condition_handler (
    output J,
    output RF_LE_OU,
    input  BI,
    input  RF_LE,
    input  [1:0] MV,       // 00 none, 01 MOVN, 10 MOVZ
    input  Z,
    input  [2:0] cond,     // mask [LE, EQ, GT]
    input  [2:0] ACC       // {LE, EQ, GT}
);
    wire taken = |(cond & ACC);
    assign J = BI & taken;

    // BI: write survives only if the branch is taken (BGEZAL/BLTZAL)
    // MV: MOVZ writes if Z=1, MOVN writes if Z=0
    assign RF_LE_OU = BI         ? (RF_LE & taken) :
                    (MV==2'b10) ? (RF_LE & Z)     :
                    (MV==2'b01) ? (RF_LE & ~Z)    :
                                RF_LE;
endmodule