`timescale 1ns / 1ps

module IF_ID_verify;

// Testbench signals
reg clk;                           // Clock signal
reg rst;                           // Reset signal
reg [4:0] WData_IDEX_out;          // Input WData from IDEX stage
reg [31:0] PC_EXMEM;               // Input PC from EXMEM stage
reg memread_ID_ex;                 // Simulating memory read signal from EX stage

wire [31:0] PCout_IFID_out;        // Output PC from IFID stage
wire [31:0] ints_out_out;          // Output instruction from IFID stage
wire [31:0] adder1_IFID_out;       // Output from adder (PC + 4)
wire sclk;                         // Divided clock signal (from clock divider)

// Instantiate the DUT (Device Under Test)
IF_ID uut (
    .clk(clk),
    .rst(rst),
    .WData_IDEX_out(WData_IDEX_out),
    .PC_EXMEM(PC_EXMEM),
    .PCout_IFID_out(PCout_IFID_out),
    .ints_out_out(ints_out_out),
    .adder1_IFID_out(adder1_IFID_out)
);


// Clock generation (100MHz = 10ns period)
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle clock every 5ns -> 100MHz clock
end

// Test sequence
initial begin
    // Display header for output
    $display("Time\tPC_EXMEM\tPCout_IFID_out\tints_out_out\tadder1_IFID_out");

    // Initialize the signals
    rst = 0;  // Assert reset
    WData_IDEX_out = 5'b00000;
    PC_EXMEM = 32'b0;
    memread_ID_ex = 0;  // No memory read

    // Apply reset
    #10 rst = 1;  // Deassert reset after 10ns

    // Test case 1: Basic PC increment
    PC_EXMEM = 32'd1;  // Set PC value to 100
    #10;
    $display("%0t\t%d\t%d\t%d\t%d", $time, PC_EXMEM, PCout_IFID_out, ints_out_out, adder1_IFID_out);

    // Test case 2: Simulate a hazard detection
    PC_EXMEM = 32'd4;
    memread_ID_ex = 1;  // Memory read, hazard scenario
    #10;
    $display("%0t\t%d\t%d\t%d\t%d", $time, PC_EXMEM, PCout_IFID_out, ints_out_out, adder1_IFID_out);

    // Test case 3: Continue clock operation with no hazards
    PC_EXMEM = 32'd8;
    memread_ID_ex = 0;  // No memory read
    #20;
    $display("%0t\t%d\t%d\t%d\t%d", $time, PC_EXMEM, PCout_IFID_out, ints_out_out, adder1_IFID_out);

    // Stop the simulation after some time
    #100 $stop;
end

endmodule

