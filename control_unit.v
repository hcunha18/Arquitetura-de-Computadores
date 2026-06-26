`timescale 1ns / 1ps

//============================================================
// Control Unit
// Projeto: Processador MIPS Monociclo Simplificado
// Equipe B
//
// Instruções implementadas:
//
// Tipo R
// add
// sub
// and
// or
// slt
//
// Tipo I
// addi
// andi
// ori
//
// Tipo J
// j
//============================================================

module control_unit(

    input wire [5:0] opcode,

    output reg RegDst,
    output reg ALUSrc,
    output reg RegWrite,
    output reg Jump,

    output reg ExtOp,
    output reg ZeroExt,

    output reg [1:0] ALUOp

);

//============================================================
// Decodificação do Opcode
//============================================================

always @(*) begin

    //========================================================
    // Valores padrão (NOP)
    //========================================================

    RegDst   = 1'b0;
    ALUSrc   = 1'b0;
    RegWrite = 1'b0;
    Jump     = 1'b0;

    ExtOp    = 1'b0;
    ZeroExt  = 1'b0;

    ALUOp    = 2'b00;

    //--------------------------------------------------------
    // Decodificação
    //--------------------------------------------------------

    case(opcode)

        //====================================================
        // Tipo R
        // opcode = 000000
        //====================================================
        6'b000000:
        begin
            RegDst   = 1'b1;
            ALUSrc   = 1'b0;
            RegWrite = 1'b1;
            Jump     = 1'b0;

            ExtOp    = 1'b0;
            ZeroExt  = 1'b0;

            ALUOp    = 2'b11;
        end

        //====================================================
        // addi
        // opcode = 001000
        //====================================================
        6'b001000:
        begin
            RegDst   = 1'b0;
            ALUSrc   = 1'b1;
            RegWrite = 1'b1;
            Jump     = 1'b0;

            // extensão de sinal
            ExtOp    = 1'b1;
            ZeroExt  = 1'b0;

            ALUOp    = 2'b00;
        end

        //====================================================
        // andi
        // opcode = 001100
        //====================================================
        6'b001100:
        begin
            RegDst   = 1'b0;
            ALUSrc   = 1'b1;
            RegWrite = 1'b1;
            Jump     = 1'b0;

            // extensão com zeros
            ExtOp    = 1'b0;
            ZeroExt  = 1'b1;

            ALUOp    = 2'b01;
        end

        //====================================================
        // ori
        // opcode = 001101
        //====================================================
        6'b001101:
        begin
            RegDst   = 1'b0;
            ALUSrc   = 1'b1;
            RegWrite = 1'b1;
            Jump     = 1'b0;

            // extensão com zeros
            ExtOp    = 1'b0;
            ZeroExt  = 1'b1;

            ALUOp    = 2'b10;
        end

        //====================================================
        // Jump
        // opcode = 000010
        //====================================================
        6'b000010:
        begin
            RegDst   = 1'b0;
            ALUSrc   = 1'b0;
            RegWrite = 1'b0;
            Jump     = 1'b1;

            ExtOp    = 1'b0;
            ZeroExt  = 1'b0;

            ALUOp    = 2'b00;
        end

        //====================================================
        // Instrução inválida
        //====================================================
        default:
        begin
            RegDst   = 1'b0;
            ALUSrc   = 1'b0;
            RegWrite = 1'b0;
            Jump     = 1'b0;

            ExtOp    = 1'b0;
            ZeroExt  = 1'b0;

            ALUOp    = 2'b00;
        end

    endcase

end

endmodule