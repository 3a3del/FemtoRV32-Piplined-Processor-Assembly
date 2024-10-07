`timescale 1ns / 1ps // Time unit and precision for simulation

// Parameterized 32x32 register file module
module RegisterFile #(parameter N = 32)( 
    input clk,              // Clock signal for synchronous operation
    input rst,              // Asynchronous reset signal (active low)
    input WR,               // Write enable signal
    input [4:0] RReg1,     // Register address for read port 1
    input [4:0] RReg2,     // Register address for read port 2
    input [4:0] WReg,      // Register address for write port
    input [N-1:0] WDATA,   // Data to be written to the register file
    output [N-1:0] RD1,    // Data output from read port 1
    output [N-1:0] RD2     // Data output from read port 2
);

// Internal register array for control signals
reg [0:N-1] S;

// Internal wire array for the register outputs
wire [N-1:0] Q [0:N-1];

// Generate a 32-bit register file by instantiating 32 one-bit registers
genvar i; // Variable used for generating multiple instances
generate
    for (i = 0; i <= N-1; i = i + 1) begin
        // Instantiate a 32-bit register for each address in the register file
        OneReg mod1 (
            .clk(clk),        // Connect the clock signal
            .rst(rst),        // Connect the reset signal
            .Select(S[i]),    // Connect the control signal to select the write data
            .in(WDATA),       // Connect the write data
            .Q(Q[i])          // Connect the output of the register
        );
    end
endgenerate

// Assign read data outputs based on register addresses
assign RD1 = Q[RReg1]; // Output data from the register specified by RReg1
assign RD2 = Q[RReg2]; // Output data from the register specified by RReg2

// Update control signals and handle writes
always @(*) begin
    // If write enable is active, set the control signal for the write register
    if (WR) 
        S[WReg] = 1;
    else
        S = 0;
end

endmodule
