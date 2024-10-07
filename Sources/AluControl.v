`timescale 1ns / 1ps
module AluControl(
    input i_type,                 // Specifies if it's an I-type instruction
    input instr2,                 // 7th bit of the instruction (funct7[5] for R-type)
    input lui_flag,               // Flag to indicate if the instruction is LUI (load upper immediate)
    input jalr_flag,              // Flag to indicate if the instruction is JALR
    input [1:0] aluop,            // ALU operation signal (from control unit)
    input [2:0] instr1,           // 3-bit function code (funct3 field of the instruction)
    output reg [3:0] aluS         // ALU selection signal (output)
);

// ALU operation selection based on the input control signals
always @(*) begin
    // For load and store operations, ALU performs addition (sum)
    if (aluop == 2'b00) // Load & store operations
        aluS = 4'b0000; // Perform addition (sum)
    
    // For JAL (jump and link) instruction
    else if (aluop == 2'b11 && !jalr_flag)
        aluS = 4'b0011; // ALU performs operation for JAL
    
    // For JALR (jump and link register) instruction
    else if (aluop == 2'b11 && jalr_flag)
        aluS = 4'b1011; // ALU performs operation for JALR
    
    // For branch instructions
    else if (aluop == 2'b01)
        aluS = 4'b0010; // ALU performs subtraction for branch comparison
    
    // For R-type or I-type instructions (based on funct3, funct7, and i_type flags)
    
    // R-type ADD instruction (funct3=000, funct7[5]=0)
    else if (aluop == 2'b10 && lui_flag == 1'b0 && i_type == 1'b0 && instr1 == 3'b000 && instr2 == 1'b0)
        aluS = 4'b0000; // Perform addition
    
    // I-type ADDI instruction (funct3=000)
    else if (aluop == 2'b10 && lui_flag == 1'b0 && i_type == 1'b1 && instr1 == 3'b000)
        aluS = 4'b0000; // Perform addition
    
    // R-type SUB instruction (funct3=000, funct7[5]=1)
    else if (aluop == 2'b10 && lui_flag == 1'b0 && i_type == 1'b0 && instr1 == 3'b000 && instr2 == 1'b1)
        aluS = 4'b0001; // Perform subtraction
    
    // R-type AND and ANDI instructions (funct3=111)
    else if (aluop == 2'b10 && lui_flag == 1'b0 && instr1 == 3'b111)
        aluS = 4'b0101; // Perform bitwise AND
    
    // R-type OR and ORI instructions (funct3=110)
    else if (aluop == 2'b10 && lui_flag == 1'b0 && instr1 == 3'b110)
        aluS = 4'b0100; // Perform bitwise OR
    
    // R-type XOR and XORI instructions (funct3=100)
    else if (aluop == 2'b10 && lui_flag == 1'b0 && instr1 == 3'b100 && instr2 == 1'b0)
        aluS = 4'b0111; // Perform bitwise XOR
    
    // R-type SRL (shift right logical) instruction
    else if (aluop == 2'b10 && lui_flag == 1'b0 && instr1 == 3'b101 && instr2 == 1'b0 && i_type == 1'b0)
        aluS = 4'b1000; // Perform logical right shift
    
    // I-type SRLI (shift right logical immediate)
    else if (aluop == 2'b10 && lui_flag == 1'b0 && instr1 == 3'b101 && instr2 == 1'b0 && i_type == 1'b1)
        aluS = 4'b1000; // Perform logical right shift immediate
    
    // R-type SRA (shift right arithmetic) instruction
    else if (aluop == 2'b10 && lui_flag == 1'b0 && instr1 == 3'b101 && instr2 == 1'b1 && i_type == 1'b0)
        aluS = 4'b1010; // Perform arithmetic right shift
    
    // I-type SRAI (shift right arithmetic immediate)
    else if (aluop == 2'b10 && lui_flag == 1'b0 && instr1 == 3'b101 && instr2 == 1'b1 && i_type == 1'b1)
        aluS = 4'b1010; // Perform arithmetic right shift immediate
    
    // R-type SLL (shift left logical) instruction
    else if (aluop == 2'b10 && lui_flag == 1'b0 && instr1 == 3'b001 && instr2 == 1'b0 && i_type == 1'b0)
        aluS = 4'b1001; // Perform logical left shift
    
    // I-type SLLI (shift left logical immediate)
    else if (aluop == 2'b10 && lui_flag == 1'b0 && instr1 == 3'b001 && instr2 == 1'b0 && i_type == 1'b1)
        aluS = 4'b1001; // Perform logical left shift immediate
    
    // R-type SLT and SLTI instructions (set less than)
    else if (aluop == 2'b10 && lui_flag == 1'b0 && instr1 == 3'b010)
        aluS = 4'b1101; // Perform set less than
    
    // R-type SLTU and SLTUI instructions (set less than unsigned)
    else if (aluop == 2'b10 && lui_flag == 1'b0 && instr1 == 3'b011)
        aluS = 4'b1111; // Perform set less than unsigned
    
    // LUI instruction (load upper immediate)
    else if (aluop == 2'b10 && lui_flag == 1)
        aluS = 4'b0110; // Load upper immediate
    else
        aluS = 4'bxxxx;
end

endmodule
