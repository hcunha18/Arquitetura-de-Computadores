`timescale 1ns / 1ps

//============================================================
// ALU - Arithmetic Logic Unit
// Projeto: Processador MIPS Monociclo Simplificado
// Equipe B
//
// Operações implementadas:
//
// 0000 -> AND
// 0001 -> OR
// 0010 -> ADD
// 0110 -> SUB
// 0111 -> SLT
//============================================================

module alu(

    input  wire [31:0] A,
    input  wire [31:0] B,

    input  wire [3:0] ALUControl,

    output reg  [31:0] Result,
    output wire Zero

);

//============================================================
// Unidade Lógica e Aritmética
//============================================================

always @(*) begin

    case(ALUControl)

        // AND
        4'b0000:
            Result = A & B;

        // OR
        4'b0001:
            Result = A | B;

        // ADD
        4'b0010:
            Result = A + B;

        // SUB
        4'b0110:
            Result = A - B;

        // SLT (Set Less Than - comparação com sinal)
        4'b0111:
            Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;

        // Operação inválida
        default:
            Result = 32'd0;

    endcase

end

//============================================================
// Sinal ZERO
//============================================================

assign Zero = (Result == 32'd0);

endmodule