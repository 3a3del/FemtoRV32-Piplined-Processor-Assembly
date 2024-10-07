`timescale 1ns / 1ps

// 64-bit register module
// Instantiates 64 one-bit registers to form a 32-bit register
module PIPI_REG #(parameter WIDTH=64)(
    input clk,           // Clock signal for synchronous operation
    input rst,           // Asynchronous reset signal (active low)
    input Select,        // Select signal to control each bit's data source
    input [WIDTH-1:0] in,     // 64-bit input data to be stored
    output [WIDTH-1:0] Q      // 64-bit output register
);

// Generate variable for creating multiple instances
genvar i;

// Generate a 64-bit register by instantiating 32 one-bit registers
generate
    for (i = 0; i < WIDTH; i = i + 1) begin
        // Instantiate a one-bit register for each bit of the 64-bit register
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
