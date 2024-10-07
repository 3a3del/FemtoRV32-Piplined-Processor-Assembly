module InstructionMEM_tb;

    // Testbench parameters
    reg [5:0] addr_tb; // Address to fetch instruction
    wire [31:0] instr_tb; // Output instruction

    // Instantiate the InstructionMEM module
    InstructionMEM #(
        .INST_MEM_FILE("C:\\Users\\hp\\Desktop\\RISC\\RISC32I\\output_64_lines_hex.txt")
    ) uut (
        .addr(addr_tb),
        .instr(instr_tb)
    );

    // Testbench stimulus
    initial begin
        // Monitor changes
        $monitor("Time = %0d | Address = %0d | Instruction = %h", $time, addr_tb, instr_tb);

        // Apply test cases
        addr_tb = 6'd0; #10; // Fetch instruction at address 0
        addr_tb = 6'd1; #10; // Fetch instruction at address 1
        addr_tb = 6'd2; #10; // Fetch instruction at address 2
        addr_tb = 6'd3; #10; // Fetch instruction at address 3

        // Add more addresses as needed

        #50 $finish; // End simulation
    end

endmodule

