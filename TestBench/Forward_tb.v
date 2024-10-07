`timescale 1ns / 1ps

module Forward_tb;

// Testbench signals
reg [4:0] Rs1;           // 5-bit source register 1
reg [4:0] Rs2;           // 5-bit source register 2
reg [4:0] REXMEM;        // 5-bit destination register from EX/MEM stage
reg [4:0] RMEMWB;        // 5-bit destination register from MEM/WB stage
reg EXMEM_Regwrite;      // EX/MEM RegWrite control signal
reg MEMWB_Regwrite;      // MEM/WB RegWrite control signal

wire [1:0] FA;           // Forwarding control signal for ALU input A
wire [1:0] FB;           // Forwarding control signal for ALU input B

// Expected values for verification
reg [1:0] expected_FA;
reg [1:0] expected_FB;

// Instantiate the Forwarding unit
Forward uut (
    .Rs1(Rs1),
    .Rs2(Rs2),
    .REXMEM(REXMEM),
    .RMEMWB(RMEMWB),
    .EXMEM_Regwrite(EXMEM_Regwrite),
    .MEMWB_Regwrite(MEMWB_Regwrite),
    .FA(FA),
    .FB(FB)
);

initial begin
    // Display header for results
    $display("Time\tRs1\tRs2\tREXMEM\tRMEMWB\tEXMEM_Regwrite\tMEMWB_Regwrite\tFA\tFB\tExpected_FA\tExpected_FB");

    // Test case 1: No forwarding
    Rs1 = 5'b00001;
    Rs2 = 5'b00010;
    REXMEM = 5'b00000;
    RMEMWB = 5'b00000;
    EXMEM_Regwrite = 0;
    MEMWB_Regwrite = 0;
    expected_FA = 2'b00;
    expected_FB = 2'b00;
    #10 check_results();

    // Test case 2: Forward from EX/MEM to Rs1
    Rs1 = 5'b00001;
    Rs2 = 5'b00010;
    REXMEM = 5'b00001;
    RMEMWB = 5'b00000;
    EXMEM_Regwrite = 1;
    MEMWB_Regwrite = 0;
    expected_FA = 2'b10;
    expected_FB = 2'b00;
    #10 check_results();

    // Test case 3: Forward from MEM/WB to Rs2
    Rs1 = 5'b00001;
    Rs2 = 5'b00010;
    REXMEM = 5'b00000;
    RMEMWB = 5'b00010;
    EXMEM_Regwrite = 0;
    MEMWB_Regwrite = 1;
    expected_FA = 2'b00;
    expected_FB = 2'b01;
    #10 check_results();

    // Test case 4: Forward from EX/MEM to both Rs1 and Rs2
    Rs1 = 5'b00001;
    Rs2 = 5'b00010;
    REXMEM = 5'b00001;
    RMEMWB = 5'b00010;
    EXMEM_Regwrite = 1;
    MEMWB_Regwrite = 1;
    expected_FA = 2'b10;
    expected_FB = 2'b10;
    #10 check_results();

    // Test case 5: Forward from MEM/WB to both Rs1 and Rs2
    Rs1 = 5'b00011;
    Rs2 = 5'b00011;
    REXMEM = 5'b00000;
    RMEMWB = 5'b00011;
    EXMEM_Regwrite = 0;
    MEMWB_Regwrite = 1;
    expected_FA = 2'b01;
    expected_FB = 2'b01;
    #10 check_results();

    // Test case 6: No forwarding (EXMEM_Regwrite and MEMWB_Regwrite = 0)
    Rs1 = 5'b00011;
    Rs2 = 5'b00100;
    REXMEM = 5'b00011;
    RMEMWB = 5'b00100;
    EXMEM_Regwrite = 0;
    MEMWB_Regwrite = 0;
    expected_FA = 2'b00;
    expected_FB = 2'b00;
    #10 check_results();

    // Stop the simulation
    $stop;
end

// Task to check results
task check_results;
begin
    // Display the current state and results
    $display("%0t\t%b\t%b\t%b\t%b\t\t%b\t\t%b\t\t%b\t%b\t\t%b\t%b", 
             $time, Rs1, Rs2, REXMEM, RMEMWB, 
             EXMEM_Regwrite, MEMWB_Regwrite, 
             FA, FB, 
             expected_FA, expected_FB);

    // Check if actual values match expected values
    if (FA !== expected_FA || FB !== expected_FB) begin
        $display("Test failed at time %0t!", $time);
    end else begin
        $display("Test passed at time %0t!", $time);
    end
end
endtask

endmodule

