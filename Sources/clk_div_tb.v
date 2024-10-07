`timescale 1ns / 1ps

module CLK_divider_tb;

// Testbench signals
reg clk;      // Clock signal
reg rst;      // Reset signal
wire Q;       // Divided clock output

// Instantiate the DUT (Device Under Test)
CLK_divider uut (
    .clk(clk),
    .rst(rst),
    .Q(Q)
);

// Clock generation (100MHz = 10ns period)
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle clock every 5ns -> 100MHz clock
end

// Test sequence
initial begin
    // Display header for output
    $display("Time\tclk\trst\tQ");

    // Initialize the signals
    rst = 0;  // Assert reset
    #10;      // Wait for 10ns
    rst = 1;  // Deassert reset after 10ns

    // Monitor output signals
    $monitor("%0t\t%b\t%b\t%b", $time, clk, rst, Q);

    // Test case 1: Apply reset and observe Q
    #20 rst = 0;  // Assert reset again at 20ns
    #10 rst = 1;  // Deassert reset at 30ns

    // Test case 2: Let clock run for some time
    #100;

    // Stop the simulation after some time
    #200 $stop;
end

endmodule

