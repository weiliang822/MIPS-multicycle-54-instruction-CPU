`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/05 20:38:44
// Design Name: 
// Module Name: divu
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


module divu(
     input [31:0]dividend,         //被除数
     input [31:0]divisor,           //除数
     input start,                 //启动除法运算
     input clock,
     input reset,
     input ena,
     output [31:0]q,              //商
     output [31:0]r,              //余数    
     output reg busy                //除法器忙标志
);
    wire ready;
    reg [4:0] count;    //用于计数的寄存器，表示除法器的当前状态，初始值为5'b0。
    reg [31:0] reg_q;
    reg [31:0] reg_r;
    reg [31:0] reg_b;
    reg busy2, r_sign;     //忙标志和余数符号位的寄存器。
    assign ready = ~busy&busy2;
    wire [32:0] sub_add = r_sign? ({reg_r,q[31]} + {1'b0,reg_b}):({reg_r,q[31]} - {1'b0,reg_b});
    assign r = ena?(r_sign? reg_r + reg_b:reg_r):'bz;
    assign q = ena?reg_q:'bz;
    always@(posedge clock or posedge reset)
    begin
        if(reset)
        begin
            count <= 5'b0;
            busy <= 0;
            busy2 <= 0;
        end
        else
        begin
            busy2 <= busy;  //更新忙标志的寄存器，用于记录上一个时钟周期的忙标志状态。
            if(start)
            begin
                reg_r <= 32'b0;
                r_sign <= 0;
                reg_q <= dividend;
                reg_b <=divisor;
                count <= 5'b0;
                busy <= 1;
            end
            else if(busy)
            begin
                reg_r <= sub_add[31:0]; //更新余数的寄存器，根据余数的正负(r_sign)选择加法或减法运算的结果。
                r_sign <= sub_add[32];
                reg_q <= {reg_q[30:0],~sub_add[32]};//更新商的寄存器，将计算得到的商的最低位添加到商的高位。
                count <= count+1;
                if(count==5'd31) busy <= 0;
            end
        end
    end
endmodule