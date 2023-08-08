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
     input [31:0]dividend,         //������
     input [31:0]divisor,           //����
     input start,                 //������������
     input clock,
     input reset,
     input ena,
     output [31:0]q,              //��
     output [31:0]r,              //����    
     output reg busy                //������æ��־
);
    wire ready;
    reg [4:0] count;    //���ڼ����ļĴ�������ʾ�������ĵ�ǰ״̬����ʼֵΪ5'b0��
    reg [31:0] reg_q;
    reg [31:0] reg_r;
    reg [31:0] reg_b;
    reg busy2, r_sign;     //æ��־����������λ�ļĴ�����
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
            busy2 <= busy;  //����æ��־�ļĴ��������ڼ�¼��һ��ʱ�����ڵ�æ��־״̬��
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
                reg_r <= sub_add[31:0]; //���������ļĴ�������������������(r_sign)ѡ��ӷ����������Ľ����
                r_sign <= sub_add[32];
                reg_q <= {reg_q[30:0],~sub_add[32]};//�����̵ļĴ�����������õ����̵����λ��ӵ��̵ĸ�λ��
                count <= count+1;
                if(count==5'd31) busy <= 0;
            end
        end
    end
endmodule