`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/05 20:39:48
// Design Name: 
// Module Name: div
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


module div(
    input [31:0]dividend,         //被除数
    input [31:0]divisor,           //除数
    input start,                 //启动除法运算
    input clock,
    input reset,
    input ena,
    output [31:0]q,              //商
    output [31:0]r,              //余数    
    output busy                //除法器忙标志
    );
    wire [31:0]u_dividend;
    wire [31:0]u_divisor;
    wire [31:0]u_q;
    wire [31:0]u_r;
    complement32 c_dividend(ena,dividend[31],dividend,u_dividend);
    complement32 c_divisor(ena,divisor[31],divisor,u_divisor);
    divu divison_unit(u_dividend,u_divisor,start,clock,reset,ena,u_q,u_r,busy);
    wire s_same;
    assign s_same = ~(dividend[31] ^ divisor[31]);
    complement32 c_q(ena,~s_same,u_q,s_q);
    complement32 c_r(ena,dividend[31],u_r,s_r);
endmodule