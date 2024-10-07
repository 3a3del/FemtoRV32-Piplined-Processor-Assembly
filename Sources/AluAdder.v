module AluAdder(
    input [31:0] in1,       // First 32-bit input for the adder
    input [31:0] in2,       // Second 32-bit input for the adder
    output cout,            // Carry-out bit (overflow from the 32-bit addition)
    output [31:0] out       // 32-bit output result of the addition
);

// Perform addition and assign both the carry-out and the sum.
// The carry-out is the MSB of the result, and the sum is stored in 'out'.
assign {cout, out} = in1 + in2;

endmodule
