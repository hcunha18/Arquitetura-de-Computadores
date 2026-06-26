`timescale 1ns / 1ps

//============================================================
// Register File
// Projeto: Processador MIPS Monociclo Simplificado
// Equipe B
//
// Características:
// - 32 registradores de 32 bits
// - 2 portas de leitura
// - 1 porta de escrita
// - Escrita sincronizada ao clock
// - Registrador $zero sempre igual a 0
//============================================================

module register_file(

    input wire clk,
    input wire RegWrite,

    input wire [4:0] read_reg1,
    input wire [4:0] read_reg2,

    input wire [4:0] write_reg,
    input wire [31:0] write_data,

    output wire [31:0] read_data1,
    output wire [31:0] read_data2,

    //========================================================
    // Saídas de depuração (GTKWave)
    //========================================================

    output wire [31:0] r0_debug,
    output wire [31:0] r1_debug,
    output wire [31:0] r2_debug,
    output wire [31:0] r3_debug,
    output wire [31:0] r4_debug,
    output wire [31:0] r5_debug,
    output wire [31:0] r6_debug,
    output wire [31:0] r7_debug

);

//============================================================
// Banco de Registradores
//============================================================

reg [31:0] registers [0:31];

//============================================================
// Inicialização
//============================================================

integer i;

initial begin

    for(i = 0; i < 32; i = i + 1)
        registers[i] = 32'd0;

end

//============================================================
// Leitura Assíncrona
//============================================================

assign read_data1 = registers[read_reg1];
assign read_data2 = registers[read_reg2];

//============================================================
// Escrita Síncrona
//============================================================

always @(posedge clk)
begin

    if(RegWrite) begin

        // O registrador $zero nunca pode ser alterado.
        if(write_reg != 5'd0)
            registers[write_reg] <= write_data;

    end

    // Garante que $zero permaneça igual a zero.
    registers[0] <= 32'd0;

end

//============================================================
// Saídas de Debug
//============================================================

assign r0_debug = registers[0];
assign r1_debug = registers[1];
assign r2_debug = registers[2];
assign r3_debug = registers[3];
assign r4_debug = registers[4];
assign r5_debug = registers[5];
assign r6_debug = registers[6];
assign r7_debug = registers[7];

endmodule