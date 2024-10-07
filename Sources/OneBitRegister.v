// 1-bit Register with select functionality
// Stores data based on the Select signal and clock, with asynchronous reset
module OneBitReg(
    input DataIn,    // Input data to be stored
    input clk,       // Clock signal for synchronous operation
    input rst,       // Asynchronous reset signal (active low)
    input Select,    // Select signal to choose between input data and current Q value
    output reg Q     // Output of the register
);

// Internal wire to hold the data to be stored
wire D;

// Synchronous reset and update of the register
// On the rising edge of the clock or when reset is asserted
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        // Asynchronous reset: clear the output Q to 0
        Q <= 1'b0;
    end else begin
        // Update the output Q with the value of D
        Q <= D;
    end
end

// Assign D based on the Select signal
// If Select is 1, D takes the value of DataIn
// If Select is 0, D takes the current value of Q (feedback loop)
assign D = (Select) ? DataIn : Q;

endmodule
