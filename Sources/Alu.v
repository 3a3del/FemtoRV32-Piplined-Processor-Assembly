`timescale 1ns / 1ps
module Alu(
    input [31:0] in1,       // First 32-bit input to the ALU
    input [31:0] in2,       // Second 32-bit input to the ALU
    input [3:0] aluSel,     // 4-bit control signal to select ALU operation
    input [2:0] func3,      // 3-bit function field used for branching operations
    output reg zero,        // Output flag that indicates if the result is zero
    output reg [31:0] result // 32-bit result of the ALU operation
);

wire c1, c2;                // Carry flags (not used in this code but could be used for full adder)
wire [31:0] sum, subt;      // Wires to hold the sum and difference

// Instantiate two ALU adders: one for addition and one for subtraction
AluAdder plus(in1, in2, c1, sum);       // Add in1 and in2, store result in sum
AluAdder sub(in1, ~in2 + 1, c1, subt);  // Subtract in2 from in1 using 2's complement, store result in subt

// Always block that executes whenever any input changes
always @(*) begin
    case (aluSel)
        4'b0000: begin 
            result = sum;    // Load or store operation: return the sum of in1 and in2
            zero = 0;
        end
        4'b0001: begin 
            result = subt;   // Subtract operation
            zero = 0;
        end
        4'b0101: begin 
            result = in1 & in2;  // Bitwise AND operation
            zero = 0;
        end
        4'b0100: begin 
            result = in1 | in2;  // Bitwise OR operation
            zero = 0;
        end
        4'b0111: begin 
            result = in1 ^ in2;  // Bitwise XOR operation
            zero = 0;
        end
        4'b1000: begin 
            result = in1 >> in2; // Logical right shift (SRL)
            zero = 0;
        end
        4'b1010: begin 
            result = in1 >>> in2; // Arithmetic right shift (SRA)
            zero = 0;
        end
        4'b1001: begin 
            result = in1 << in2;  // Logical left shift (SLL)
            zero = 0;
        end
        4'b1101: begin 
            result = (in1 < in2) ? 1 : 0; // Set if less than (signed comparison, SLT)
            zero = 0;
        end
        4'b1111: begin 
            result = ($unsigned(in1) < $unsigned(in2)) ? 1 : 0; // Set if less than (unsigned comparison, SLTU)
            zero = 0;
        end
        4'b0110: begin 
            result = in2;   // LUI operation (load immediate to upper bits)
            zero = 0;
        end
        // Branching operations
        4'b0010: begin
            case(func3)
                3'b000: begin // BEQ: branch if equal
                    zero = (subt == 0) ? 1 : 0; // Set zero flag if in1 == in2 (subtraction result is zero)
                    result = 0;
                end
                3'b001: begin // BNE: branch if not equal
                    zero = (subt != 0) ? 1 : 0; // Set zero flag if in1 != in2
                    result = 0;
                end
                3'b100: begin // BLT: branch if less than (signed)
                    zero = (in1 < in2) ? 1 : 0;
                    result = 0;
                end
                3'b101: begin // BGE: branch if greater than or equal (signed)
                    zero = (in1 >= in2) ? 1 : 0;
                    result = 0;
                end
                3'b110: begin // BLTU: branch if less than (unsigned)
                    zero = ($unsigned(in1) < $unsigned(in2)) ? 1 : 0;
                    result = 0;
                end
                3'b111: begin // BGEU: branch if greater than or equal (unsigned)
                    zero = ($unsigned(in1) >= $unsigned(in2)) ? 1 : 0;
                    result = 0;
                end
                default: begin
                    zero = 0;
                    result = 0;
                end
            endcase
        end
        4'b0011: begin 
            result = in2; // JAL (Jump and Link) operation
            zero = 0;
        end
        4'b1011: begin 
            result = sum; // JALR (Jump and Link Register) operation
            zero = 0;
        end
        default: begin 
            result = 0;  // Default case: result is 0 if no valid ALU operation is selected
            zero = 0;
        end
    endcase
end

endmodule
