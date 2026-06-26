`timescale 1ns / 1ps

//============================================================
// Testbench
// Projeto: Processador MIPS Monociclo Simplificado
// Equipe B
//
// Compatível com:
// - Icarus Verilog
// - GTKWave
//============================================================

module testbench;

//============================================================
// Clock e Reset
//============================================================

reg clk;
reg reset;

//============================================================
// Instância da CPU
//============================================================

cpu DUT (

    .clk(clk),
    .reset(reset)

);

//============================================================
// Clock (10 ns)
//============================================================

initial begin

    clk = 1'b0;

    forever
        #5 clk = ~clk;

end

//============================================================
// Reset
//============================================================

initial begin

    reset = 1'b1;

    #20;

    reset = 1'b0;

end

//============================================================
// Geração do arquivo VCD
//============================================================

initial begin

    $dumpfile("cpu.vcd");

    $dumpvars(0, testbench);

end

//============================================================
// Contador de ciclos
//============================================================

integer ciclo = 0;

//============================================================
// Impressão textual
//============================================================

always @(posedge clk)
begin

    if(!reset)
    begin

        ciclo = ciclo + 1;

        $display("--------------------------------------------------");
        $display("Ciclo %0d", ciclo);

        $display("PC          = %h", DUT.pc);
        $display("Instrucao   = %h", DUT.instruction);

        $display("Opcode      = %b", DUT.opcode);
        $display("Funct       = %b", DUT.funct);

        $display("RS=%0d RT=%0d RD=%0d",
                  DUT.rs,
                  DUT.rt,
                  DUT.rd);

        $display("ALU Result  = %d", DUT.alu_result);

        $display("RegWrite    = %b", DUT.RegWrite);
        $display("ALUSrc      = %b", DUT.ALUSrc);
        $display("Jump        = %b", DUT.Jump);

        //----------------------------------------------------
        // Caso o cpu.v seja atualizado para expor os sinais
        // de debug do banco de registradores, descomente:
        //----------------------------------------------------

        /*
        $display(
            "R0=%0d R1=%0d R2=%0d R3=%0d",
            DUT.r0_debug,
            DUT.r1_debug,
            DUT.r2_debug,
            DUT.r3_debug
        );

        $display(
            "R4=%0d R5=%0d R6=%0d R7=%0d",
            DUT.r4_debug,
            DUT.r5_debug,
            DUT.r6_debug,
            DUT.r7_debug
        );
        */

    end

end

//============================================================
// Tempo total da simulação
//============================================================

initial begin

    // Executa 20 ciclos
    #220;

    $display("");
    $display("==============================================");
    $display("SIMULACAO FINALIZADA");
    $display("==============================================");

    $finish;

end

endmodule