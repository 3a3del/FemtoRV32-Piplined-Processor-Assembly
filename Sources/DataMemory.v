`timescale 1ns / 1ps
module DataMemory #(parameter MEM_FILE = "C:/Users/hp/Desktop/RISC/firmware/random_data.txt", // Path to the memory initialization file
                    parameter DEPTH = 64 , // Number of memory /locations (64 entries)
                    parameter WIDTH = 32)( // Width of each memory location (32 bits)
    input clk,                        // Clock signal
    input [5:0] adder,                // Address input (6 bits, for addressing 64 locations)
    input MemRead,                    // Control signal to enable memory reading
    input MemWrite,                   // Control signal to enable memory writing
    input [WIDTH-1:0] data_in,        // Data input to be written to memory
    input [2:0] function3,            // 3-bit signal that selects the type of memory operation
    output reg [WIDTH-1:0] data_out   // Data output from memory
);

reg [WIDTH-1:0] MEM [0:DEPTH-1];      // Declare memory as a 2D array (64 x 32-bit memory locations)
integer i;                            // Integer variable for the loop

// Initialization block
initial begin
    // Initialize all memory locations to zero
   // for (i = 0; i < DEPTH; i = i + 1) begin
      //  MEM[i] = 'h0;                  // Set each memory location to zero
   // end
    
    // If the memory file is specified, load the memory contents from the file
    if (MEM_FILE != 0) begin
        $readmemh(MEM_FILE, MEM);      // Load memory contents from the specified file
    end
end

// Always block triggered on the rising edge of the clock (for writing to memory)
always @(posedge clk) begin
    if (MemWrite && function3 == 3'b000) begin // Byte write (SB operation)
        MEM[adder][7:0] <= data_in;     // Write the least significant byte (8 bits) to the memory location
    end
    else if (MemWrite && function3 == 3'b001) begin // Halfword write (SH operation)
        MEM[adder][15:0] <= data_in;    // Write the least significant halfword (16 bits) to the memory location
    end
    else if (MemWrite && function3 == 3'b010) begin // Word write (SW operation)
        MEM[adder] <= data_in;          // Write the entire word (32 bits) to the memory location
    end
end

// Always block triggered on the rising edge of the clock (for reading from memory)
always @(posedge clk) begin
    if (MemRead && function3 == 3'b000) begin // Byte read (LB operation)
        data_out <= { {24{MEM[adder][31]}}, MEM[adder][7:0] }; // Sign-extend the least significant byte
    end
    else if (MemRead && function3 == 3'b001) begin // Halfword read (LH operation)
        data_out <= { {16{MEM[adder][31]}}, MEM[adder][15:0] }; // Sign-extend the least significant halfword
    end
    else if (MemRead && function3 == 3'b010) begin // Word read (LW operation)
        data_out <= MEM[adder];         // Read the entire word
    end
    else if (MemRead && function3 == 3'b100) begin // Unsigned byte read (LBU operation)
        data_out <= {24'b0, MEM[adder][7:0]}; // Zero-extend the least significant byte
    end
    else if (MemRead && function3 == 3'b101) begin // Unsigned halfword read (LHU operation)
        data_out <= {16'b0, MEM[adder][15:0]}; // Zero-extend the least significant halfword
    end
    else
        data_out <= 32'd0000;            // Default output value is zero
end

endmodule
