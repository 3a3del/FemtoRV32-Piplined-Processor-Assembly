`timescale 1ns / 1ps
module Forward(
input [4:0] Rs1,
input [4:0]Rs2,
input [4:0] REXMEM,
input [4:0] RMEMWB,
input EXMEM_Regwrite,
input MEMWB_Regwrite,
output reg [1:0] FA,
output reg[1:0] FB
);
always@(*) begin
    if(EXMEM_Regwrite==1 && REXMEM!=0 && REXMEM==Rs1 )
    FA=2'b10;
    else if(MEMWB_Regwrite==1 && RMEMWB!=0 && RMEMWB==Rs1)
        FA=2'b01;
    else FA=2'b00;

    if(EXMEM_Regwrite==1 && REXMEM!=0 && REXMEM==Rs2 )
        FB=2'b10;
    else if(MEMWB_Regwrite==1 && RMEMWB!=0 && RMEMWB==Rs2)
        FB=2'b01;
    else FB=2'b00;
end

endmodule