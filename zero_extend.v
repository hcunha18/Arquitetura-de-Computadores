`timescale 1ns / 1ps

//============================================================
// Zero Extend
// Projeto: Processador MIPS Monociclo Simplificado
// Equipe B
//
// Responsável por realizar a extensão com zeros de um
// imediato de 16 bits para 32 bits.
//
// Utilizado pelas instruções:
// - andi
// - ori
//============================================================

module zero_extend(

    input  wire [15:0] in,
    output wire [31:0] out

);

//============================================================
// Extensão com Zeros
//============================================================
//
// Os 16 bits superiores são preenchidos com zero,
// independentemente do valor do bit mais significativo.
//
// Exemplo:
//
// Entrada:
//      1111 1111 1111 0000
//
// Saída:
//      0000 0000 0000 0000
//      1111 1111 1111 0000
//
//============================================================

assign out = {16'b0000000000000000, in};

endmodule