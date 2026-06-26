`timescale 1ns / 1ps

//============================================================
// Multiplexador 2:1 Parametrizável
// Projeto: Processador MIPS Monociclo Simplificado
// Equipe B
//
// Características:
// - Largura configurável por parâmetro
// - Padrão: 32 bits
// - Pode ser utilizado para:
//
//   • ALUSrc
//   • RegDst
//   • Jump
//   • WriteBack
//============================================================

module mux #(parameter WIDTH = 32)

(

    input  wire [WIDTH-1:0] input0,
    input  wire [WIDTH-1:0] input1,

    input  wire sel,

    output wire [WIDTH-1:0] out

);

assign out = (sel) ? input1 : input0;

endmodule