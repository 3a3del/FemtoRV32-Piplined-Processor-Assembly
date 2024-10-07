`timescale 1ns / 1ps

module Data_Path_tb;

// Testbench signals
reg clk_tb;      // Clock signal
reg rst_tb;      // Reset signal

// Instantiate the Data_Path module
Data_Path uut (
    .clk(clk_tb),
    .rst(rst_tb)
);

// Clock generation
always #5 clk_tb = ~clk_tb;  // Generate a clock with a period of 10ns (100 MHz)

// Test sequence
initial begin
    // Initialize signals
    clk_tb = 1'b0;
    rst_tb = 1'b0;
#10
rst_tb = 1'b1;

    #1000;
    $stop;
end

// Optional: Monitor signals
initial begin
    $monitor("Time=%0t | PCout=%h | ALU_result=%h | WritingData=%h | Zero=%b", 
              $time, uut.PCout, uut.ALU_result, uut.writingData, uut.zero);
end

endmodule
