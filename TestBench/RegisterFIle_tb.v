`timescale 1ns / 1ps

module tb_RegisterFile;

// Parameters
parameter N = 32;

// Testbench signals
reg clk;
reg rst;
reg WR;
reg [4:0] RReg1;
reg [4:0] RReg2;
reg [4:0] WReg;
reg [N-1:0] WDATA;
wire [N-1:0] RD1;
wire [N-1:0] RD2;

// Instantiate the RegisterFile module
RegisterFile #(N) uut (
    .clk(clk),
    .rst(rst),
    .WR(WR),
    .RReg1(RReg1),
    .RReg2(RReg2),
    .WReg(WReg),
    .WDATA(WDATA),
    .RD1(RD1),
    .RD2(RD2)
);

// Clock generation
always begin
    #5 clk = ~clk; // 10 ns clock period
end

// Test procedure
initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    WR = 0;
    RReg1 = 0;
    RReg2 = 0;
    WReg = 0;
    WDATA = 0;

    // Apply reset
    rst = 0;
    #10;
    rst = 1;
    #10;

    // Test case 1: Write to register 5
    WR = 1;
    WReg = 5;
    WDATA = 32'hDEADBEEF;
    #10;
    WR = 0; // Disable write

    // Test case 2: Read from register 5
    RReg1 = 5;
    #10;
    if (RD1 !== 32'hDEADBEEF) begin
        $display("Error: Expected RD1 = DEADBEEF, but got RD1 = %h", RD1);
    end else begin
        $display("Test Case 2 Passed: RD1 = %h", RD1);
    end

    // Test case 3: Write to register 10 and read from it
    WR = 1;
    WReg = 10;
    WDATA = 32'hCAFEBABE;
    #10;
    WR = 0; // Disable write

    RReg2 = 10;
    #10;
    if (RD2 !== 32'hCAFEBABE) begin
        $display("Error: Expected RD2 = CAFEBABE, but got RD2 = %h", RD2);
    end else begin
        $display("Test Case 3 Passed: RD2 = %h", RD2);
    end

    // Test case 4: Read from an uninitialized register
    RReg1 = 15;
    #10;
    if (RD1 !== 0) begin
        $display("Error: Expected RD1 = 00000000, but got RD1 = %h", RD1);
    end else begin
        $display("Test Case 4 Passed: RD1 = %h", RD1);
    end

    // Finish simulation
    $finish;
end

endmodule
