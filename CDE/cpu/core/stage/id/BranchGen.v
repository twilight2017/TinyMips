`timescale 1ns / 1ps

`include "bus.v"
`include "opcode.v"
`include "funct.v"

module BranchGen(
  input       [`ADDR_BUS]     addr,
  input       [`INST_BUS]     inst,
  input       [`INST_OP_BUS]  op,
  input       [`FUNCT_BUS]    funct,
  input       [`DATA_BUS]     reg_data_1,
  input       [`DATA_BUS]     reg_data_2,
  output  reg                 branch_flag,
  output  reg [`ADDR_BUS]     branch_addr
);

  wire[`ADDR_BUS] addr_plus_4 = addr + 4;
  wire[25:0] jump_addr = inst[25:0];
  wire[`DATA_BUS] sign_ext_imm_sll2 = {{14{inst[15]}}, inst[15:0], 2'b00};  //������λ�����offset�ķ�����չ����

  always @(*) begin
    case (op)
      `OP_JAL: begin
        branch_flag <= 1;
        branch_addr <= {addr_plus_4[31:28], jump_addr, 2'b00};
      end
      `OP_J: begin
        branch_flag <= 1;
        branch_addr <= {addr_plus_4[31:28], jump_addr, 2'b00};
        end
      `OP_SPECIAL: begin
        if (funct == `FUNCT_JALR) begin
          branch_flag <= 1;
          branch_addr <= reg_data_1;
        end
        else if (funct == `FUNCT_JR) begin
          branch_flag <= 1;
          branch_addr <= reg_data_1;//��ת��ַΪrs�Ĵ����е�ֵ
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
      end
      `OP_BEQ: begin
        if (reg_data_1 == reg_data_2) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
      end
      `OP_BLTZ,`OP_BGEZ: begin
      if(inst[20:16] == 5'b00000)begin
            if ($signed(reg_data_1) < $signed(0)) begin
              branch_flag <= 1;
              branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
            end
            else begin
              branch_flag <= 0;
              branch_addr <= 0;
            end
        end
        else if(inst[20:16] == 5'b00001)begin//BGEZ
            if ($signed(reg_data_1) >= $signed(0)) begin
              branch_flag <= 1;
              branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
            end
        else begin
              branch_flag <= 0;
              branch_addr <= 0;
            end
        end
      end     
       `OP_BLEZ: begin
        if ($signed(reg_data_1) <= $signed(reg_data_2)) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
      end
      `OP_BGTZ: begin
        if ($signed(reg_data_1) > $signed(reg_data_2)) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
      end
      `OP_BNE: begin
        if (reg_data_1 != reg_data_2) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
      end
      default: begin
        branch_flag <= 0;
        branch_addr <= 0;
      end
    endcase
  end

endmodule // BranchGen
