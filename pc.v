`timescale 1ns / 1ps

//============================================================
// Program Counter (PC)
// Projeto: Processador MIPS Monociclo Simplificado
// Equipe B
//
// Responsável por armazenar o endereço da próxima instrução.
//
// Características:
// - Atualização na borda de subida do clock
// - Reset assíncrono
// - Inicialização em 0
//============================================================

module pc(

    input wire clk,
    input wire reset,

    input wire [31:0] next_pc,

    output reg [31:0] current_pc

);

//============================================================
// Atualização do PC
//============================================================

always @(posedge clk or posedge reset)
begin

    if(reset)
        current_pc <= 32'd0;
    else
        current_pc <= next_pc;

end

endmodule