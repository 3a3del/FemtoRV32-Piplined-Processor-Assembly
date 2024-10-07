`timescale 1ns / 1ps
module MEM_EX(
    input clk,               // Clock signal for synchronous operations
    input rst,               // Reset signal for asynchronous reset
    input memtoreg_IDEX_out, 
    input regwrite_IDEX_out, 
    input memread_IDEX_out,
    input memwrite_IDEX_out, 
    input branch_IDEX_out, 
    input alusrc_IDEX_out,
    input i_type_IDEX_out, 
    input lui_flag_IDEX_out, 
    input jalr_fla_IDEX_out, 
    input regwrite_MEMEX_out,
    input [1:0] aluop_IDEX_out, AJ_control_IDEX_out,
    input [31:0] IF_IDEX_PC_ID_out, readdata1_IDEX_out, readdata2_IDEX_out, 
    input [31:0] gen_out_IDEX_out, adder1_IDEX, writingData_MEMWB, ALU_result_EX_out,
    input [3:0] function3_out_IDEX_out,
    input [4:0] WData_IDEX_out, RS1_IDEX, RS2_IDEX, WData_MEM_out,
    output memtoreg_MEMEX_out, memread_MEMEX_out, memwrite_MEMEX_out, regwrite_MEMEX_out2,
    output [1:0] AJ_control_MEMEX_out,
    output [31:0] ALU_result_MEMEX_out, readdata2_MEMEX_out, adder1_IDEX_MEM, adder2_MEM,
    output [4:0] WData_MEMEX_out,
    output [3:0] function3_out_MEMEX_out
);

// Concatenate control signals
wire [12:0] hazard_out;
assign hazard_out = {memtoreg_IDEX_out, regwrite_IDEX_out, memread_IDEX_out, memwrite_IDEX_out, 
                     branch_IDEX_out, aluop_IDEX_out, alusrc_IDEX_out, i_type_IDEX_out, 
                     AJ_control_IDEX_out, lui_flag_IDEX_out, jalr_fla_IDEX_out};

// Shift operation for branch addresses
wire [31:0] shiftout;
shiftLeft sh(gen_out_IDEX_out, shiftout);

// Declare other wires
wire [31:0] RD1_output, RD2_output, outmux_input_alu;
wire cout1_ripple2_IDEX;
wire [31:0] adder2_EXMEM, pcmux2;
wire zero_EXMEM;
wire [1:0] forwardA, forwardB;
reg S;  // Declaring `S` as a reg for use in always block
wire [31:0] PCmux_EXMEM, ALU_result;

// Forwarding logic
Forward fowr(RS1_IDEX, RS2_IDEX, WData_IDEX_out, WData_MEM_out, regwrite_IDEX_out, regwrite_MEMEX_out, forwardA, forwardB);
ForwardMux mux_one(readdata1_IDEX_out, writingData_MEMWB, ALU_result_EX_out, forwardA, RD1_output);
ForwardMux mux_two(readdata2_IDEX_out, writingData_MEMWB, ALU_result_EX_out, forwardB, RD2_output);

// Multiplexer to select between register data and immediate data for ALU
mux32Bit mux2(RD2_output, gen_out_IDEX_out, alusrc_IDEX_out, outmux_input_alu);

// Adder to calculate branch target address
AluAdder ripplecar1(gen_out_IDEX_out, shiftout, cout1_ripple2_IDEX, adder2_EXMEM);

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

wire [3:0] aluS;
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

endmodule

