module InstructionMEM #(
    parameter INST_MEM_FILE = "C:/Users/hp/Desktop/RISC/firmware/output_64_lines_hex.txt", // Path to instruction memory file
    parameter WIDTH = 32  // Instruction width (32 bits)
)(
    input [5:0] addr,       // 6-bit address to fetch instruction from memory
    output [WIDTH-1:0] instr // Output instruction
);

    // Define the instruction memory with 64 entries of WIDTH-bit words
    reg [WIDTH-1:0] INST_MEM [63:0];

    // Load instruction memory from the specified file at initialization
    initial begin
        if (INST_MEM_FILE != 0) begin
            $readmemh(INST_MEM_FILE, INST_MEM); // Load hex file into memory
        end else begin
            $display("Error: INST_MEM_FILE is not specified."); // Display error if no file is provided
        end
    end
    // Assign the instruction output based on the address
    assign instr = INST_MEM[addr];

endmodule
