// Sign extension module for various instruction formats
// Extends immediate values from instructions based on the instruction type
module SignExt(
    input [31:0] inst,      // 32-bit instruction input
    output reg [31:0] ext_out // 32-bit extended output
);

// Always block for combinatorial logic
always @(*)
begin
    // Case statement based on the opcode (7-bit instruction field)
    case (inst[6:0])
        // LUI (Load Upper Immediate)
        7'b0110111:  
            ext_out = {{inst[31]?12'hFFF:12'h000}, inst[31:12]};
        
        // AUIPC (Add Upper Immediate to PC)
        7'b0010111: 
            ext_out = {inst[31:12], 12'h000};
        
        // JAL (Jump and Link)
        7'b1101111:  
            ext_out = {{inst[31]?12'hFFF:12'h000}, inst[20], inst[10:1], inst[11], inst[19:12]};
        
        // JALR (Jump and Link with Register)
        7'b1100111:  
            ext_out = {{inst[31]?20'hFFFFF:20'h00000}, inst[31:20]};
        
        // Branch instructions
        7'b1100011:  
            ext_out = {{inst[31]?20'hFFFFF:20'h00000}, inst[31], inst[7], inst[30:25], inst[11:8]};
        
        // Load instructions
        7'b0000011:  
            ext_out = {{inst[31]?20'hFFFFF:20'h00000}, inst[31:20]};
        
        // Store instructions
        7'b0100011:  
            ext_out = {{inst[31]?20'hFFFFF:20'h00000}, inst[31:25], inst[11:7]};
        
        // Immediate instructions
        7'b0010011: 
            if(inst[30] == 1 && inst[14:12] == 3'b101) // Special case for certain immediate types
                ext_out = {27'h00000, inst[24:20]};
            else
                ext_out = {{inst[31]?20'hFFFFF:20'h00000}, inst[31:20]};
        
        // Default case for unsupported or invalid opcodes
        default: 
            ext_out = 0;
    endcase
end

endmodule
