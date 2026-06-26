`timescale 1ns / 1ps

//============================================================
// ALU Control
// Projeto: Processador MIPS Monociclo Simplificado
// Equipe B
//
// Responsável por converter:
//
//      ALUOp + Funct
//
// em um código de controle para a ALU.
//
// Códigos da ALU:
//
// 0000 -> AND
// 0001 -> OR
// 0010 -> ADD
// 0110 -> SUB
// 0111 -> SLT
//============================================================

module alu_control(

    input  wire [1:0] ALUOp,
    input  wire [5:0] funct,

    output reg  [3:0] ALUControl

);

//============================================================
// Decodificação
//============================================================

always @(*) begin

    case(ALUOp)

        //====================================================
        // 00 -> Soma
        // Utilizado por:
        // addi
        //====================================================
        2'b00:
            ALUControl = 4'b0010;

        //====================================================
        // 01 -> AND
        // Utilizado por:
        // andi
        //====================================================
        2'b01:
            ALUControl = 4'b0000;

        //====================================================
        // 10 -> OR
        // Utilizado por:
        // ori
        //====================================================
        2'b10:
            ALUControl = 4'b0001;

        //====================================================
        // 11 -> Tipo R
        //====================================================
        2'b11:
        begin

            case(funct)

                // add
                6'b100000:
                    ALUControl = 4'b0010;

                // sub
                6'b100010:
                    ALUControl = 4'b0110;

                // and
                6'b100100:
                    ALUControl = 4'b0000;

                // or
                6'b100101:
                    ALUControl = 4'b0001;

                // slt
                6'b101010:
                    ALUControl = 4'b0111;

                default:
                    ALUControl = 4'b0010;

            endcase

        end

        default:
            ALUControl = 4'b0010;

    endcase

end

endmodule