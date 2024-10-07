// 32-bit multiplexer module
// Selects between two 32-bit inputs based on the MemToReg signal
module mux32Bit#(
    parameter WIDTH = 32  // Instruction width (32 bits)
)(
    input [WIDTH-1:0] in1,       // First 32-bit input
    input [WIDTH-1:0] in2,       // Second 32-bit input
    input MemToReg,         // Multiplexer control signal
    output [WIDTH-1:0] out       // 32-bit output
);

// Assign the output based on the value of MemToReg
// If MemToReg is 1, out is assigned in1
// If MemToReg is 0, out is assigned in2
assign out = (!MemToReg) ? in1 : in2;

endmodule
