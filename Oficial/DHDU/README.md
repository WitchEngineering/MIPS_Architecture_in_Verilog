# DHDU y los dos mux de forwarding

**Alejandro Rodriguez Burgos** — Fase IV

Estas dos piezas son el mecanismo de forwarding a y b del PPU. El **DHDU decide**
de dónde tiene que venir cada operando y los **mux lo traen**.

## Archivos

| Archivo | Qué es |
|---|---|
| `F4_Rodriguez_Burgos_Alejandro_DHDU.v` | Circuito del Data Hazard Detection Unit 
| `F4_Rodriguez_Burgos_Alejandro_fwd_mux.v` | Circuito  mux 4x1 de 32 bits 
| `F4_Rodriguez_Burgos_Alejandro_tbDHDU.v` | Test bench del DHDU
| `F4_Rodriguez_Burgos_Alejandro_tbfwd_mux.v` | Test bench del DHDU + multiplexer

## Cómo correrlos

iverilog -o /tmp/s F4_Rodriguez_Burgos_Alejandro_DHDU.v F4_Rodriguez_Burgos_Alejandro_tbDHDU.v && vvp /tmp/s



iverilog -o /tmp/s F4_Rodriguez_Burgos_Alejandro_fwd_mux.v F4_Rodriguez_Burgos_Alejandro_DHDU.v F4_Rodriguez_Burgos_Alejandro_tbfwd_mux.v && vvp /tmp/s


## Qué hace el DHDU

Compara los registros fuente de la instrucción que está en ID (`RA` y `RB`)
contra el registro destino de las instrucciones que van adelante en EX, MEM y
WB. Si alguna de ellas va a escribir un registro que la instrucción en ID
necesita leer, el Register File entregaría el valor viejo — eso es un data
hazard. El DHDU levanta `A_S` o `B_S` para indicar de qué etapa hay que tomar
el valor bueno.

La evaluación va en **cascada: primero EX, si no MEM, si no WB**. El orden
importa porque hay que agarrar el valor más reciente: si el mismo registro se
escribió en varias instrucciones seguidas, el bueno es el de EX.

**Codificación de `A_S` / `B_S`:**

| Valor | Significa |
|---|---|
| `00` | No hay hazard — usar el Register File |
| `01` | Hazard con la instrucción en EX |
| `10` | Hazard con la instrucción en MEM |
| `11` | Hazard con la instrucción en WB |

### El caso que el forwarding no resuelve

Cuando la instrucción en EX es un **load**, su operando destino no sale del ALU
sino de la memoria en MEM — o sea que todavía no existe y no se puede
forwardear. Ahí hay que detener el pipeline un ciclo:

- `LE = 0` → se congelan el PC, el nPC y el IF/ID
- `NOP = 1` → se inyecta un NOP a la etapa EX

Es el único caso donde se pierde un ciclo. Mientras se maneja este hazard, el
DHDU **no** evalúa los hazards normales de `RA` y `RB`.


## Qué hacen los mux

Dos mux 4x1 de 32 bits, uno por operando, a la derecha del Register File. Cada
uno escoge entre cuatro fuentes y el select se lo da el DHDU.

Es **un solo módulo instanciado dos veces**: el de arriba con `A_S` para el
primer operando y el de abajo con `B_S` para el segundo. Lo único distinto
entre los dos es la entrada `I0` (`PA` vs `PB`) y el select.


## Cómo se cablean en el top-level

```verilog
DHDU dhdu (
    .A_S(A_S), .B_S(B_S), .NOP(NOP), .LE(LE),

    .RA(ID_I[25:21]),          // campo rs de la instruccion en ID
    .RB(ID_I[20:16]),          // campo rt
    .SR(ID_SR),                // del Control Unit, {SRA, SRB}

    .EX_L(EX_L),               // la L a la salida del ID/EX

    .EX_RD(EX_RD),   .MEM_RD(MEM_RD),   .WB_RD(WB_RD),
    .EX_RF_LE(EX_RF_LE_OU),
    .MEM_RF_LE(MEM_RF_LE_OU),
    .WB_RF_LE(WB_RF_LE_OU)
);

mux4x1 #(32) mux_A (.O(PA_fwd), .I0(PA), .I1(EX_MUX_ALU),
                    .I2(MEM_PD), .I3(WB_PD), .S(A_S));

mux4x1 #(32) mux_B (.O(PB_fwd), .I0(PB), .I1(EX_MUX_ALU),
                    .I2(MEM_PD), .I3(WB_PD), .S(B_S));
                    

`PA_fwd` y `PB_fwd` entran al ID/EX y salen como `EX_PA` y `EX_PB`.

Las salidas `NOP` y `LE` van:

- `NOP` → al `S` del mux de las señales de control (el que inyecta el NOP al ID/EX)
- `LE` → al `LE` del PASG (que maneja el PC, el nPC y el IF/ID)



## ⚠️ Dos trampas al cablear

### 1. La entrada `I1` es `EX_MUX_ALU`, no `EX_ALU_OU`

En el diagrama del PPU el punto de unión del forwarding está a la **salida del
mux del Link**, no antes:

```
EX_ALU_OU ──→ [0]
                 mux Link ──→ EX_MUX_ALU ──┬──→ EX/MEM
EX_PC8    ──→ [1]                          │
                   ↑ LINK                  └──→ a las entradas I1 de los mux
```

Tiene que ser así porque para **BAL, JAL, JALR, BGEZAL y BLTZAL** el operando
destino es **PC+8**, no el resultado del ALU. Si se forwardea el ALU directo,
esas cinco instrucciones forwardean basura — y `BAL`, `JR r31` y
`ADD r31,r31,r8` están en el segundo programa de prueba.

### 2. Los `RF_LE` que entran al DHDU son los `_OU`, los del CH

`RF_LE_OU` es el `RF_LE` ya cancelado por el Condition Handler cuando la
condición de un brinco no se dio. Si se usa el `RF_LE` crudo del Control Unit,
el DHDU va a forwardear desde una instrucción que al final no escribe nada.

---

# El código por dentro

## `F4_Rodriguez_Burgos_Alejandro_DHDU.v`

### Los puertos

```verilog
output reg [1:0] A_S, B_S;     // selects para los dos mux
output reg       NOP, LE;      // el stall
input      [4:0] RA, RB;       // registros fuente de la instruccion en ID
input      [1:0] SR;           // del Control Unit
input            EX_L;         // 1 si la instruccion en EX es un load
input      [4:0] EX_RD, MEM_RD, WB_RD;          // destinos adelante
input            EX_RF_LE, MEM_RF_LE, WB_RF_LE; // cuales de ellas escriben
```

No tiene `Clk` ni `Reset`: es **puramente combinacional**. Todo sale de un solo
`always @(*)`.

### Desempaquetar el SR

```verilog
wire SRA = SR[1];
wire SRB = SR[0];
```

El Control Unit manda las dos banderas juntas en un bus de 2 bits. `SRA` dice
si la instrucción lee `rs`, `SRB` si lee `rt`. Se separan aquí para que el
resto del código se lea claro.

**Por qué importan:** sin ellas el DHDU forwardearía a instrucciones que ni
siquiera usan ese operando. Un `LUI`, por ejemplo, no lee `rs` — si `SRA` no
existiera y el campo `rs` coincidiera por casualidad con un destino adelante,
se forwardearía un valor a un operando que no se usa.

### Lo primero que se evalúa: el load-use

```verilog
if (EX_L & ((SRA & (RA == EX_RD)) | (SRB & (RB == EX_RD)))) begin
    LE  = 1'b0;
    NOP = 1'b1;
    A_S = 2'b00;
    B_S = 2'b00;
end
```

Se lee: *si en EX hay un load **y** su destino es uno de los registros que yo
necesito leer, entonces paro el pipeline.*

Va **primero**, antes que todo lo demás, porque cuando este hazard se da no
tiene sentido evaluar los normales — el valor no existe en ninguna etapa
todavía. Por eso los dos selects se ponen en `00`.

### La detección normal

```verilog
else begin
    LE  = 1'b1;
    NOP = 1'b0;

    if (SRA) begin
        if      (EX_RF_LE  & (RA == EX_RD))  A_S = 2'b01;
        else if (MEM_RF_LE & (RA == MEM_RD)) A_S = 2'b10;
        else if (WB_RF_LE  & (RA == WB_RD))  A_S = 2'b11;
        else                                 A_S = 2'b00;
    end
    else A_S = 2'b00;
```

Cada condición tiene **dos partes** unidas por `&`:

1. `EX_RF_LE` — que esa instrucción **de verdad escriba** un registro. Si no
   escribe (un `SW`, un brinco), su campo `RD` no significa nada y compararlo
   sería un error.
2. `RA == EX_RD` — que escriba **justo el registro** que yo voy a leer.

El `else if` encadenado es lo que implementa la prioridad: en cuanto una
coincide, las demás ni se evalúan. Y están en orden EX → MEM → WB, de la más
reciente a la más vieja.

El bloque de `RB` con `B_S` es exactamente igual. Son independientes: un
operando puede venir de WB y el otro de EX en el mismo ciclo.

### Por qué cada rama asigna siempre

Todas las ramas terminan con un `else` que asigna `00`, y el `else A_S = 2'b00`
de afuera cubre el caso `SRA = 0`. En un `always @(*)` toda señal tiene que
recibir valor en **todos** los caminos posibles; si no, Verilog infiere un
latch — memoria donde debería haber lógica combinacional pura.

---

## `F4_Rodriguez_Burgos_Alejandro_fwd_mux.v`

```verilog
module mux4x1 #(parameter N = 32)
    (output reg [N-1:0] O,
     input [N-1:0] I0, I1, I2, I3,
     input [1:0] S);

    always @ (*)
        case (S)
            2'b00: O = I0;
            2'b01: O = I1;
            2'b10: O = I2;
            2'b11: O = I3;
        endcase

endmodule
```

Es un mux 4x1 normal. Tres cosas que vale saber:

**`#(parameter N = 32)`** — el ancho es parametrizado. Por defecto 32 bits, que
es lo que necesitan los operandos, pero el mismo módulo sirve para cualquier
ancho sin tocar el código.

**El `case` no lleva `default`** y no hace falta: `S` es de 2 bits, así que los
cuatro casos cubren todas las combinaciones posibles. No hay camino sin asignar
y por eso no se infiere latch.

**Los números del `case` son los mismos del DHDU.** El `2'b01` de aquí es el
mismo `2'b01` que el DHDU produce cuando detecta hazard con EX. Esa
correspondencia es lo que hace que las dos piezas encajen sin traducción.
