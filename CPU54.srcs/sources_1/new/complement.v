`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/10 16:21:26
// Design Name: 
// Module Name: complement
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module complement32(
    input ena,
    input sign,         //ÊäÈë·ûºÅ
    input [31:0] a,     //ÊäÈëÔ´Âë
    output [31:0] b     //Êä³ö²¹Âë
);
    assign b = ena?(sign? ((~a) + 1):a):'bz;
endmodule

module complement64(
    input ena,
    input sign,
    input [63:0] a,
    output [63:0] b
);
    assign b = ena?(sign? ((~a) + 1):a):'bz;
endmodule
