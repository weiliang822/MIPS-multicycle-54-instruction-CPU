`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/05 20:33:55
// Design Name: 
// Module Name: mult
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


module mult(
 //input clk, // �˷���ʱ���ź�
 input reset, 
 input ena,
 input [31:0] a, // ���� a(������)
 input [31:0] b, // ���� b(����)
 output [63:0] res // �˻���� res
);
    wire [31:0] u_a;
    wire [31:0] u_b;
    wire z_sign;
    wire [63:0] u_z;
   
    complement32 c_a(ena,a[31],a,u_a);
    complement32 c_b(ena,b[31],b,u_b);
    multu unsigned_res(
        .reset(reset),
        .ena(ena),
        .a(u_a),
        .b(u_b),
        .res(u_z)
    );
    assign z_sign = a[31]^b[31];
    complement64 c_z(ena,z_sign,u_z,res);  

endmodule