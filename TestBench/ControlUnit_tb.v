module ContUnit_tb;

  // Inputs
  reg [6:2] opcode;

  // Outputs
  wire branch;
  wire memread;
  wire memwrite;
  wire memtoreg;
  wire [1:0] aluop;
  wire regwrite;
  wire alusrc;
  wire i_type;
  wire [1:0] AJ_control;
  wire lui_fla;

  // Instantiate the Unit Under Test (UUT)
  ContUnit uut (
             .opcode(opcode),
             .branch(branch),
             .memread(memread),
             .memwrite(memwrite),
             .memtoreg(memtoreg),
             .aluop(aluop),
             .regwrite(regwrite),
             .alusrc(alusrc),
             .i_type(i_type),
             .AJ_control(AJ_control),
             .lui_fla(lui_fla)
           );

  // Task to compare outputs and expected results
  task check_output;
    input reg exp_branch;
    input reg exp_memread;
    input reg exp_memwrite;
    input reg exp_memtoreg;
    input reg [1:0] exp_aluop;
    input reg exp_regwrite;
    input reg exp_alusrc;
    input reg exp_i_type;
    input reg [1:0] exp_AJ_control;
    input reg exp_lui_fla;

    if (branch === exp_branch &&
        memread === exp_memread &&
        memwrite === exp_memwrite &&
        memtoreg === exp_memtoreg &&
        aluop === exp_aluop &&
        regwrite === exp_regwrite &&
        alusrc === exp_alusrc &&
        i_type === exp_i_type &&
        AJ_control === exp_AJ_control &&
        lui_fla === exp_lui_fla)
    begin
      $display("Test passed for opcode: %b", opcode);
    end
    else
    begin
      $display("Test failed for opcode: %b", opcode);
    end
  endtask

  initial
  begin
    // Test case for 01100 (Add, Sub, etc.)
    opcode = 5'b01100;
    #10;
    check_output(1'b0, 1'b0, 1'b0, 1'b0, 2'b10, 1'b1, 1'b0, 1'b0, 2'b00, 1'b0);

    // Test case for 00000 (lw, lb, lh, etc.)
    opcode = 5'b00000;
    #10;
    check_output(1'b0, 1'b1, 1'b0, 1'b1, 2'b00, 1'b1, 1'b1, 1'b1, 2'b00, 1'b0);

    // Test case for 01000 (sw, sb, sh)
    opcode = 5'b01000;
    #10;
    check_output(1'b0, 1'b0, 1'b1, 1'b1, 2'b00, 1'b1, 1'b1, 1'b1, 2'b00, 1'b0);

    // Test case for 11000 (beq, bnq, etc.)
    opcode = 5'b11000;
    #10;
    check_output(1'b1, 1'b0, 1'b0, 1'b1, 2'b01, 1'b0, 1'b0, 1'b1, 2'b00, 1'b0);

    // Test case for 00100 (Addi, Subi, etc.)
    opcode = 5'b00100;
    #10;
    check_output(1'b0, 1'b0, 1'b0, 1'b0, 2'b10, 1'b1, 1'b1, 1'b1, 2'b00, 1'b0);

    // Test case for 11011 (jal)
    opcode = 5'b11011;
    #10;
    check_output(1'b1, 1'b0, 1'b0, 1'b0, 2'b11, 1'b1, 1'b1, 1'b1, 2'b00, 1'b0);

    // Test case for 11001 (jalr)
    opcode = 5'b11001;
    #10;
    check_output(1'b0, 1'b0, 1'b0, 1'b0, 2'b11, 1'b1, 1'b1, 1'b1, 2'b01, 1'b0);

    // Test case for 00101 (auipc)
    opcode = 5'b00101;
    #10;
    check_output(1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1, 1'b1, 1'b1, 2'b11, 1'b0);

    // Test case for 01101 (lui)
    opcode = 5'b01101;
    #10;
    check_output(1'b0, 1'b0, 1'b0, 1'b0, 2'b10, 1'b1, 1'b1, 1'b0, 2'b00, 1'b1);

    $finish;
  end

endmodule
