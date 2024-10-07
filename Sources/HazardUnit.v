`timescale 1ns / 1ps
module hazardunit(
input [4:0] RS1_IF_ID,
input [4:0] RD_ID_EX,
input [4:0] RS2_IF_ID,
input memread_ID_EX,
output PCstall,
output IFIDwrite,
output MUXsel
);
assign PCstall = ((RS1_IF_ID == RD_ID_EX | RS2_IF_ID == RD_ID_EX) && memread_ID_EX !=0 && RD_ID_EX != 0) ? 1 : 0;
assign IFIDwrite = ((RS1_IF_ID == RD_ID_EX | RS2_IF_ID == RD_ID_EX) && memread_ID_EX !=0 && RD_ID_EX != 0) ? 1 : 0;
assign MUXsel = ((RS1_IF_ID == RD_ID_EX | RS2_IF_ID == RD_ID_EX) && memread_ID_EX !=0 && RD_ID_EX != 0) ? 1 : 0;


endmodule