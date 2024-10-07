`timescale 1ns / 1ps
module FourMux(
    input [31:0] A,           // Input A (32 bits)
    input [31:0] J,           // Input J (32 bits)
    input [31:0] E,           // Input E (32 bits)
    input [1:0] AJ_control,   // 2-bit control signal to select between inputs
    output reg [31:0] WD      // 32-bit output (selected value)
);

// Always block is sensitive to any change in inputs or control signal
always @(*) begin
    // Use case statement to determine output based on control signal (AJ_control)
    case (AJ_control)
        2'b00 : WD = E;       // If control signal is 00, output E
        2'b01 : WD = J;       // If control signal is 01, output J
        2'b11 : WD = A;       // If control signal is 11, output A
        default : WD = 0;     // Default case: output 0 if no valid selection
    endcase
end

endmodule
