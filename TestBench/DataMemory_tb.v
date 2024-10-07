`timescale 1ns / 1ps
module tb_DataMemory;

// Parameters
parameter MEM_FILE = "C:/Users/hp/Desktop/RISC/firmware/random_data.txt";
parameter DEPTH = 64;
parameter WIDTH = 32;

// Testbench signals
reg clk;
reg [5:0] adder;
reg MemRead;
reg MemWrite;
reg [WIDTH-1:0] data_in;
reg [2:0] function3;
wire [WIDTH-1:0] data_out;

// Instantiate the DataMemory module
DataMemory #(MEM_FILE, DEPTH, WIDTH) uut (
    .clk(clk),
    .adder(adder),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .data_in(data_in),
    .function3(function3),
    .data_out(data_out)
);

// Clock generation
always begin
    #5 clk = ~clk; // 10 ns clock period
end

always @(MemWrite or MemRead) begin
    if (MemWrite && MemRead) begin
        $display("Error: Both MemWrite and MemRead are asserted at the same time at time %0t", $time);
        $stop; // Halts the simulation, allowing you to debug
    end
end

// Test procedure
initial begin
    // Initialize signals
    clk = 0;
    adder = 0;
    MemRead = 0;
    MemWrite = 0;
    data_in = 0;
    function3 = 0;

    // Wait for a few clock cycles
    #10;

    // Write to memory
    MemWrite = 1;
    function3 = 3'b010; // SW
    adder = 6'd1; // Address 1
    data_in = 32'h82345678;
    #10;

    // Read from memory
    MemWrite = 0;
    MemRead = 1;
    function3 = 3'b010; // LW
    #10;

    // Check output
    if (data_out !== 32'h82345678) begin
        $display("Error: Expected 32'h12345678 but got %h", data_out);
    end else begin
        $display("Read data: %h", data_out);
    end

    // Test LB (Load Byte)
    MemWrite = 0;
    MemRead = 1;
    function3 = 3'b000; // LB
    adder = 6'd1; // Address 1
    #10;
    if (data_out !== 32'hFFFFFF78) begin
        $display("Error: Expected 8'h78 but got %h", data_out);
    end else begin
        $display("Read byte data: %h", data_out);
    end

    // Test LBU (Load Byte Unsigned)
    function3 = 3'b100; // LBU
    #10;
    if (data_out !== {24'd0, 8'h78}) begin
        $display("Error: Expected 32'h00000078 but got %h", data_out);
    end else begin
        $display("Read unsigned byte data: %h", data_out);
    end

    // Test LH (Load Halfword)
    function3 = 3'b001; // LH
    #10;
    if (data_out !== 32'hFFFF5678) begin
        $display("Error: Expected 16'h5678 but got %h", data_out);
    end else begin
        $display("Read halfword data: %h", data_out);
    end

    // Test LHU (Load Halfword Unsigned)
    function3 = 3'b101; // LHU
    #10;
    if (data_out !== {16'd0, 16'h5678}) begin
        $display("Error: Expected 32'h00005678 but got %h", data_out);
    end else begin
        $display("Read unsigned halfword data: %h", data_out);
    end
    #5
    adder = 0;
    MemRead = 0;
    MemWrite = 0;
    data_in = 0;
    function3 = 0;

    // Wait for a few clock cycles
    #10;

    // Write to memory
    MemWrite = 1;
    function3 = 3'b010; // SW
    adder = 6'd1; // Address 1
    data_in = 32'h12345678;
    #10;

    // Read from memory
    MemWrite = 0;
    MemRead = 1;
    function3 = 3'b010; // LW
    #10;

    // Check output
    if (data_out !== 32'h12345678) begin
        $display("Error: Expected 32'h12345678 but got %h", data_out);
    end else begin
        $display("Read data: %h", data_out);
    end

    // Test LB (Load Byte)
    MemRead = 1;
    MemWrite = 0;
    function3 = 3'b000; // LB
    adder = 6'd1; // Address 1
    #10;
    if (data_out !== 8'h78) begin
        $display("Error: Expected 8'h78 but got %h", data_out);
    end else begin
        $display("Read byte data: %h", data_out);
    end

    // Test LBU (Load Byte Unsigned)
    function3 = 3'b100; // LBU
    #10;
    if (data_out !== {24'd0, 8'h78}) begin
        $display("Error: Expected 32'h00000078 but got %h", data_out);
    end else begin
        $display("Read unsigned byte data: %h", data_out);
    end

    // Test LH (Load Halfword)
    function3 = 3'b001; // LH
    #10;
    if (data_out !== 16'h5678) begin
        $display("Error: Expected 16'h5678 but got %h", data_out);
    end else begin
        $display("Read halfword data: %h", data_out);
    end

    // Test LHU (Load Halfword Unsigned)
    function3 = 3'b101; // LHU
    #10;
    if (data_out !== {16'd0, 16'h5678}) begin
        $display("Error: Expected 32'h00005678 but got %h", data_out);
    end else begin
        $display("Read unsigned halfword data: %h", data_out);
    end

    // Finish simulation
    $stop;
end

endmodule
