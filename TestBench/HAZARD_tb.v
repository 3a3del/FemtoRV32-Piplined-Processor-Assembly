`timescale 1ns / 1ps

module hazardunit_tb;

// Testbench signals
reg [4:0] RS1_IF_ID;     // 5-bit source register 1 from IF/ID stage
reg [4:0] RD_ID_EX;      // 5-bit destination register from ID/EX stage
reg [4:0] RS2_IF_ID;     // 5-bit source register 2 from IF/ID stage
reg memread_ID_EX;       // Memory read signal from ID/EX stage

wire PCstall;            // Output: PC stall
wire IFIDwrite;          // Output: IF/ID write enable
wire MUXsel;             // Output: MUX select for forwarding

// Expected values for verification
reg expected_PCstall;
reg expected_IFIDwrite;
reg expected_MUXsel;

// Instantiate the hazard unit
hazardunit uut (
    .RS1_IF_ID(RS1_IF_ID),
    .RD_ID_EX(RD_ID_EX),
    .RS2_IF_ID(RS2_IF_ID),
    .memread_ID_EX(memread_ID_EX),
    .PCstall(PCstall),
    .IFIDwrite(IFIDwrite),
    .MUXsel(MUXsel)
);

initial begin
    // Display header for results
    $display("Time\tRS1_IF_ID\tRD_ID_EX\tRS2_IF_ID\tmemread_ID_EX\tPCstall\tIFIDwrite\tMUXsel\tExpected_PCstall\tExpected_IFIDwrite\tExpected_MUXsel");

    // Test case 1: No hazard
    RS1_IF_ID = 5'b00001;
    RD_ID_EX = 5'b00000;
    RS2_IF_ID = 5'b00010;
    memread_ID_EX = 0;
    expected_PCstall = 0;
    expected_IFIDwrite = 0;
    expected_MUXsel = 0;
    #10 check_results();

    // Test case 2: Hazard detected (RS1 match)
    RS1_IF_ID = 5'b00001;
    RD_ID_EX = 5'b00001;
    RS2_IF_ID = 5'b00010;
    memread_ID_EX = 1;
    expected_PCstall = 1;
    expected_IFIDwrite = 1;
    expected_MUXsel = 1;
    #10 check_results();

    // Test case 3: Hazard detected (RS2 match)
    RS1_IF_ID = 5'b00001;
    RD_ID_EX = 5'b00010;
    RS2_IF_ID = 5'b00010;
    memread_ID_EX = 1;
    expected_PCstall = 1;
    expected_IFIDwrite = 1;
    expected_MUXsel = 1;
    #10 check_results();

    // Test case 4: No hazard (memread = 0)
    RS1_IF_ID = 5'b00001;
    RD_ID_EX = 5'b00001;
    RS2_IF_ID = 5'b00010;
    memread_ID_EX = 0;
    expected_PCstall = 0;
    expected_IFIDwrite = 0;
    expected_MUXsel = 0;
    #10 check_results();

    // Test case 5: No hazard (RD_ID_EX is 0)
    RS1_IF_ID = 5'b00001;
    RD_ID_EX = 5'b00000;
    RS2_IF_ID = 5'b00010;
    memread_ID_EX = 1;
    expected_PCstall = 0;
    expected_IFIDwrite = 0;
    expected_MUXsel = 0;
    #10 check_results();

    // Stop the simulation
    $stop;
end

// Task to check results
task check_results;
begin
    // Display the current state and results
    $display("%0t\t%b\t%b\t%b\t\t%b\t\t%b\t%b\t%b\t\t%b\t\t%b\t\t%b", 
             $time, RS1_IF_ID, RD_ID_EX, RS2_IF_ID, memread_ID_EX, 
             PCstall, IFIDwrite, MUXsel, 
             expected_PCstall, expected_IFIDwrite, expected_MUXsel);

    // Check if actual values match expected values
    if (PCstall !== expected_PCstall || IFIDwrite !== expected_IFIDwrite || MUXsel !== expected_MUXsel) begin
        $display("Test failed at time %0t!", $time);
    end else begin
        $display("Test passed at time %0t!", $time);
    end
end
endtask

endmodule

