`timescale 1ns / 1ps

module cpu(
    input clk,
    input reset
);

//====================================================
// Program Counter
//====================================================

wire [31:0] pc;
wire [31:0] next_pc;

//====================================================
// Program Counter
//====================================================

pc PC(

    .clk(clk),
    .reset(reset),

    .next_pc(next_pc),

    .current_pc(pc)

);

//====================================================
// Instruction
//====================================================

wire [31:0] instruction;

instruction_memory IM(
    .address(pc),
    .instruction(instruction)
);

//====================================================
// Campos da instrução
//====================================================

wire [5:0] opcode;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [5:0] funct;
wire [15:0] immediate;
wire [25:0] jump_address;

assign opcode       = instruction[31:26];
assign rs           = instruction[25:21];
assign rt           = instruction[20:16];
assign rd           = instruction[15:11];
assign immediate    = instruction[15:0];
assign funct        = instruction[5:0];
assign jump_address = instruction[25:0];

//====================================================
// Unidade de Controle
//====================================================

wire RegDst;
wire ALUSrc;
wire RegWrite;
wire Jump;
wire ExtOp;
wire ZeroExt;
wire [1:0] ALUOp;

control_unit CU(
    .opcode(opcode),

    .RegDst(RegDst),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .Jump(Jump),

    .ExtOp(ExtOp),
    .ZeroExt(ZeroExt),

    .ALUOp(ALUOp)
);

//====================================================
// Banco de Registradores
//====================================================

wire [4:0] write_reg;

mux #(.WIDTH(5)) RegDstMUX(

    .input0(rt),
    .input1(rd),

    .sel(RegDst),

    .out(write_reg)

);

wire [31:0] read_data1;
wire [31:0] read_data2;
wire [31:0] write_data;

//====================================================
// Registradores de Debug
//====================================================

wire [31:0] r0_debug;
wire [31:0] r1_debug;
wire [31:0] r2_debug;
wire [31:0] r3_debug;
wire [31:0] r4_debug;
wire [31:0] r5_debug;
wire [31:0] r6_debug;
wire [31:0] r7_debug;

register_file RF(

    .clk(clk),
    .RegWrite(RegWrite),

    .read_reg1(rs),
    .read_reg2(rt),

    .write_reg(write_reg),
    .write_data(write_data),

    .read_data1(read_data1),
    .read_data2(read_data2),

    .r0_debug(r0_debug),
    .r1_debug(r1_debug),
    .r2_debug(r2_debug),
    .r3_debug(r3_debug),
    .r4_debug(r4_debug),
    .r5_debug(r5_debug),
    .r6_debug(r6_debug),
    .r7_debug(r7_debug)

);

//====================================================
// Extensão do imediato
//====================================================

wire [31:0] sign_ext_imm;
wire [31:0] zero_ext_imm;
wire [31:0] immediate_ext;

sign_extend SE(
    .in(immediate),
    .out(sign_ext_imm)
);

zero_extend ZE(
    .in(immediate),
    .out(zero_ext_imm)
);

assign immediate_ext =
    ZeroExt ? zero_ext_imm :
    ExtOp   ? sign_ext_imm :
              32'b0;

//====================================================
// Entrada da ALU
//====================================================

wire [31:0] alu_input_b;

mux ALUSrcMUX(

    .input0(read_data2),
    .input1(immediate_ext),

    .sel(ALUSrc),

    .out(alu_input_b)

);

//====================================================
// Controle da ALU
//====================================================

wire [3:0] alu_control_signal;

alu_control AC(

    .ALUOp(ALUOp),
    .funct(funct),

    .ALUControl(alu_control_signal)
);

//====================================================
// ALU
//====================================================

wire [31:0] alu_result;
wire zero;

alu ALU(

    .A(read_data1),
    .B(alu_input_b),

    .ALUControl(alu_control_signal),

    .Result(alu_result),
    .Zero(zero)
);

//====================================================
// Write Back
//====================================================

assign write_data = alu_result;

//====================================================
// Atualização do PC
//====================================================

wire [31:0] pc_plus4;
wire [31:0] jump_target;

assign pc_plus4 = pc + 32'd4;

// Endereço do jump:
// { PC+4[31:28], instr[25:0], 2'b00 }

assign jump_target = {
    pc_plus4[31:28],
    jump_address,
    2'b00
};

mux JumpMUX(

    .input0(pc_plus4),
    .input1(jump_target),

    .sel(Jump),

    .out(next_pc)

);

//====================================================
// Saídas de Debug
//====================================================

always @(negedge clk)
begin

    if(!reset)
    begin

        $display("------------------------------------------------");

        $display("PC      : %h", pc);
        $display("Instr    : %h", instruction);

        $display("R0=%0d R1=%0d R2=%0d R3=%0d",
            r0_debug,
            r1_debug,
            r2_debug,
            r3_debug
        );

        $display("R4=%0d R5=%0d R6=%0d R7=%0d",
            r4_debug,
            r5_debug,
            r6_debug,
            r7_debug
        );

        $display("ALU=%0d", alu_result);

        $display("RegWrite=%b ALUSrc=%b Jump=%b",
            RegWrite,
            ALUSrc,
            Jump
        );

        $display("Opcode=%b", opcode);
        $display("Funct=%b", funct);
        $display("ALUCtrl=%b", alu_control_signal);
        $display("Zero=%b", zero);

    end

end

endmodule