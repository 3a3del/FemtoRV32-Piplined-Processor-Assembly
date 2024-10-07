`timescale 1ns / 1ps

module tb_ID_verify;

// Inputs
reg clk;
reg rst;
reg [31:0] PC_EXMEM;
reg [31:0] adder2_WB;
reg [31:0] adder1_IDEX_WB;
reg [31:0] writingData;
reg MUXselect;
reg PC_stall;
reg IFID_write;
reg [1:0] AJ_control_MEM_out;
reg WD_MEMWB;

// Outputs
wire [3:0] function3_out_IDEX_out;
wire [31:0] readdata1_IDEX_out;
wire [31:0] readdata2_IDEX_out;
wire [31:0] IF_IDEX_PC_ID_out;
wire [31:0] gen_out_IDEX_out;
wire [4:0] WData_IDEX_out;
wire [4:0] RS1_IDEX;
wire [4:0] RS2_IDEX;
wire [31:0] adder1_IDEX;
wire [12:0] hazard_out;
// Instantiate the Unit Under Test (UUT)
ID_EX uut (
    .clk(clk), 
    .rst(rst), 
    .PC_EXMEM(PC_EXMEM), 
    .adder2_WB(adder2_WB), 
    .adder1_IDEX_WB(adder1_IDEX_WB), 
    .writingData(writingData), 
    .MUXselect(MUXselect), 
    .PC_stall(PC_stall), 
    .IFID_write(IFID_write), 
    .AJ_control_MEM_out(AJ_control_MEM_out), 
    .WD_MEMWB(WD_MEMWB), 
    .function3_out_IDEX_out(function3_out_IDEX_out), 
    .readdata1_IDEX_out(readdata1_IDEX_out), 
    .readdata2_IDEX_out(readdata2_IDEX_out), 
    .IF_IDEX_PC_ID_out(IF_IDEX_PC_ID_out), 
    .gen_out_IDEX_out(gen_out_IDEX_out), 
    .WData_IDEX_out(WData_IDEX_out), 
    .RS1_IDEX(RS1_IDEX), 
    .RS2_IDEX(RS2_IDEX), 
    .adder1_IDEX(adder1_IDEX),
    .hazard_out(hazard_out)
);

// Clock generation
initial begin
    clk = 0;
    forever #10 clk = ~clk;  // 10 ns clock period
end

// Stimulus
initial begin
    // Initialize inputs
    rst = 0;
    PC_EXMEM = 32'd0;
    adder2_WB = 0;
    adder1_IDEX_WB = 0;
    writingData = 0;
    MUXselect = 0;
    PC_stall = 0;
    IFID_write = 0;
    AJ_control_MEM_out = 2'b00;
    WD_MEMWB = 0;
    #5
    rst = 1;
    // Wait for global reset
    

    //PC_EXMEM = 32'h1;
   // adder2_WB = 32'h2000;
    //adder1_IDEX_WB = 32'h3000;
    //writingData = 32'h4000;
    //MUXselect = 1'b0; // No hazard
    //PC_stall = 1'b0;
    //IFID_write = 1'b0;
    //AJ_control_MEM_out = 2'b10;
    //WD_MEMWB = 1'b1;

    PC_EXMEM = 32'h4;
    adder2_WB = 32'h2560;
    adder1_IDEX_WB = 32'h3765;
    writingData = 32'h42323;
    MUXselect = 1'b1; // No hazard
    PC_stall = 1'b1;
    IFID_write = 1'b1;
    AJ_control_MEM_out = 2'b00;
    WD_MEMWB = 1'b1;
$display("function3_out_IDEX_out = %h, readdata1_IDEX_out = %h, readdata2_IDEX_out = %h, IF_IDEX_PC_ID_out = %h, gen_out_IDEX_out = %h, adder1_IDEX = %h, WData_IDEX_out = %h,RS1_IDEX = %h, RS2_IDEX = %h, hazard_out = %h",function3_out_IDEX_out,readdata1_IDEX_out,readdata2_IDEX_out,IF_IDEX_PC_ID_out,gen_out_IDEX_out,adder1_IDEX,WData_IDEX_out,RS1_IDEX,RS2_IDEX,hazard_out);


end
integer i;

always begin
for(i=0;i<=10;i=i+1) begin
#30;
PC_EXMEM = PC_EXMEM+32'd4;
end
$finish;
end

    


endmodule

