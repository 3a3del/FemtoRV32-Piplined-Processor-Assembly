`timescale 1ns / 1ps
module MENWB_tb(
    input clk,
    input rst,
    input memtoreg_IDEX_out,
    input regwrite_IDEX_out,
    input memread_IDEX_out,
    input memwrite_IDEX_out,
    input [1:0] AJ_control_IDEX_out,
    input [31:0] ALU_result,
    input [31:0] RD2_output,
    input [3:0] function3_out_IDEX_out,
    input [4:0] WData_IDEX_out,
    input [31:0] adder1_IDEX,
    input [31:0] adder2_EXMEM,
    output [31:0] regwrite_MEM_outt
);

// Concatenated control signals
wire [5:0] ex_mem_controls = {
    memtoreg_IDEX_out,
    regwrite_IDEX_out,
    memread_IDEX_out,
    memwrite_IDEX_out,
    AJ_control_IDEX_out
};

// Wire declarations
wire sclk;
wire [31:0] dataMem_out;

// Instantiate clock divider
CLK_divid div(clk, rst, sclk);

// Intermediate signals between pipeline stages
wire memtoreg_MEMEX_out, regwrite_MEMEX_out, memread_MEMEX_out, memwrite_MEMEX_out;
wire [1:0] AJ_control_MEMEX_out;
wire [31:0] ALU_result_MEMEX_out, readdata2_MEMEX_out, adder1_IDEX_MEM, adder2_MEM;
wire [4:0] WData_MEMEX_out;
wire [3:0] function3_out_MEMEX_out;

// Pipeline register EX_MEM
PIPI_REG #(143) EX_MEM (
    clk, rst, 1'b1,
    {ex_mem_controls, ALU_result, RD2_output, function3_out_IDEX_out, WData_IDEX_out, adder1_IDEX, adder2_EXMEM},

    {memtoreg_MEMEX_out, regwrite_MEMEX_out, memread_MEMEX_out, memwrite_MEMEX_out, AJ_control_MEMEX_out,
     ALU_result_MEMEX_out, readdata2_MEMEX_out, function3_out_MEMEX_out, WData_MEMEX_out, adder1_IDEX_MEM, adder2_MEM}
);

// Instantiate DataMemory
DataMemory datamem(
    sclk, ALU_result_MEMEX_out[7:2], memread_MEMEX_out, memwrite_MEMEX_out, 
    readdata2_MEMEX_out, function3_out_MEMEX_out[2:0], dataMem_out
);

// Signals between MEM and WB stages
wire regwrite_MEM_out, memtoreg_MEM_out;
wire [31:0] dataMem_out_MEM_out, ALU_result_MEM_out, adder1_IDEX_WB, adder2_WB;
wire [4:0] WData_MEM_out;
wire [1:0] AJ_control_MEM_out;

// Pipeline register MEM_WB
PIPI_REG #(137) MEM_WB (
    clk, rst, 1'b1,
    {regwrite_MEMEX_out, memtoreg_MEMEX_out, dataMem_out, ALU_result_MEMEX_out, WData_MEMEX_out, 
     AJ_control_MEMEX_out, adder1_IDEX_MEM, adder2_MEM},
    {regwrite_MEM_out, memtoreg_MEM_out, dataMem_out_MEM_out, ALU_result_MEM_out, 
     WData_MEM_out, AJ_control_MEM_out, adder1_IDEX_WB, adder2_WB}
);

// Signal for writing data
wire [31:0] writingData;

// Multiplexer to select between ALU result and data memory output
mux32Bit mux3(ALU_result_MEM_out, dataMem_out_MEM_out, memtoreg_MEM_out, writingData);

// Four-way multiplexer for final data to be written to the register file
FourMux WD_mux(
    adder2_WB, adder1_IDEX_WB, writingData, AJ_control_MEM_out, regwrite_MEM_outt
);

endmodule

