`timescale 1ns / 1ps

module Alu_tb;

    // Inputs
    reg [31:0] in1;
    reg [31:0] in2;
    reg [3:0] aluSel;
    reg [2:0] func3;

    // Outputs
    wire zero;
    wire [31:0] result;

    // Instantiate the ALU
    Alu uut (
        .in1(in1),
        .in2(in2),
        .aluSel(aluSel),
        .func3(func3),
        .zero(zero),
        .result(result)
    );

    initial begin
        // Initialize inputs
        in1 = 0;
        in2 = 0;
        aluSel = 0;
        func3 = 0;

        // Wait for global reset
        #10;
        
        // Test 1: ADD operation
        in1 = 32'h0000_000A;  // 10
        in2 = 32'h0000_0005;  // 5
        aluSel = 4'b0000;  // ADD
        #10;
        $display("Test 1: ADD, result = %d, zero = %b", result, zero);

        // Test 2: SUB operation
        aluSel = 4'b0001;  // SUB
        #10;
        $display("Test 2: SUB, result = %d, zero = %b", result, zero);

        // Test 3: AND operation
        aluSel = 4'b0101;  // AND
        #10;
        $display("Test 3: AND, result = %d, zero = %b", result, zero);

        // Test 4: OR operation
        aluSel = 4'b0100;  // OR
        #10;
        $display("Test 4: OR, result = %d, zero = %b", result, zero);

        // Test 5: XOR operation
        aluSel = 4'b0111;  // XOR
        #10;
        $display("Test 5: XOR, result = %d, zero = %b", result, zero);

        // Test 6: SRL operation
        aluSel = 4'b1000;  // SRL
        #10;
        $display("Test 6: SRL, result = %d, zero = %b", result, zero);

        // Test 7: SLL operation
        aluSel = 4'b1001;  // SLL
        #10;
        $display("Test 7: SLL, result = %d, zero = %b", result, zero);

        // Test 8: SLT operation
        aluSel = 4'b1101;  // SLT
        #10;
        $display("Test 8: SLT, result = %d, zero = %b", result, zero);

        // Test 11: SLTU operation
        in1 = 32'h0000_000A;  
        in2 = 32'hF000_0005; 
        aluSel = 4'b1111;  // SLTU
        #10;
        $display("Test 11: SLTU, result = %d, zero = %b", result, zero);

        // Test 9: BEQ (Branch Equal) with subtraction result = 0
        in1 = 32'h0000_000A;  // 10
        in2 = 32'h0000_000A;  // 10
        aluSel = 4'b0010;  // Branching
        func3 = 3'b000;  // BEQ
        #10;
        $display("Test 9: BEQ, zero = %b", zero);

        // Test 12: BNQ (Branch Equal) with subtraction result = 0
        in1 = 32'h0000_010A;  // 10
        in2 = 32'h0000_000A;  // 10
        aluSel = 4'b0010;  // Branching
        func3 = 3'b001;  // BNQ
        #10;
        $display("Test 9: BNQ, zero = %b", zero);

        // Test 10: BLT (Branch Less Than)
        in1 = 32'h0000_0005;  // 5
        in2 = 32'h0000_000A;  // 10
        func3 = 3'b100;  // BLT
        #10;
        $display("Test 10: BLT, zero = %b", zero);

        // Test 13: BLTU (Branch Less Than)
        in1 = 32'hF00_0005;  // 5
        in2 = 32'h0000_000A;  // 10
        func3 = 3'b100;  // BLTU
        #10;
        $display("Test 10: BLTU, zero = %b", zero);

        $finish;
    end

endmodule
