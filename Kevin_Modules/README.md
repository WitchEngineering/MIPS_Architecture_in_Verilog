# Como correr el ALU de FASE_I

- Por medio de cd entras al directorio "Oficial/ALU"
- Dentro del directorio corres los siguientes commandos

`iverilog -o sim_alu F1_Pagan_Villafane_Yasen_alu.v F1_Pagan_Villafane_Yasen_tbalu.v`

`vvp sim_alu`

# Como correr el CH (Condition Handler) del ALU

- Por medio de cd entras al directorio "Oficial/ALU"
- Dentro del directorio corres los siguientes commandos

`iverilog -o ch_sim -s tb_condition_handler F1_Pagan_Villafane_Yasen_alu.v CH_test_bench.v`

`vvp ch_sim`

# Como correr el Data Memory (con el Mux 3x1 de la etapa MEM)

- Por medio de cd entras al directorio "Oficial/DataMemory"
- Dentro del directorio corres los siguientes commandos (se tiene que correr desde ese directorio porque `Data_Preload.txt` se lee con un path relativo)

`iverilog -o dm_sim -s tb_data_memory Data_Memory.v Data_Memory_tb.v`

`vvp dm_sim`

# Como correr el CU de la FASE_III

- Por medio de cd entras al directorio llamado Kevin_Modules
- Ya dentro del directorio corres los siguientes commandos

Compilando el código: 
`iverilog -o sim.out Phase_Three_TestBench.v Control_Unit.v Mux_Phase_Three.v Pipeline_Register.v Instruction_Memory.v Modules.v`

Output del test_bench: 

`vvp sim.out`

