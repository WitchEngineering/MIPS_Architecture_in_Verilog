# Como correr el CU de la FASE_III

- Por medio de cd entras al directorio llamado Kevin_Modules
- Ya dentro del directorio corres los siguientes commandos

Compilando el código: 
`iverilog -o sim.out Phase_Three_TestBench.v Control_Unit.v Mux_Phase_Three.v Pipeline_Register.v Instruction_Memory.v Modules.v`

Output del test_bench: 

`vvp sim.out`

