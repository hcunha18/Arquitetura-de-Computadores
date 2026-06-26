`timescale 1ns / 1ps

//============================================================
// Sign Extend
// Projeto: Processador MIPS Monociclo Simplificado
// Equipe B
//
// Responsável por realizar a extensão de sinal de um
// imediato de 16 bits para 32 bits.
//
// Utilizado pela instrução:
// - addi
//============================================================

module sign_extend(

    input  wire [15:0] in,
    output wire [31:0] out

);

//============================================================
// Extensão de Sinal
//============================================================
//
// Se o bit mais significativo (bit 15) for:
//
// 0 -> completa os 16 bits superiores com 0.
//
// Exemplo:
//      0000 0000 0000 1010
//
// Resultado:
//
//      0000 0000 0000 0000
//      0000 0000 0000 1010
//
//------------------------------------------------------------
//
// Se o bit 15 for:
//
// 1 -> completa os 16 bits superiores com 1.
//
// Exemplo:
//
//      1111 1111 1111 1100 (-4)
//
// Resultado:
//
//      1111 1111 1111 1111
//      1111 1111 1111 1100
//
//============================================================

assign out = {{16{in[15]}}, in};

endmodule