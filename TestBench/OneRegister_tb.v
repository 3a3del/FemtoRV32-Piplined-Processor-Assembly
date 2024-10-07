`timescale 1ns / 1ps

module OneReg_tb;

// Inputs
reg clk;
reg rst;
reg Select;
reg [31:0] in;

// Outputs
wire [31:0] Q;

// Instantiate the Unit Under Test (UUT)
OneReg uut (
    .clk(clk), 
    .rst(rst), 
    .Select(Select), 
    .in(in), 
    .Q(Q)
);

// Clock generation
always #5 clk = ~clk; // 100 MHz clock

// Test sequence
initial begin
    // Initialize Inputs
    clk = 0;
    rst = 0;
    Select = 0;
    in = 32'h00000000;
    
    // Apply reset
    rst = 0;
    #10;
    rst = 1;
    #10;
    
    // Test case 1: Load data with Select = 1
    in = 32'hA5A5A5A5;
    Select = 1;
    #10;
    
    // Test case 2: Hold value with Select = 0
    Select = 0;
    #10;
    
    // Test case 3: Load new data with Select = 1
    in = 32'h5A5A5A5A;
    Select = 1;
    #10;

    // Test case 4: Apply reset and check output
    rst = 1;
    #10;
    rst = 0;
    #10;

    // Finish simulation
    $finish;
end

endmodule
