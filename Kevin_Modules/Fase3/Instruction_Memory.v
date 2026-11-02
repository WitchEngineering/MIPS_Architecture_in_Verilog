module instruction_memory (
    input [8:0] A,
    output [31:0] I
);

    reg [7:0] mem [0:511];

    initial
        $readmemb("Memory_Preload.txt", mem);

    assign I = {mem[A], mem[A+1], mem[A+2], mem[A+3]};
endmodule