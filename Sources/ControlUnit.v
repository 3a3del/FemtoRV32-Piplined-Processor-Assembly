`timescale 1ns / 1ps
module ContUnit(
    input [6:2] opcode,             // 5-bit opcode (RISC-V format)
    output reg branch,              // Branch signal
    output reg memread,             // Memory read enable
    output reg memwrite,            // Memory write enable
    output reg memtoreg,            // Write data from memory to register
    output reg [1:0] aluop,         // ALU operation control
    output reg regwrite,            // Register write enable
    output reg alusrc,              // ALU source (imm or reg)
    output reg i_type,              // Flag for I-type instructions
    output reg [1:0] AJ_control,    // Control signal for jump instructions
    output reg lui_fla,              // Flag for LUI (load upper immediate) instruction
    output reg jalr_fla
);

// Control signal generation based on opcode
always @(*) begin
    case(opcode)
        5'b01100: begin // R-type instructions (ADD, SUB, etc.)
            regwrite <= 1'b1;       // Enable register write
            alusrc <= 1'b0;         // ALU source is register
            aluop <= 2'b10;         // ALU operation for R-type
            lui_fla <= 1'b0;        // Not a LUI instruction
            i_type <= 1'b0;         // Not an I-type instruction
            memread <= 1'b0;        // No memory read
            memwrite <= 1'b0;       // No memory write
            memtoreg <= 1'b0;       // Result comes from ALU
            AJ_control <= 2'b00;    // No jump
            branch <= 1'b0;         // No branch
            jalr_fla <= 1'b0; 
        end
        
        5'b00000: begin // Load instructions (LW, LB, LH, etc.)
            regwrite <= 1'b1;       // Enable register write
            alusrc <= 1'b1;         // ALU source is immediate
            aluop <= 2'b00;         // ALU performs addition
            lui_fla <= 1'b0;        // Not a LUI instruction
            i_type <= 1'b1;         // I-type instruction
            memread <= 1'b1;        // Memory read enabled
            memwrite <= 1'b0;       // No memory write
            memtoreg <= 1'b1;       // Data from memory goes to register
            AJ_control <= 2'b00;    // No jump
            branch <= 1'b0;         // No branch
            jalr_fla <= 1'b0; 
        end
        
        5'b01000: begin // Store instructions (SW, SB, SH)
            regwrite <= 1'b0;       // No register write
            alusrc <= 1'b1;         // ALU source is immediate
            aluop <= 2'b00;         // ALU performs addition
            lui_fla <= 1'b0;        // Not a LUI instruction
            i_type <= 1'b1;         // I-type instruction
            memread <= 1'b0;        // No memory read
            memwrite <= 1'b1;       // Memory write enabled
            memtoreg <= 1'b0;       // No data from memory to register
            AJ_control <= 2'b00;    // No jump
            branch <= 1'b0;         // No branch
            jalr_fla <= 1'b0; 
        end
        
        5'b11000: begin // Branch instructions (BEQ, BNE, etc.)
            regwrite <= 1'b0;       // No register write
            alusrc <= 1'b0;         // ALU source is register
            aluop <= 2'b01;         // ALU performs comparison
            lui_fla <= 1'b0;        // Not a LUI instruction
            i_type <= 1'b1;         // I-type instruction
            memread <= 1'b0;        // No memory read
            memwrite <= 1'b0;       // No memory write
            memtoreg <= 1'b0;       // No memory data to register
            AJ_control <= 2'b00;    // No jump
            branch <= 1'b1;         // Branch enabled
            jalr_fla <= 1'b0; 
        end
        
        5'b00100: begin // I-type ALU instructions (ADDI, ORI, etc.)
            regwrite <= 1'b1;       // Enable register write
            alusrc <= 1'b1;         // ALU source is immediate
            aluop <= 2'b10;         // ALU performs I-type operation
            lui_fla <= 1'b0;        // Not a LUI instruction
            i_type <= 1'b1;         // I-type instruction
            memread <= 1'b0;        // No memory read
            memwrite <= 1'b0;       // No memory write
            memtoreg <= 1'b0;       // Data comes from ALU
            AJ_control <= 2'b00;    // No jump
            branch <= 1'b0;         // No branch
            jalr_fla <= 1'b0; 
        end
        
        5'b11011: begin // JAL instruction (jump and link)
            regwrite <= 1'b1;       // Enable register write
            alusrc <= 1'b1;         // ALU source is immediate
            aluop <= 2'b11;         // ALU performs JAL operation
            lui_fla <= 1'b0;        // Not a LUI instruction
            i_type <= 1'b1;         // I-type instruction
            memread <= 1'b0;        // No memory read
            memwrite <= 1'b0;       // No memory write
            memtoreg <= 1'b0;       // Data comes from ALU
            AJ_control <= 2'b00;    // JAL control
            branch <= 1'b1;         // Jump enabled
            jalr_fla <= 1'b0; 
        end

        5'b11001: begin // JALR instruction (jump and link register)
            regwrite <= 1'b1;       // Enable register write
            alusrc <= 1'b1;         // ALU source is immediate
            aluop <= 2'b11;         // ALU performs JALR operation
            lui_fla <= 1'b0;        // Not a LUI instruction
            i_type <= 1'b1;         // I-type instruction
            memread <= 1'b0;        // No memory read
            memwrite <= 1'b0;       // No memory write
            memtoreg <= 1'b0;       // Data comes from ALU
            AJ_control <= 2'b01;    // JALR control
            branch <= 1'b0;         // No branch
            jalr_fla <= 1'b1; 
        end
        
        5'b00101: begin // AUIPC (add upper immediate to PC)
            regwrite <= 1'b1;       // Enable register write
            alusrc <= 1'b1;         // ALU source is immediate
            aluop <= 2'b00;         // ALU performs addition
            lui_fla <= 1'b0;        // Not a LUI instruction
            i_type <= 1'b1;         // I-type instruction
            memread <= 1'b0;        // No memory read
            memwrite <= 1'b0;       // No memory write
            memtoreg <= 1'b0;       // Data comes from ALU
            AJ_control <= 2'b11;    // AUIPC control
            branch <= 1'b0;         // No branch
            jalr_fla <= 1'b0; 
        end
        
        5'b01101: begin // LUI (load upper immediate)
            regwrite <= 1'b1;       // Enable register write
            alusrc <= 1'b1;         // ALU source is immediate
            aluop <= 2'b10;         // ALU performs immediate operation
            lui_fla <= 1'b1;        // LUI instruction
            i_type <= 1'b0;         // Not an I-type instruction
            memread <= 1'b0;        // No memory read
            memwrite <= 1'b0;       // No memory write
            memtoreg <= 1'b0;       // Data comes from ALU
            AJ_control <= 2'b00;    // No jump
            branch <= 1'b0;         // No branch
            jalr_fla <= 1'b0; 
        end
        default: begin // LUI (load upper immediate)
            regwrite <= 1'bx;       // No Enable register write
            alusrc <= 1'bx;         // No ALU source is immediate
            aluop <= 2'bxx;         // No ALU performs immediate operation
            lui_fla <= 1'bx;        // No LUI instruction
            i_type <= 1'bx;         // No Not an I-type instruction
            memread <= 1'bx;        // No memory read
            memwrite <= 1'bx;       // No memory write
            memtoreg <= 1'bx;       // No Data comes from ALU
            AJ_control <= 2'bxx;    // No jump
            branch <= 1'bx;         // No branch
            jalr_fla <= 1'b0; 
        end
    endcase
end

endmodule
