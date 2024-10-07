`timescale 1ns / 1ps

// 32-bit register module
// Instantiates 32 one-bit registers to form a 32-bit register
module OneReg(
    input clk,           // Clock signal for synchronous operation
    input rst,           // Asynchronous reset signal (active low)
    input Select,        // Select signal to control each bit's data source
    input [31:0] in,     // 32-bit input data to be stored
    output [31:0] Q      // 32-bit output register
);

// Generate variable for creating multiple instances
genvar i;

// Generate a 32-bit register by instantiating 32 one-bit registers
generate
    for (i = 0; i <= 31; i = i + 1) begin
        // Instantiate a one-bit register for each bit of the 32-bit register
        // Each bit of the input 'in' is connected to the corresponding one-bit register
        OneBitReg mod1 (
            .DataIn(in[i]),  // Connect the i-th bit of input 'in'
            .clk(clk),       // Connect the clock signal
            .rst(rst),       // Connect the reset signal
            .Select(Select), // Connect the select signal
            .Q(Q[i])         // Connect the i-th bit of the output 'Q'
        );
    end
endgenerate

endmodule
