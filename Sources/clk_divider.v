`timescale 1ns / 1ps
module CLK_divid(input clk, input rst,  output Q );

assign Q = (!rst)? 0: ~clk;

endmodule
