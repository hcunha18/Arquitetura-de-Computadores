# Relatório Técnico – Processador MIPS Monociclo Simplificado

## Arquitetura de Computadores

**Trabalho Prático:** Implementação de um Processador MIPS Monociclo Simplificado em Verilog HDL

**Equipe:** B – Imediatos e Jump

---

# 1. Introdução

Este trabalho teve como objetivo implementar um processador MIPS monociclo simplificado utilizando a linguagem Verilog HDL, inspirado na arquitetura apresentada por Patterson & Hennessy. O projeto foi desenvolvido de forma modular, permitindo a separação das principais unidades funcionais do processador, como o Contador de Programa (Program Counter), Memória de Instruções, Banco de Registradores, Unidade de Controle, Unidade Lógica e Aritmética (ALU), Extensão de Imediatos e Controle da ALU.

O processador executa uma instrução completa a cada ciclo de clock (arquitetura monociclo), sendo capaz de executar instruções dos tipos R, I e J previstas para a Equipe B do trabalho.

---

# 2. Arquitetura implementada

A CPU foi dividida em módulos independentes, facilitando a organização, manutenção e testes do projeto.

## Diagrama simplificado do Datapath

```text
                    +-------------------+
                    | Program Counter   |
                    +---------+---------+
                              |
                              v
                  +-----------------------+
                  | Instruction Memory    |
                  +-----------+-----------+
                              |
                              v
                  +-----------------------+
                  |   Control Unit        |
                  +-----------+-----------+
                              |
             +----------------+----------------+
             |                                 |
             v                                 v
     +---------------+               +----------------+
     | Register File |               | Sign/Zero Ext. |
     +-------+-------+               +--------+-------+
             |                                |
             +---------------+----------------+
                             |
                             v
                           +-----+
                           | ALU |
                           +--+--+
                              |
                              v
                        Write Back
                              |
                              v
                     Register File
```

O Program Counter (PC) fornece o endereço da próxima instrução. A Memória de Instruções retorna a instrução correspondente, que é decodificada pela Unidade de Controle. O Banco de Registradores fornece os operandos para a ALU. Quando necessário, o imediato é estendido para 32 bits utilizando extensão de sinal ou extensão com zeros. O resultado produzido pela ALU é gravado novamente no Banco de Registradores.

---

# 3. Módulos implementados

O projeto foi dividido nos seguintes módulos:

| Módulo               | Responsabilidade                        |
| -------------------- | --------------------------------------- |
| cpu.v                | Integra todos os módulos do processador |
| pc.v                 | Implementa o Program Counter            |
| instruction_memory.v | Armazena o programa em memória ROM      |
| register_file.v      | Banco de registradores de 32 × 32 bits  |
| control_unit.v       | Geração dos sinais de controle          |
| alu_control.v        | Seleção da operação da ALU              |
| alu.v                | Operações aritméticas e lógicas         |
| sign_extend.v        | Extensão de sinal para `addi`           |
| zero_extend.v        | Extensão com zeros para `andi` e `ori`  |
| mux.v                | Multiplexadores do datapath             |
| testbench.v          | Ambiente de simulação                   |

---

# 4. Instruções implementadas

Foram implementadas todas as instruções exigidas para a Equipe B.

## Instruções Tipo R

| Instrução | Operação                      |
| --------- | ----------------------------- |
| add       | Soma entre registradores      |
| sub       | Subtração entre registradores |
| and       | AND lógico                    |
| or        | OR lógico                     |
| slt       | Comparação "menor que"        |

## Instruções Tipo I

| Instrução | Operação                                       |
| --------- | ---------------------------------------------- |
| addi      | Soma com imediato utilizando extensão de sinal |
| andi      | AND utilizando extensão com zeros              |
| ori       | OR utilizando extensão com zeros               |

## Instrução Tipo J

| Instrução | Operação                                   |
| --------- | ------------------------------------------ |
| j         | Desvio incondicional para um novo endereço |

---

# 5. Tabela simplificada de sinais de controle

| Instrução | RegDst | ALUSrc | RegWrite | Jump | ZeroExt | ALUOp |
| --------- | :----: | :----: | :------: | :--: | :-----: | :---: |
| add       |    1   |    0   |     1    |   0  |    0    |   10  |
| sub       |    1   |    0   |     1    |   0  |    0    |   10  |
| and       |    1   |    0   |     1    |   0  |    0    |   10  |
| or        |    1   |    0   |     1    |   0  |    0    |   10  |
| slt       |    1   |    0   |     1    |   0  |    0    |   10  |
| addi      |    0   |    1   |     1    |   0  |    0    |   00  |
| andi      |    0   |    1   |     1    |   0  |    1    |   11  |
| ori       |    0   |    1   |     1    |   0  |    1    |   11  |
| j         |    X   |    X   |     0    |   1  |    X    |   XX  |

Legenda:

* **RegDst:** seleciona o registrador de destino (`rd` ou `rt`).
* **ALUSrc:** seleciona o segundo operando da ALU (registrador ou imediato).
* **RegWrite:** habilita a escrita no banco de registradores.
* **Jump:** atualiza o PC com o endereço de salto.
* **ZeroExt:** seleciona entre extensão de sinal e extensão com zeros.
* **ALUOp:** define a operação executada pela ALU.

---

# 6. Programa de teste

Foi utilizado o programa proposto no enunciado:

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

O programa foi convertido para hexadecimal e armazenado no arquivo `program.mem`, sendo carregado automaticamente pela memória de instruções através da função `$readmemh`.

---

# 7. Resultados obtidos

Após a execução completa do programa, foram obtidos os seguintes valores:

| Registrador | Valor Esperado | Valor Obtido |
| ----------- | -------------: | -----------: |
| R1          |             10 |           10 |
| R2          |             20 |           20 |
| R3          |             30 |           30 |
| R4          |             14 |           14 |
| R5          |             30 |           30 |
| R6          |              0 |            0 |
| R7          |              1 |            1 |

Os resultados demonstram que:

* a extensão de sinal foi executada corretamente pela instrução `addi`;
* a extensão com zeros funcionou corretamente nas instruções `andi` e `ori`;
* o cálculo do endereço de salto (`Jump`) foi realizado corretamente, fazendo com que a instrução `addi $6,$0,99` fosse ignorada;
* a operação `slt` retornou o valor esperado, indicando que `10 < 20`.

---

# 8. Simulação

A validação do projeto foi realizada utilizando:

* Icarus Verilog para compilação e execução;
* GTKWave para análise das formas de onda.

Durante a simulação foram observados:

* evolução do Program Counter;
* instrução corrente;
* opcode;
* funct;
* sinais de controle;
* resultado da ALU;
* registradores R0 a R7.

Essas informações permitiram verificar o correto funcionamento do datapath e da unidade de controle.

---

# 9. Dificuldades encontradas

Durante o desenvolvimento do projeto foram identificados alguns desafios importantes.

O primeiro desafio consistiu na correta implementação do caminho de dados, garantindo que cada módulo recebesse e enviasse os sinais apropriados. Pequenos erros nas conexões poderiam impedir a execução correta das instruções.

Outro ponto relevante foi a implementação das instruções imediatas. Foi necessário compreender a diferença entre extensão de sinal (`addi`) e extensão com zeros (`andi` e `ori`), uma vez que ambas utilizam imediatos de 16 bits, mas possuem comportamentos distintos.

Também houve atenção especial ao cálculo do endereço de salto (`Jump`), que exige a concatenação dos quatro bits mais significativos de `PC + 4`, dos 26 bits do endereço da instrução e de dois bits menos significativos iguais a zero.

Por fim, a criação do ambiente de testes utilizando um `testbench` permitiu validar o funcionamento da CPU por meio da geração de arquivos VCD e da observação dos sinais no GTKWave.

---

# 10. Conclusão

O objetivo do trabalho foi alcançado com sucesso por meio da implementação de um processador MIPS monociclo simplificado capaz de executar instruções dos tipos R, I e J previstas para a Equipe B.

A divisão do projeto em módulos independentes tornou o código mais organizado, reutilizável e de fácil manutenção. A utilização do Icarus Verilog e do GTKWave permitiu validar o funcionamento do processador e confirmar que todas as instruções implementadas produziram os resultados esperados.

O desenvolvimento deste projeto possibilitou compreender, na prática, o funcionamento interno de um processador monociclo, reforçando conceitos fundamentais de arquitetura de computadores, como datapath, unidade de controle, banco de registradores, ALU e atualização do Program Counter.

---

# Referências

* Patterson, D. A.; Hennessy, J. L. *Computer Organization and Design: The Hardware/Software Interface*.
* Documentação da arquitetura MIPS32.
* Icarus Verilog.
* GTKWave.
