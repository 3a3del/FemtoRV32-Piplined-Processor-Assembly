`timescale 1ns / 1ps
// Data path module for a processor
// Connects various components including ALU, registers, memory, and multiplexers
module IF_ID(
    input clk,               // Clock signal for synchronous operations
    input rst,                // Reset signal for asynchronous reset
    input [4:0] WData_IDEX_out,
    input [31:0] PC_EXMEM,
    output [31:0] PCout_IFID_out,
    output [31:0]ints_out_out,
    output [31:0] adder1_IFID_out
);
wire PC_stall,IFID_write,MUXselect;
wire [31:0] PCout_IFID;
wire cout1_ripple1_IFID;
wire [31:0] adder1_IFID,ints_out;  reg Q; wire sclk;
////////////////////////////////////////////////////////////////////////
//IFID
// Program Counter (PC) register

CLK_divid div(clk,rst,sclk );

OneReg pc(sclk, rst, ~PC_stall, PC_EXMEM, PCout_IFID); 

hazardunit Hazard_unit(ints_out_out[19:15],ints_out_out[11:7],ints_out_out[24:20],
                     memread_ID_ex,PC_stall,IFID_write,MUXselect); //memread_ID_ex

// Adder to increment PC by 4
AluAdder ripplecar0(PCout_IFID, 32'd4, cout1_ripple1_IFID, adder1_IFID);
// Instruction memory
InstructionMEM instmem(PCout_IFID[7:2], ints_out);

PIPI_REG #(96) IF_ID  (clk, rst ,~IFID_write,{PCout_IFID,ints_out,adder1_IFID},
                       {PCout_IFID_out,ints_out_out,adder1_IFID_out});

///////////////////////////////////////////////////////////////////////////
endmodule