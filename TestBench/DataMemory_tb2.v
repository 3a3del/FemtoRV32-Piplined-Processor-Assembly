
`timescale 1ns / 1ps

module DataMemory_tb;

    // Parameters for the DataMemory
    parameter MEM_FILE = "C:/Users/hp/Desktop/RISC/firmware/random_data.txt"; // Memory initialization file
    parameter DEPTH = 64; // Memory depth
    parameter WIDTH = 32; // Memory width

    // Testbench signals
    reg clk_tb; // Clock signal
    reg [5:0] adder_tb; // Address input
    reg MemRead_tb; // Memory read control signal
    reg MemWrite_tb; // Memory write control signal
    reg [WIDTH-1:0] data_in_tb; // Data to be written to memory
    reg [2:0] function3_tb; // Operation selector
    wire [WIDTH-1:0] data_out_tb; // Data output from memory

    // Instantiate the DataMemory module
    DataMemory #(
        .MEM_FILE(MEM_FILE),
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) uut (
        .clk(clk_tb),
        .adder(adder_tb),
        .MemRead(MemRead_tb),
        .MemWrite(MemWrite_tb),
        .data_in(data_in_tb),
        .function3(function3_tb),
        .data_out(data_out_tb)
    );

    // Clock generation: Toggle every 5ns (100MHz clock)
    initial begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb;
    end

    // Testbench stimulus
    initial begin
        // Initialize inputs
        MemRead_tb = 0;
        MemWrite_tb = 0;
        adder_tb = 0;
        data_in_tb = 0;
        function3_tb = 3'b000;

        // Wait for the memory initialization from the file
        #10;

        // Test 1: Check memory read (LW operation)
        adder_tb = 6'd0; // Read address 0
        MemRead_tb = 1;
        function3_tb = 3'b010; // LW operation (read full word)
        #10; // Wait for one clock cycle
        $display("Time = %0t, Addr = %0d, Data Read = %h", $time, adder_tb, data_out_tb);

        // Test 2: Check memory read (LB operation)
        adder_tb = 6'd1; // Read address 1
        function3_tb = 3'b000; // LB operation (read least significant byte)
        #10; // Wait for one clock cycle
        $display("Time = %0t, Addr = %0d, Data Read = %h", $time, adder_tb, data_out_tb);

        // Test 3: Memory write (SW operation)
        adder_tb = 6'd2; // Write address 2
        data_in_tb = 32'hA5A5A5A5; // Data to write
        MemWrite_tb = 1;
        function3_tb = 3'b010; // SW operation (write full word)
        #10; // Wait for one clock cycle
        MemWrite_tb = 0; // Disable write after operation

        // Test 4: Check memory read back (LW operation)
        adder_tb = 6'd2; // Read address 2
        MemRead_tb = 1;
        function3_tb = 3'b010; // LW operation (read full word)
        #10; // Wait for one clock cycle
        $display("Time = %0t, Addr = %0d, Data Read = %h", $time, adder_tb, data_out_tb);

        // Test 5: Byte write (SB operation)
        adder_tb = 6'd3;
        data_in_tb = 32'hFF; // Write the least significant byte
        MemWrite_tb = 1;
        function3_tb = 3'b000; // SB operation (write byte)
        #10; // Wait for one clock cycle
        MemWrite_tb = 0; // Disable write after operation

        // Test 6: Read back the byte (LB operation)
        MemRead_tb = 1;
        function3_tb = 3'b000; // LB operation (read byte)
        #10; // Wait for one clock cycle
        $display("Time = %0t, Addr = %0d, Data Read = %h", $time, adder_tb, data_out_tb);

        // End of the test
        #10;
        $finish;
    end

endmodule
