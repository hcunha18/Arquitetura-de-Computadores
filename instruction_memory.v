`timescale 1ns / 1ps

//============================================================
// Instruction Memory
// Projeto: Processador MIPS Monociclo Simplificado
// Equipe B
//
// Características:
// - Memória somente leitura (ROM)
// - 256 instruções de 32 bits
// - Endereçamento por palavra
// - Carregamento via $readmemh
//============================================================

module instruction_memory(

    input  wire [31:0] address,
    output wire [31:0] instruction

);

//============================================================
// Memória de Instruções
//============================================================

reg [31:0] memory [0:255];

//============================================================
// Inicialização
//============================================================

integer i;

initial begin

    // Inicializa toda a memória com NOP (0x00000000)
    for(i = 0; i < 256; i = i + 1)
        memory[i] = 32'h00000000;

    // Carrega o programa de teste
    // O arquivo "program.mem" será criado posteriormente.
    $readmemh("program.mem", memory);

end

//============================================================
// Leitura Assíncrona
//============================================================

// O PC é incrementado de 4 em 4.
// Como cada instrução possui 4 bytes,
// utilizamos address[31:2] para indexar a memória.

assign instruction = memory[address[31:2]];

endmodule