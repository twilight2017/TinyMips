`timescale 1ns / 1ps

`include "bus.v"

module ID_tb();

reg clk, rst;
integer tick;

initial begin
    clk=0;
    rst=1;
    #7 rst=0;
end
always begin
    #5 clk=~clk;
end

  wire                rom_en;
  wire[`MEM_SEL_BUS]  rom_write_en;
  wire[`ADDR_BUS]     rom_addr;
  wire[`DATA_BUS]     rom_read_data, rom_write_data;
  wire                ram_en;
  wire[`MEM_SEL_BUS]  ram_write_en;
  wire[`ADDR_BUS]     ram_addr;
  wire[`DATA_BUS]     ram_read_data, ram_write_data;
  wire                debug_reg_write_en;
  wire[`REG_ADDR_BUS] debug_reg_write_addr;
  wire[`DATA_BUS]     debug_reg_write_data;
  wire[`ADDR_BUS]     debug_pc_addr;

  Core core(
    .clk                  (clk),
    .rst                  (rst),
    .stall                (0),

    .rom_en               (rom_en),
    .rom_write_en         (rom_write_en),
    .rom_addr             (rom_addr),
    .rom_read_data        (rom_read_data),
    .rom_write_data       (rom_write_data),

    .ram_en               (ram_en),
    .ram_write_en         (ram_write_en),
    .ram_addr             (ram_addr),
    .ram_read_data        (ram_read_data),
    .ram_write_data       (ram_write_data),

    .debug_reg_write_en   (debug_reg_write_en),
    .debug_reg_write_addr (debug_reg_write_addr),
    .debug_reg_write_data (debug_reg_write_data),
    .debug_pc_addr        (debug_pc_addr)
  );

  RAM ram(
    .clk            (clk),
    .ram_en         (ram_en),
    .ram_write_en   (ram_write_en),
    .ram_addr       (ram_addr),
    .ram_write_data (ram_write_data),
    .ram_read_data  (ram_read_data)
  );

  ROM rom(
    .clk            (clk),
    .rom_en         (rom_en),
    .rom_write_en   (rom_write_en),
    .rom_addr       (rom_addr),
    .rom_write_data (rom_write_data),
    .rom_read_data  (rom_read_data)
  );
endmodule