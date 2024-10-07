`timescale 1ns / 1ps
module ForwardMux(
input [31:0] in1, //aly gya 3ady mn el reg file
input [31:0] in2, //write_data_mux
input [31:0] in3, //ALU_result_EX_MEM
input [1:0] f,
output reg [31:0] out
);

always@(*) begin
    case (f)
    2'b00 :out=in1;
    2'b01 :out=in2;
    2'b10 :out=in3;
    default : out=0;
    endcase 
end 



endmodule