`timescale 1ns / 1ps // Time unit and precision for simulation

// 32-bit left shift module
// Shifts the 32-bit input left by one bit, inserting a 0 at the least significant bit position
module shiftLeft(
    input [31:0] in,   // 32-bit input data to be shifted
    output [31:0] out  // 32-bit output data after shifting
);

// Assign the output as the input shifted left by one bit
// The most significant bit is retained, and a 0 is inserted at the least significant bit
assign out = {in[30:0], 1'b0}; // Concatenate the 31 most significant bits of 'in' with a 0

endmodule
