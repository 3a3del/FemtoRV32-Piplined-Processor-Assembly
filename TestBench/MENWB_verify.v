`timescale 1ns / 1ps
module tb_MENWB_tb_test;

// Testbench signals
reg clk;
reg rst;
reg memtoreg_IDEX_out, regwrite_IDEX_out, memread_IDEX_out, memwrite_IDEX_out;
reg [1:0] AJ_control_IDEX_out;
reg [31:0] ALU_result;
reg [31:0] RD2_output;
reg [3:0] function3_out_IDEX_out;
reg [4:0] WData_IDEX_out;
reg [31:0] adder1_IDEX;
reg [31:0] adder2_EXMEM;
wire [31:0] regwrite_MEM_outt;

// Instantiate the DUT (Design Under Test)
MENWB_tb uut (
    .clk(clk),
    .rst(rst),
    .memtoreg_IDEX_out(memtoreg_IDEX_out),
    .regwrite_IDEX_out(regwrite_IDEX_out),
    .memread_IDEX_out(memread_IDEX_out),
    .memwrite_IDEX_out(memwrite_IDEX_out),
    .AJ_control_IDEX_out(AJ_control_IDEX_out),
    .ALU_result(ALU_result),
    .RD2_output(RD2_output),
    .function3_out_IDEX_out(function3_out_IDEX_out),
    .WData_IDEX_out(WData_IDEX_out),
    .adder1_IDEX(adder1_IDEX),
    .adder2_EXMEM(adder2_EXMEM),
    .regwrite_MEM_outt(regwrite_MEM_outt)
);

// Clock generation
initial begin
    clk = 0;
    forever #10 clk = ~clk; // Toggle clock every 5 time units
end

// Test stimulus
initial begin
    // Initialize inputs
    rst = 0;
    memtoreg_IDEX_out = 0;
    regwrite_IDEX_out = 0;
    memread_IDEX_out = 0;
    memwrite_IDEX_out = 0;
    AJ_control_IDEX_out = 2'b00;
    ALU_result = 32'h00000000;
    RD2_output = 32'h00000000;
    function3_out_IDEX_out = 4'b0000;
    WData_IDEX_out = 5'b00000;
    adder1_IDEX = 32'h00000000;
    adder2_EXMEM = 32'h00000000;

    // Reset deassertion
    #5 rst = 1;
    // Apply test vectors
    memtoreg_IDEX_out = 1;
    regwrite_IDEX_out = 1;
    memread_IDEX_out = 1;
    memwrite_IDEX_out = 0;
    AJ_control_IDEX_out = 2'b01;
    ALU_result = 32'hA5A5A5A5;
    RD2_output = 32'h5A5A5A5A;
    function3_out_IDEX_out = 4'b0010;
    WData_IDEX_out = 5'b10101;
    adder1_IDEX = 32'h00000010;
    adder2_EXMEM = 32'h00000020;

    // Wait for a few clock cycles
    #20;

    // Change inputs
    memtoreg_IDEX_out = 0;
    regwrite_IDEX_out = 0;
    memread_IDEX_out = 0;
    memwrite_IDEX_out = 1;
    AJ_control_IDEX_out = 2'b10;
    ALU_result = 32'hFFFF0000;
    RD2_output = 32'h0000FFFF;
    function3_out_IDEX_out = 4'b1000;
    WData_IDEX_out = 5'b01010;
    adder1_IDEX = 32'h00000030;
    adder2_EXMEM = 32'h00000040;

    // Wait for a few clock cycles
    #50;

    // End simulation
    $finish;
end

endmodule

