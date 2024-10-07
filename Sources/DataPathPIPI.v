`timescale 1ns / 1ps
// Data path module for a processor
module Data_Path_PIPI(
    input clk,               // Clock signal for synchronous operations
    input rst                // Reset signal for asynchronous reset
);
// Wire declarations
wire PC_stall, IFID_write, MUXselect;
wire [31:0] PCout_IFID, adder1_IFID, ints_out; wire sclk;
wire [31:0] PCout_IFID_out, ints_out_out, adder1_IFID_out;
wire [4:0] WData_IDEX_out,WData_IDEX;
wire [31:0] gen_out_IDEX;
wire [31:0] writingData;
wire [1:0] aluop_IDEX_out,aluop_IDEX;
wire [3:0] function3_out_IDEX_out;
wire [31:0] readdata1_IDEX_out, readdata2_IDEX_out, IF_IDEX_PC_ID_out, gen_out_IDEX_out, adder1_IDEX;
wire [4:0] RS1_IDEX, RS2_IDEX;
wire [12:0] hazard_out;
wire branch_IDEX, memread_IDEX, memwrite_IDEX, memtoreg_IDEX, regwrite_IDEX, alusrc_IDEX, i_type_IDEX, lui_flag_IDEX, jalr_fla_IDEX;
wire memtoreg_IDEX_out, regwrite_IDEX_out, memread_IDEX_out, memwrite_IDEX_out, branch_IDEX_out, alusrc_IDEX_out, i_type_IDEX_out, lui_flag_IDEX_out, jalr_fla_IDEX_out;
wire regwrite_MEMEX_out;
wire [31:0] writingData_MEMWB, ALU_result_EX_out;
wire [31:0] ALU_result_MEMEX_out, readdata2_MEMEX_out, adder1_IDEX_MEM, adder2_MEM;
wire [4:0] WData_MEMEX_out;
wire [3:0] function3_out_MEMEX_out;
wire [31:0] RD1_output, RD2_output, outmux_input_alu;
wire cout1_ripple2_IDEX;
wire [31:0] adder2_EXMEM, pcmux2;
wire zero_EXMEM; 
wire [1:0] forwardA, forwardB,AJ_control_IDEX,AJ_control_MEMEX_out; wire [31:0]readdata1_IDEX,readdata2_IDEX;
reg S;  // Declaring S as a reg for use in always block
wire [31:0] PCmux_EXMEM, ALU_result;
wire [31:0] dataMem_out_MEM_out, ALU_result_MEM_out, adder1_IDEX_WB, adder2_WB;
wire [4:0] WData_MEM_out;
wire [1:0] AJ_control_MEM_out,AJ_control_IDEX_out;
wire regwrite_MEM_out, memtoreg_MEM_out; wire [31:0]regwrite_MEM_outt;
wire [31:0] dataMem_out; wire [3:0] aluS; wire [31:0] shiftout; wire [12:0]control_hazard;
//IFID //IDEX //EXMEM //MEMWB
////////////////////////////////////////////////////////////////////////
//IFID
// Program Counter (PC) register
CLK_divid div(clk,rst,sclk );

OneReg pc(sclk, rst, ~PC_stall, PCmux_EXMEM, PCout_IFID);

hazardunit Hazard_unit(ints_out_out[19:15],WData_MEMEX_out,ints_out_out[24:20],
                     memread_ID_ex,PC_stall,IFID_write,MUXselect); //memread_ID_ex

// Adder to increment PC by 4
AluAdder ripplecar0(PCout_IFID, 32'd4, cout1_ripple1_IFID, adder1_IFID);
 // Instruction memory
InstructionMEM instmem(PCout_IFID[7:2], ints_out);
                     
PIPI_REG #(96) IF_ID  (clk, rst ,~IFID_write,{PCout_IFID,ints_out,adder1_IFID},
{PCout_IFID_out,ints_out_out,adder1_IFID_out});

///////////////////////////////////////////////////////////////////////////
//IDEX
//{     PCout_IFID_out,        ints_out_out,        adder1_IFID_out      } 
// Register file to store and read register data
RegisterFile regfile(sclk, rst, regwrite_MEM_out, ints_out_out[19:15], ints_out_out[24:20], ints_out_out[11:7],
regwrite_MEM_outt, readdata1_IDEX, readdata2_IDEX); 

// Control Unit generates control signals based on instruction opcode
 ContUnit controlunit(ints_out_out[6:2], branch_IDEX, memread_IDEX, memwrite_IDEX, memtoreg_IDEX, aluop_IDEX, regwrite_IDEX, alusrc_IDEX, i_type_IDEX, AJ_control_IDEX, lui_flag_IDEX,jalr_fla_IDEX);

//mux hazards after control unit //

mux32Bit #(13) mux_hazard({memtoreg_IDEX,regwrite_IDEX,memread_IDEX,memwrite_IDEX,
branch_IDEX,aluop_IDEX,alusrc_IDEX,i_type_IDEX,AJ_control_IDEX,lui_flag_IDEX,jalr_fla_IDEX},13'd0,MUXselect,control_hazard);

// Immediate value generator
SignExt immgen(ints_out_out, gen_out_IDEX);

assign WData_IDEX = ints_out_out[11:7];

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
,alusrc_IDEX_out,i_type_IDEX_out,AJ_control_IDEX_out,lui_flag_IDEX_out,jalr_fla_IDEX_out};//
///////////////////////////////////////////////////////////////////////////
//EXMEM
// Shift operation for branch addresses

shiftLeft sh(gen_out_IDEX_out, shiftout);//

ForwardMux mux_one(readdata1_IDEX_out, writingData, ALU_result_MEMEX_out, forwardA, RD1_output);
ForwardMux mux_two(readdata2_IDEX_out, writingData, ALU_result_MEMEX_out, forwardB, RD2_output);

// Multiplexer to select between register data and immediate data for ALU
mux32Bit mux2(RD2_output, gen_out_IDEX_out, alusrc_IDEX_out, outmux_input_alu);
// Adder to calculate branch target address
AluAdder ripplecar1(IF_IDEX_PC_ID_out, shiftout, cout1_ripple2_IDEX, adder2_EXMEM);

// Multiplexer to select between incremented PC and branch target address
mux32Bit mux0(adder1_IDEX, adder2_EXMEM, branch_IDEX_out & zero_EXMEM, pcmux2);

// Multiplexer to select between PC and ALU result
mux32Bit mux1(pcmux2, ALU_result, S, PCmux_EXMEM);

// Determine control signal S based on instruction type
always @(*) begin
    if (hazard_out == 13'b0100111110000 || hazard_out == 13'b0100011110101)
        S = 1;
    else
        S = 0;
end

AluControl Alu_Control(i_type_IDEX_out, function3_out_IDEX_out[3], lui_flag_IDEX_out, 
                       jalr_fla_IDEX_out, aluop_IDEX_out, function3_out_IDEX_out[2:0], aluS);

// ALU performs arithmetic and logic operations
Alu alu1(RD1_output, outmux_input_alu, aluS, function3_out_IDEX_out[2:0], zero_EXMEM, ALU_result);

// Concatenate control signals for EX/MEM pipeline register
wire [5:0] ex_mem_controls = {memtoreg_IDEX_out, regwrite_IDEX_out, memread_IDEX_out, memwrite_IDEX_out, AJ_control_IDEX_out};

// Pipeline register EX_MEM
PIPI_REG #(143) EX_MEM (
    clk, rst, 1'b1,
    {ex_mem_controls, ALU_result, RD2_output, function3_out_IDEX_out, WData_IDEX_out, adder1_IDEX, adder2_EXMEM},
    
    {memtoreg_MEMEX_out, regwrite_MEMEX_out2, memread_MEMEX_out, memwrite_MEMEX_out, 
     AJ_control_MEMEX_out, ALU_result_MEMEX_out, readdata2_MEMEX_out, function3_out_MEMEX_out, 
     WData_MEMEX_out, adder1_IDEX_MEM, adder2_MEM}
);
//////////////////////////////////////////////////////////////////////////////////////////
// Forwarding logic
Forward fowr(RS1_IDEX, RS2_IDEX, WData_MEMEX_out, WData_MEM_out, regwrite_MEMEX_out2, regwrite_MEM_out, forwardA, forwardB);

// Instantiate DataMemory
DataMemory datamem(
    sclk, ALU_result_MEMEX_out[7:2], memread_MEMEX_out, memwrite_MEMEX_out, 
    readdata2_MEMEX_out, function3_out_MEMEX_out[2:0], dataMem_out
);
// Signals between MEM and WB stages

//----------------------MEM/WB----------------------------------------------------
// Pipeline register MEM_WB
PIPI_REG #(137) MEM_WB (
    clk, rst, 1'b1,
    {regwrite_MEMEX_out, memtoreg_MEMEX_out, dataMem_out, ALU_result_MEMEX_out, WData_MEMEX_out, 
     AJ_control_MEMEX_out, adder1_IDEX_MEM, adder2_MEM},

    {regwrite_MEM_out, memtoreg_MEM_out, dataMem_out_MEM_out, ALU_result_MEM_out, 
     WData_MEM_out, AJ_control_MEM_out, adder1_IDEX_WB, adder2_WB}
);
// Multiplexer to select between ALU result and data memory output
mux32Bit mux3(ALU_result_MEM_out, dataMem_out_MEM_out, memtoreg_MEM_out, writingData);

// Four-way multiplexer for final data to be written to the register file
FourMux WD_mux(
    adder2_WB, adder1_IDEX_WB, writingData, AJ_control_MEM_out, regwrite_MEM_outt
);

endmodule