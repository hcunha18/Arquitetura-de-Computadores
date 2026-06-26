# Processador MIPS Monociclo Simplificado – Equipe B

**Disciplina:** Arquitetura de Computadores  
**Trabalho Prático:** Implementação de um Processador MIPS Monociclo Simplificado em Verilog HDL  
**Equipe:** B – Imediatos e Jump

---

# Objetivo

Este projeto implementa um **processador MIPS monociclo simplificado** em **Verilog HDL**, baseado na arquitetura apresentada por Patterson & Hennessy.

A implementação contempla o caminho de dados (Datapath), Unidade de Controle, Banco de Registradores, ALU, Memória de Instruções e os demais módulos necessários para executar um subconjunto das instruções MIPS.

O projeto foi desenvolvido para ser compatível com:

- Icarus Verilog
- GTKWave
- Simulação em ambiente Windows ou Linux

---

# Instruções implementadas

## Tipo R

| Instrução | Função |
|-----------|---------|
| add | Soma |
| sub | Subtração |
| and | AND lógico |
| or | OR lógico |
| slt | Set Less Than |

## Tipo I

| Instrução | Função |
|-----------|---------|
| addi | Soma com imediato (extensão de sinal) |
| andi | AND com imediato (extensão com zeros) |
| ori | OR com imediato (extensão com zeros) |

## Tipo J

| Instrução | Função |
|-----------|---------|
| j | Jump |

---

# Arquitetura

O projeto foi organizado em módulos independentes.

```
                +-------------------+
                |        PC         |
                +---------+---------+
                          |
                          v
              +-----------------------+
              | Instruction Memory    |
              +-----------+-----------+
                          |
                          v
              +-----------------------+
              |    Control Unit       |
              +-----------+-----------+
                          |
                          |
        +-----------------+------------------+
        |                                    |
        v                                    v
+---------------+                 +------------------+
| Register File |                 | Sign/Zero Extend |
+-------+-------+                 +--------+---------+
        |                                  |
        +------------+   +------------------+
                     |   |
                     v   v
                    +-----+
                    | ALU |
                    +--+--+
                       |
                       v
                 Write Back
```

---

# Estrutura do projeto

```
cpu.v
alu.v
alu_control.v
control_unit.v
instruction_memory.v
register_file.v
sign_extend.v
zero_extend.v
pc.v
mux.v
testbench.v
program.mem
README.md
```

---

# Descrição dos módulos

## cpu.v

Módulo principal do processador.

Responsável por integrar todos os demais módulos e realizar a execução das instruções.

---

## pc.v

Implementa o Program Counter.

Funções:

- armazenar o endereço atual
- incrementar o PC
- atualizar o endereço após Jump

---

## instruction_memory.v

Memória somente leitura.

Carrega o programa através de:

```verilog
$readmemh("program.mem", memory);
```

---

## control_unit.v

Decodifica o opcode e gera os sinais de controle.

Sinais gerados:

- RegDst
- ALUSrc
- RegWrite
- Jump
- ZeroExt
- ALUOp

---

## alu_control.v

Traduz o sinal ALUOp e o campo funct nas operações da ALU.

Operações suportadas:

- ADD
- SUB
- AND
- OR
- SLT

---

## alu.v

Executa as operações aritméticas e lógicas.

Também gera o sinal:

```
Zero
```

---

## register_file.v

Banco de registradores contendo:

- 32 registradores
- 32 bits
- duas portas de leitura
- uma porta de escrita

O registrador:

```
$zero
```

permanece sempre igual a zero.

Também disponibiliza sinais de debug:

```
R0
R1
...
R7
```

---

## sign_extend.v

Realiza extensão de sinal para:

```
addi
```

---

## zero_extend.v

Realiza extensão com zeros para:

```
andi
ori
```

---

## mux.v

Multiplexador parametrizado.

É utilizado para:

- RegDst
- ALUSrc
- Jump

---

## testbench.v

Responsável por:

- gerar clock
- gerar reset
- criar arquivo VCD
- imprimir o estado da CPU
- finalizar a simulação

---

# Programa de teste

O arquivo:

```
program.mem
```

contém o seguinte programa:

```assembly
addi $1,$0,10
addi $2,$0,20
add  $3,$1,$2
andi $4,$3,15
ori  $5,$4,16
j alvo
addi $6,$0,99
alvo:
slt $7,$1,$2
```

---

# Resultado esperado

Ao término da execução:

| Registrador | Valor |
|--------------|-------|
| R0 | 0 |
| R1 | 10 |
| R2 | 20 |
| R3 | 30 |
| R4 | 14 |
| R5 | 30 |
| R6 | 0 |
| R7 | 1 |

---

# Compilação

## Windows

```bash
iverilog -o cpu.out *.v
```

## Linux

```bash
iverilog -g2012 -o cpu.out *.v
```

---

# Execução

```bash
vvp cpu.out
```

---

# Visualização das formas de onda

Após executar a simulação será criado:

```
cpu.vcd
```

Abrir no GTKWave:

```bash
gtkwave cpu.vcd
```

---

# Sinais disponíveis

Os principais sinais observáveis durante a simulação são:

- clk
- reset
- pc
- instruction
- opcode
- funct
- ALUControl
- alu_result
- Zero
- RegWrite
- ALUSrc
- Jump
- R0
- R1
- R2
- R3
- R4
- R5
- R6
- R7

---

# Fluxo de execução

1. O PC fornece o endereço da instrução.
2. A memória de instruções retorna a instrução correspondente.
3. A Unidade de Controle gera os sinais de controle.
4. O Banco de Registradores lê os operandos.
5. O imediato é estendido quando necessário.
6. A ALU executa a operação.
7. O resultado é escrito no banco de registradores.
8. O PC é atualizado para a próxima instrução ou para o endereço de Jump.

---

# Requisitos atendidos

- ✔ PC modular
- ✔ Banco de registradores com 32 registradores
- ✔ Registrador `$zero`
- ✔ Memória de instruções
- ✔ ALU
- ✔ Unidade de Controle
- ✔ ALU Control
- ✔ Extensão de sinal
- ✔ Extensão com zeros
- ✔ Jump
- ✔ Testbench
- ✔ Arquivo VCD
- ✔ Compatível com Icarus Verilog
- ✔ Compatível com GTKWave

---

# Referências

- Patterson, David A.; Hennessy, John L. **Computer Organization and Design: The Hardware/Software Interface**.
- Arquitetura MIPS32.
- Icarus Verilog.
- GTKWave.