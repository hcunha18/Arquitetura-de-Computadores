# Requisitos

Antes de executar o projeto é necessário instalar:

- Icarus Verilog
- GTKWave

---

# Instalação

## Windows

### 1. Instalar o Icarus Verilog

Faça o download do instalador em:

https://bleyer.org/icarus/

ou

https://github.com/steveicarus/iverilog/releases

Durante a instalação, habilite a opção para adicionar o Icarus Verilog ao **PATH** do Windows.

Após a instalação, abra o Prompt de Comando e execute:

```bash
iverilog -V
```

Se a instalação estiver correta, será exibida a versão instalada.

### 2. Instalar o GTKWave

Download:

https://gtkwave.sourceforge.net/

Após instalar, o comando abaixo deverá funcionar:

```bash
gtkwave
```

---

## Linux (Ubuntu/Debian)

Atualize os repositórios:

```bash
sudo apt update
```

Instale o Icarus Verilog:

```bash
sudo apt install iverilog
```

Instale o GTKWave:

```bash
sudo apt install gtkwave
```

Verifique a instalação:

```bash
iverilog -V
```

---

## Fedora

```bash
sudo dnf install iverilog
sudo dnf install gtkwave
```

---

## Arch Linux

```bash
sudo pacman -S iverilog
sudo pacman -S gtkwave
```

---

# Como executar

## Windows

Abra o Prompt de Comando na pasta do projeto.

Compile todos os arquivos:

```bash
iverilog -o cpu.out *.v
```

Execute a simulação:

```bash
vvp cpu.out
```

Será criado o arquivo:

```
cpu.vcd
```

Abra o GTKWave:

```bash
gtkwave cpu.vcd
```

ou abra o GTKWave manualmente e selecione o arquivo **cpu.vcd**.

---

## Linux

Entre na pasta do projeto:

```bash
cd nome_da_pasta
```

Compile:

```bash
iverilog -g2012 -o cpu.out *.v
```

Execute:

```bash
vvp cpu.out
```

Será criado:

```
cpu.vcd
```

Abra no GTKWave:

```bash
gtkwave cpu.vcd
```

---

# Saída esperada

Durante a execução, o terminal exibirá informações semelhantes às seguintes:

```text
------------------------------------------------
PC      : 00000000
Instr   : 2001000A

R0=0 R1=10 R2=0 R3=0
R4=0 R5=0 R6=0 R7=0

ALU=10

RegWrite=1 ALUSrc=1 Jump=0
------------------------------------------------
```

Ao final da execução, os registradores deverão possuir os seguintes valores:

| Registrador | Valor |
|-------------|------:|
| R0 | 0 |
| R1 | 10 |
| R2 | 20 |
| R3 | 30 |
| R4 | 14 |
| R5 | 30 |
| R6 | 0 |
| R7 | 1 |

---

# Estrutura esperada da pasta

```
Projeto/

├── cpu.v
├── alu.v
├── alu_control.v
├── control_unit.v
├── instruction_memory.v
├── register_file.v
├── sign_extend.v
├── zero_extend.v
├── pc.v
├── mux.v
├── testbench.v
├── program.mem
└── README.md
```

Todos os arquivos devem permanecer na mesma pasta para que o comando:

```verilog
$readmemh("program.mem", memory);
```

consiga localizar corretamente o programa de teste.