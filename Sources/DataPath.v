`timescale 1ns / 1ps

// Data path module for a processor
// Connects various components including ALU, registers, memory, and multiplexers
module Data_Path(
    input clk,               // Clock signal for synchronous operations
    input rst                // Reset signal for asynchronous reset
);

// Internal wires and registers
wire [31:0] adder1,PCmux, adder2, PCout, pcmux2; // Wires for adder and mux outputs
wire cout1_ripple1, cout1_ripple2;               // Carry-out signals from ripple carry adders
wire [31:0] ints_out;                            // Instruction output from instruction memory
wire [31:0] readdata1, readdata2;                // Data read from register file
wire [31:0] gen_out;                             // Output from immediate generator
wire branch;                                    // Branch signal for control
wire memread, memtoreg, memwrite, alusrc, regwrite; // Control signals for memory and ALU operations
wire [1:0] aluop;                               // ALU operation control signals
wire [3:0] aluS;                                // ALU control signals
wire [31:0] outmux_input_alu;                   // ALU input from mux
wire [31:0] ALU_result;                         // Result from ALU
wire zero;                                     // Zero flag from ALU
wire [31:0] dataMem_out;                        // Data output from data memory
wire [31:0] writingData;                        // Data to be written back to registers
wire [31:0] shiftout;                           // Output from shift operation
reg S;                                          // Register for control signal
wire i_type;                                    // Immediate type flag
wire [1:0] AJ_control;                          // Control signal for four-way mux
wire [31:0] WD;                                 // Data to be written to register file
reg [12:0] num;                                 // Unused register (could be removed)
wire lui_flag, jalr_fla;                        // Flags for LUI and JALR instructions

// Program Counter (PC) register
OneReg pc(clk, rst, 1, PCmux, PCout);

// Adder to increment PC by 4
AluAdder ripplecar0(PCout, 32'd4, cout1_ripple1, adder1);

// Adder to calculate branch target address
AluAdder ripplecar1(PCout, shiftout, cout1_ripple2, adder2);

// Multiplexer to select between incremented PC and branch target address
mux32Bit mux0(adder1, adder2, branch & zero, pcmux2);

// Multiplexer to select between PC and ALU result
mux32Bit mux1(pcmux2, ALU_result, S, PCmux);

// Determine control signal S based on instruction type
always @(*) begin
    if (ints_out[6:2] == 5'b11001 || ints_out[6:2] == 5'b11011)
        S = 1;
    else
        S = 0;
end

// Instruction memory
InstructionMEM instmem(PCout[7:2], ints_out);

// Control Unit generates control signals based on instruction opcode
ContUnit controlunit(ints_out[6:2], branch, memread, memwrite, memtoreg, aluop, regwrite, alusrc, i_type, AJ_control, lui_flag);

// ALU Control generates ALU control signals
AluControl Alu_Control(i_type, ints_out[30], lui_flag, jalr_fla, aluop, ints_out[14:12], aluS);

// Register file to store and read register data
RegisterFile regfile(clk, rst, regwrite, ints_out[19:15], ints_out[24:20], ints_out[11:7], WD, readdata1, readdata2);

// Immediate value generator
SignExt immgen(ints_out, gen_out);

// Shift operation for branch addresses
shiftLeft sh(gen_out, shiftout);

// Multiplexer to select between register data and immediate data for ALU
mux32Bit mux2(readdata2, gen_out, alusrc, outmux_input_alu);

// ALU performs arithmetic and logic operations
Aluu alu1(readdata1, outmux_input_alu, aluS, ints_out[14:12], zero, ALU_result);

// Data memory for load and store operations
DataMemory datamem(clk, ALU_result[7:2], memread, memwrite, readdata2, ints_out[14:12], dataMem_out);

// Multiplexer to select between ALU result and data memory output
mux32Bit mux3(ALU_result, dataMem_out, memtoreg, writingData);

// Four-way multiplexer for final data to be written to register file
FourMux WD_mux(adder2, adder1, writingData, AJ_control, WD);

endmodule
