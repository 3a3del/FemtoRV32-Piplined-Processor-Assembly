module tb_OneBitReg;

// Testbench signals
reg DataIn;
reg clk;
reg rst;
reg Select;
wire Q;

// Instantiate the OneBitReg module
OneBitReg uut (
    .DataIn(DataIn),
    .clk(clk),
    .rst(rst),
    .Select(Select),
    .Q(Q)
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
    Select = 0;
    DataIn = 0;

    // Wait for a few clock cycles
    #10;

    // Apply reset
    rst = 0;
    #10;
    rst = 1;
    #10;

    // Test case 1: Load DataIn when Select is 1
    DataIn = 1;
    Select = 1;
    #10;
    // Check Q value
    if (Q !== 1) begin
        $display("Error: Expected Q = 1 but got Q = %b", Q);
    end else begin
        $display("Test Case 1 Passed: Q = %b", Q);
    end

    // Test case 2: Keep Q value when Select is 0
    Select = 0;
    DataIn = 0;
     #10;
    // Check Q value should still be 1 (from previous case)
    if (Q !== 1) begin
        $display("Error: Expected Q = 1 but got Q = %b", Q);
    end else begin
        $display("Test Case 2 Passed: Q = %b", Q);
    end

    // Test case 3: Change DataIn and select it
    DataIn = 0;
    Select = 1;
    #10;
    // Check Q value
    if (Q !== 0) begin
        $display("Error: Expected Q = 0 but got Q = %b", Q);
    end else begin
        $display("Test Case 3 Passed: Q = %b", Q);
    end

    // Test case 4: Apply reset and check Q value
    rst = 0;
    #10;
    rst = 1;
    #10;
    // Check Q value after reset
    if (Q !== 0) begin
        $display("Error: Expected Q = 0 but got Q = %b", Q);
    end else begin
        $display("Test Case 4 Passed: Q = %b", Q);
    end

    // Finish simulation
    $finish;
end

endmodule
