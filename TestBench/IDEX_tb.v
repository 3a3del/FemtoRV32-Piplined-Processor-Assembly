`timescale 1ns / 1ps
module ID_EX(
    input clk,               // Clock signal for synchronous operations
    input rst,                // Reset signal for asynchronous reset negedge
    input [31:0]PC_EXMEM,
    input [31:0] adder2_WB ,adder1_IDEX_WB,writingData,
    input MUXselect,PC_stall,IFID_write, //must be all on or all off in the same time
    input [1:0] AJ_control_MEM_out,
input WD_MEMWB,
output [3:0] function3_out_IDEX_out,
output [31:0] readdata1_IDEX_out,readdata2_IDEX_out,IF_IDEX_PC_ID_out, gen_out_IDEX_out,adder1_IDEX,
output [4:0] WData_IDEX_out ,RS1_IDEX,RS2_IDEX,
output [12:0] hazard_out
);

wire [31:0] PCout_IFID;
wire cout1_ripple1_IFID;
wire [31:0] adder1_IFID,ints_out;  wire sclk;
wire [31:0] readdata2_IDEX,readdata1_IDEX,gen_out_IDEX,regwrite_MEM_out;
////////////////////////////////////////////////////////////////////////
//IFID
// Program Counter (PC) register

CLK_divid div(clk,rst,sclk );

OneReg pc(sclk, rst, ~PC_stall, PC_EXMEM, PCout_IFID); 

// Adder to increment PC by 4
AluAdder ripplecar0(PCout_IFID, 32'd4, cout1_ripple1_IFID, adder1_IFID);
// Instruction memory
InstructionMEM instmem(PCout_IFID[7:2], ints_out);

wire [31:0] PCout_IFID_out,ints_out_out,adder1_IFID_out;

PIPI_REG #(96) IF_ID  (clk, rst ,~IFID_write,{PCout_IFID,ints_out,adder1_IFID},
                       {PCout_IFID_out,ints_out_out,adder1_IFID_out});

///////////////////////////////////////////////////////////////////////////
//{     PCout_IFID_out,        ints_out_out,        adder1_IFID_out      }
RegisterFile regfile(sclk, rst, WD_MEMWB, ints_out_out[19:15], ints_out_out[24:20], ints_out_out[11:7],
 regwrite_MEM_out, readdata1_IDEX, readdata2_IDEX); 

SignExt immgen(ints_out_out, gen_out_IDEX);

// Four-way multiplexer for final data to be written to register file
FourMux WD_mux(adder2_WB, adder1_IDEX_WB, writingData, AJ_control_MEM_out, regwrite_MEM_out);

wire [1:0] AJ_control_IDEX,aluop_IDEX;
wire branch_IDEX,memread_IDEX,memwrite_IDEX,memtoreg_IDEX,regwrite_IDEX,alusrc_IDEX,i_type_IDEX,lui_flag_IDEX,jalr_fla_IDEX;
wire [12:0]control_hazard;

ContUnit controlunit(ints_out_out[6:2], branch_IDEX, memread_IDEX, memwrite_IDEX, memtoreg_IDEX, aluop_IDEX, regwrite_IDEX, alusrc_IDEX, i_type_IDEX, AJ_control_IDEX, lui_flag_IDEX,jalr_fla_IDEX);


mux32Bit #(13) mux_hazard({memtoreg_IDEX,regwrite_IDEX,memread_IDEX,memwrite_IDEX,
branch_IDEX,aluop_IDEX,alusrc_IDEX,i_type_IDEX,AJ_control_IDEX,lui_flag_IDEX,jalr_fla_IDEX},13'd0,MUXselect,control_hazard);

wire [4:0] WData_IDEX;
assign WData_IDEX = ints_out_out[11:7];

wire memtoreg_IDEX_out,regwrite_IDEX_out, memread_IDEX_out, memwrite_IDEX_out, branch_IDEX_out
,alusrc_IDEX_out,i_type_IDEX_out,lui_flag_IDEX_out,jalr_fla_IDEX_out;
wire [1:0]AJ_control_IDEX_out,aluop_IDEX_out;


PIPI_REG #(192) ID_EX (clk, rst, 1'b1,
{control_hazard ,  PCout_IFID_out  ,  readdata1_IDEX, readdata2_IDEX
,gen_out_IDEX,{ints_out_out[30],ints_out_out[14:12]},WData_IDEX
,ints_out_out[19:15],ints_out_out[24:20],adder1_IFID_out
 },
{{memtoreg_IDEX_out,regwrite_IDEX_out, memread_IDEX_out, memwrite_IDEX_out, branch_IDEX_out,aluop_IDEX_out
,alusrc_IDEX_out,i_type_IDEX_out,AJ_control_IDEX_out,lui_flag_IDEX_out,jalr_fla_IDEX_out},

IF_IDEX_PC_ID_out, readdata1_IDEX_out,readdata2_IDEX_out,
 gen_out_IDEX_out
,function3_out_IDEX_out
, WData_IDEX_out
,RS1_IDEX,RS2_IDEX,adder1_IDEX
});

assign hazard_out ={memtoreg_IDEX_out,regwrite_IDEX_out, memread_IDEX_out, memwrite_IDEX_out, branch_IDEX_out,aluop_IDEX_out
,alusrc_IDEX_out,i_type_IDEX_out,AJ_control_IDEX_out,lui_flag_IDEX_out,jalr_fla_IDEX_out};
endmodule