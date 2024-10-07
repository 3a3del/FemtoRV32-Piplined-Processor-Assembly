`timescale 1ns / 1ps
module tb_MEM_EX_tb;

// Inputs
reg clk;
reg rst;
reg memtoreg_IDEX_out;
reg regwrite_IDEX_out;
reg memread_IDEX_out;
reg memwrite_IDEX_out;
reg branch_IDEX_out;
reg alusrc_IDEX_out;
reg i_type_IDEX_out;
reg lui_flag_IDEX_out;
reg jalr_fla_IDEX_out;
reg regwrite_MEMEX_out;
reg [1:0] aluop_IDEX_out;
reg [1:0] AJ_control_IDEX_out;
reg [31:0] IF_IDEX_PC_ID_out;
reg [31:0] readdata1_IDEX_out;
reg [31:0] readdata2_IDEX_out;
reg [31:0] gen_out_IDEX_out;
reg [31:0] adder1_IDEX;
reg [31:0] writingData_MEMWB;
reg [31:0] ALU_result_EX_out;
reg [3:0] function3_out_IDEX_out;
reg [4:0] WData_IDEX_out;
reg [4:0] RS1_IDEX;
reg [4:0] RS2_IDEX;
reg [4:0] WData_MEM_out;

// Outputs
wire memtoreg_MEMEX_out;
wire memread_MEMEX_out;
wire memwrite_MEMEX_out;
wire regwrite_MEMEX_out2;
wire [1:0] AJ_control_MEMEX_out;
wire [31:0] ALU_result_MEMEX_out;
wire [31:0] readdata2_MEMEX_out;
wire [31:0] adder1_IDEX_MEM;
wire [31:0] adder2_MEM;
wire [4:0] WData_MEMEX_out;
wire [3:0] function3_out_MEMEX_out;

// Instantiate the Unit Under Test (UUT)
MEM_EX uut (
    .clk(clk),
    .rst(rst),
    .memtoreg_IDEX_out(memtoreg_IDEX_out),
    .regwrite_IDEX_out(regwrite_IDEX_out),
    .memread_IDEX_out(memread_IDEX_out),
    .memwrite_IDEX_out(memwrite_IDEX_out),
    .branch_IDEX_out(branch_IDEX_out),
    .alusrc_IDEX_out(alusrc_IDEX_out),
    .i_type_IDEX_out(i_type_IDEX_out),
    .lui_flag_IDEX_out(lui_flag_IDEX_out),
    .jalr_fla_IDEX_out(jalr_fla_IDEX_out),
    .regwrite_MEMEX_out(regwrite_MEMEX_out),
    .aluop_IDEX_out(aluop_IDEX_out),
    .AJ_control_IDEX_out(AJ_control_IDEX_out),
    .IF_IDEX_PC_ID_out(IF_IDEX_PC_ID_out),
    .readdata1_IDEX_out(readdata1_IDEX_out),
    .readdata2_IDEX_out(readdata2_IDEX_out),
    .gen_out_IDEX_out(gen_out_IDEX_out),
    .adder1_IDEX(adder1_IDEX),
    .writingData_MEMWB(writingData_MEMWB),
    .ALU_result_EX_out(ALU_result_EX_out),
    .function3_out_IDEX_out(function3_out_IDEX_out),
    .WData_IDEX_out(WData_IDEX_out),
    .RS1_IDEX(RS1_IDEX),
    .RS2_IDEX(RS2_IDEX),
    .WData_MEM_out(WData_MEM_out),
    .memtoreg_MEMEX_out(memtoreg_MEMEX_out),
    .memread_MEMEX_out(memread_MEMEX_out),
    .memwrite_MEMEX_out(memwrite_MEMEX_out),
    .regwrite_MEMEX_out2(regwrite_MEMEX_out2),
    .AJ_control_MEMEX_out(AJ_control_MEMEX_out),
    .ALU_result_MEMEX_out(ALU_result_MEMEX_out),
    .readdata2_MEMEX_out(readdata2_MEMEX_out),
    .adder1_IDEX_MEM(adder1_IDEX_MEM),
    .adder2_MEM(adder2_MEM),
    .WData_MEMEX_out(WData_MEMEX_out),
    .function3_out_MEMEX_out(function3_out_MEMEX_out)
);

// Clock generation
always #10 clk = ~clk;  // Toggle clock every 5 ns

initial begin
    // Initialize Inputs
    clk = 0;
    rst = 0;  // Apply reset
    memtoreg_IDEX_out = 0;
    regwrite_IDEX_out = 0;
    memread_IDEX_out = 0;
    memwrite_IDEX_out = 0;
    branch_IDEX_out = 0;
    alusrc_IDEX_out = 0;
    i_type_IDEX_out = 0;
    lui_flag_IDEX_out = 0;
    jalr_fla_IDEX_out = 0;
    regwrite_MEMEX_out = 0;
    aluop_IDEX_out = 0;
    AJ_control_IDEX_out = 0;
    IF_IDEX_PC_ID_out = 32'h0;
    readdata1_IDEX_out = 32'h0;
    readdata2_IDEX_out = 32'h0;
    gen_out_IDEX_out = 32'h0;
    adder1_IDEX = 32'h0;
    writingData_MEMWB = 32'h0;
    ALU_result_EX_out = 32'h0;
    function3_out_IDEX_out = 4'b0;
    WData_IDEX_out = 5'h0;
    RS1_IDEX = 5'h0;
    RS2_IDEX = 5'h0;
    WData_MEM_out = 5'h0;

    rst = 1;  // De-assert reset

    // Test case 1: Simple operation
    memtoreg_IDEX_out = 1;
    regwrite_IDEX_out = 1;
    memread_IDEX_out = 0;
    memwrite_IDEX_out = 0;
    branch_IDEX_out = 0;
    alusrc_IDEX_out = 1;
    aluop_IDEX_out = 2'b10;
    readdata1_IDEX_out = 32'hA;
    readdata2_IDEX_out = 32'hB;
    gen_out_IDEX_out = 32'hF;
    adder1_IDEX = 32'h10;
    function3_out_IDEX_out = 4'b0000;
    RS1_IDEX = 5'ha;
    RS2_IDEX = 5'h7;
    WData_IDEX_out = 5'b00001;

    // Wait for a few clock cycles
    #20;

    // Test case 2: Simple operation
    memtoreg_IDEX_out = 1;
    regwrite_IDEX_out = 1;
    memread_IDEX_out = 0;
    memwrite_IDEX_out = 0;
    branch_IDEX_out = 0;
    alusrc_IDEX_out = 1;
    aluop_IDEX_out = 2'b10;
    readdata1_IDEX_out = 32'hC;
    readdata2_IDEX_out = 32'h7;
    gen_out_IDEX_out = 32'hC;
    adder1_IDEX = 32'h10;
    function3_out_IDEX_out = 4'b0000;
    RS1_IDEX = 5'h3;
    RS2_IDEX = 5'h8;
    WData_IDEX_out = 5'b00001;

#50;
    // Finish simulation
    $finish;
end

endmodule

