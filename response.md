# Análise da Simulação da CPU MIPS Monociclo

## Objetivo

Esta simulação demonstra a execução do programa de teste da CPU MIPS monociclo desenvolvida em Verilog para a Equipe B. Em cada ciclo de clock são exibidos o estado do processador, a instrução executada, os registradores e os principais sinais de controle.

---

# Estrutura da saída

Em cada ciclo são mostrados dois blocos de informações.

## Primeiro bloco

Exemplo:

```text
------------------------------------------------
PC      : 00000000
Instr    : 2001000a
R0=0 R1=10 R2=0 R3=0
R4=0 R5=0 R6=0 R7=0
ALU=10
RegWrite=1 ALUSrc=1 Jump=0
Opcode=001000
Funct=001010
ALUCtrl=0010
Zero=0
```

Este bloco mostra o estado interno da CPU logo após a execução da instrução.

### PC

```text
PC : 00000000
```

Indica o endereço da instrução atualmente executada.

Como cada instrução possui 4 bytes, o PC evolui da seguinte forma:

```text
0
4
8
12
16
20
28
...
```

Observe que após o Jump o PC passa de **0x14** para **0x1C**, pulando uma instrução.

---

### Instr

```text
Instr : 2001000a
```

É a instrução armazenada na memória de instruções em formato hexadecimal.

Por exemplo:

```
2001000A
```

corresponde a

```assembly
addi $1,$0,10
```

---

### Registradores

```text
R0=0 R1=10 R2=0 R3=0
```

Mostram o conteúdo atual do banco de registradores.

No primeiro ciclo:

- R1 recebeu o valor 10.
- Os demais ainda permanecem com zero.

---

### ALU

```text
ALU=10
```

Mostra o resultado produzido pela ALU naquela instrução.

No primeiro ciclo:

```
0 + 10 = 10
```

---

### RegWrite

```text
RegWrite=1
```

Indica se o resultado será gravado em algum registrador.

- 1 = grava
- 0 = não grava

---

### ALUSrc

```text
ALUSrc=1
```

Define de onde vem o segundo operando da ALU.

Quando vale:

```
0
```

A ALU usa outro registrador.

Quando vale

```
1
```

A ALU utiliza o imediato da instrução.

---

### Jump

```
Jump=0
```

Indica se o Program Counter será alterado para um endereço de salto.

No ciclo 6:

```
Jump=1
```

mostra que a instrução executada foi um Jump.

---

### Opcode

Exemplo

```
001000
```

É o código da instrução.

Tabela utilizada:

| Opcode | Instrução |
|---------|-----------|
|000000|Tipo R|
|001000|addi|
|001100|andi|
|001101|ori|
|000010|jump|

---

### Funct

O campo Funct só é utilizado pelas instruções Tipo R.

Por exemplo:

```
100000
```

significa

```
ADD
```

Enquanto

```
101010
```

significa

```
SLT
```

Nas instruções imediatas (addi, andi, ori) esse campo não possui significado, pois faz parte do imediato de 16 bits. Ele ainda aparece na impressão porque corresponde aos últimos 6 bits da instrução, mas é ignorado pela Unidade de Controle.

---

### ALUCtrl

Mostra qual operação foi enviada para a ALU.

No projeto:

|Código|Operação|
|------|---------|
|0010|ADD|
|0110|SUB|
|0000|AND|
|0001|OR|
|0111|SLT|

---

### Zero

Indica se o resultado produzido pela ALU foi zero.

```
Zero=1
```

Resultado igual a zero.

```
Zero=0
```

Resultado diferente de zero.

---

# Segundo bloco

Após cada execução também aparece um resumo.

Exemplo:

```text
Ciclo 3

PC = 00000008
Instrucao = 00221820
Opcode = 000000
Funct = 100000
RS=1 RT=2 RD=3

ALU Result = 30

RegWrite = 1

ALUSrc = 0

Jump = 0
```

Esse bloco facilita visualizar exatamente qual instrução foi executada naquele ciclo.

---

# Análise ciclo a ciclo

## Ciclo 1

```
Instr = 2001000A
```

Corresponde a

```assembly
addi $1,$0,10
```

Execução:

```
R1 = 10
```

Estado:

```
R1 = 10
```

---

## Ciclo 2

```
Instr = 20020014
```

Corresponde a

```assembly
addi $2,$0,20
```

Resultado

```
R2 = 20
```

---

## Ciclo 3

```
00221820
```

Corresponde a

```assembly
add $3,$1,$2
```

A ALU calcula

```
10 + 20
```

Resultado

```
R3 = 30
```

---

## Ciclo 4

```
3064000F
```

Corresponde a

```assembly
andi $4,$3,15
```

Operação

```
30 AND 15
```

Resultado

```
14
```

Logo

```
R4 = 14
```

---

## Ciclo 5

```
34850010
```

Corresponde a

```assembly
ori $5,$4,16
```

Operação

```
14 OR 16
```

Resultado

```
30
```

Logo

```
R5 = 30
```

---

## Ciclo 6

```
08000007
```

Corresponde a

```assembly
j alvo
```

Observe que

```
Jump = 1
```

O PC muda de

```
0x14
```

para

```
0x1C
```

Portanto a instrução

```assembly
addi $6,$0,99
```

foi ignorada.

Isso confirma que o Jump funcionou corretamente.

---

## Ciclo 7

```
0022382A
```

Corresponde a

```assembly
slt $7,$1,$2
```

Como

```
10 < 20
```

o resultado é

```
1
```

Logo

```
R7 = 1
```

---

# Por que aparecem vários ciclos com instrução 00000000?

A partir do ciclo 8 a memória de instruções não possui mais instruções válidas.

Assim, ela retorna

```
00000000
```

Como o testbench continua gerando clock até o final da simulação, a CPU continua buscando posições de memória vazias.

Isso é esperado e não representa erro de funcionamento.

Em um processador real haveria um mecanismo para interromper a execução (como uma instrução de parada ou uma chamada de sistema). Neste projeto, a simulação termina apenas quando o testbench executa o comando `$finish`.

---

# Resultado Final

Ao término da simulação os registradores apresentam:

|Registrador|Valor Esperado|Valor Obtido|
|-----------|-------------:|-----------:|
|R1|10|10|
|R2|20|20|
|R3|30|30|
|R4|14|14|
|R5|30|30|
|R6|0|0|
|R7|1|1|

Todos os valores coincidem com os resultados esperados para o programa de teste da Equipe B.

---

# Conclusão

A simulação comprova que a CPU executou corretamente todas as instruções previstas no trabalho:

- ✅ `addi`
- ✅ `add`
- ✅ `andi`
- ✅ `ori`
- ✅ `j`
- ✅ `slt`

Além disso, os sinais de controle (`RegWrite`, `ALUSrc`, `Jump` e `ALUCtrl`) apresentaram os valores esperados em cada ciclo, demonstrando que o datapath e a Unidade de Controle estão funcionando corretamente.