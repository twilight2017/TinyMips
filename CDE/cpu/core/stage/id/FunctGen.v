`timescale 1ns / 1ps

`include "bus.v"
`include "opcode.v"
`include "funct.v"

module FunctGen(
  input       [`INST_OP_BUS]  op,
  input       [`FUNCT_BUS]    funct_in,
  output  reg [`FUNCT_BUS]    funct
);

  // generating FUNCT signal in order for the ALU to perform operations
  always @(*) begin
    case (op)
      `OP_SPECIAL: funct <= funct_in;
      `OP_LUI: funct <= `FUNCT_OR;
      `OP_LB, `OP_LBU, `OP_LW, `OP_LH,`OP_LHU,
      `OP_SB, `OP_SW,`OP_SH,`OP_ADDIU: funct <= `FUNCT_ADDU;//funct字段是为了在EX.v中区分不同的逻辑操作,因此需要对具有相同逻辑操作的指令进行合并
      `OP_JAL,`OP_ORI: funct <= `FUNCT_OR;
      `OP_SLTI:funct <= `FUNCT_SLT;
      `OP_SLTIU:funct <= `FUNCT_SLTU;
      `OP_ANDI:funct <= `FUNCT_AND;
      `OP_XORI:funct <= `FUNCT_XOR;
      default: funct <= `FUNCT_NOP;
    endcase
  end

endmodule // FunctGen
