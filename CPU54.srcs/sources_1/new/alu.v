`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/05 16:22:32
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] a,         //������1
    input [31:0] b,         //������2
    input [3:0] aluc,       //������������
    input ena,              //ʹ���ź�
    output [31:0] r,        //������
    output zero,            //0��־λ��������Ϊ0ʱ��1
    output reg carry,       //�ӷ���λ��������λ��־
    output negative,        //������־
    output reg overflow     //�����־
    );
    parameter Addu = 4'b0000;    
    parameter Add  = 4'b0010;    
    parameter Subu = 4'b0001;    
    parameter Sub  = 4'b0011;    
    parameter And  = 4'b0100;    
    parameter Or   = 4'b0101;    
    parameter Xor  = 4'b0110;    
    parameter Nor  = 4'b0111;    
    parameter Lui  = 4'b1000;       
    parameter Slt  = 4'b1011;    
    parameter Sltu = 4'b1010;    
    parameter Sra  = 4'b1100;    
    parameter Sll  = 4'b1110;    
    parameter Srl  = 4'b1101;       

    reg [32:0] result;
    reg signed[31:0] sresult;
    wire signed [31:0]sa = a,sb = b;//�з�������
    always @(*)begin
        if(ena)begin
            case(aluc)
                Addu:begin
                    result <= {1'b0,a} + {1'b0,b};
                    carry <= result[32];
                end
                Add:begin
                    result <= {a[31],a}+{b[31]+b};
                    sresult <= sa + sb;
                    overflow <= result[32]^result[31];//˫����λ�����
                end
                Subu:begin
                    result <= {1'b0,a} - {1'b0,b};
                    carry <= result[32];
                end
                Sub: begin
                    result <= {a[31],a}-{b[31]+b};
                    sresult <= sa - sb;
                    overflow <= result[32]^result[31];//˫����λ�����
                end
                Lui: 
                    result <= {1'b0,b[15:0],16'b0};//���������ڼĴ����ĸ�16λ
                And:
                    result <= a & b;
                Or:
                    result <= a | b; 
                Xor:
                    result <= a ^ b;
                Nor://���
                    result <= ~(a | b);
                Slt:
                    result <= (sa<sb)?1:0;
                Sltu://verilogĬ���޷�����
                    result <= (a<b)?1:0;
                Sra://��ѧ����>>>����������λ
                    sresult <= sb >>> sa;
                Sll://�߼�����
                    result <= b << a;
                Srl://�߼�����
                    result <= b >> a;
                
            endcase
        end
    end

    assign r = (aluc==Add||aluc==Sub||aluc==Sra)?sresult[31:0]:result[31:0];
    assign zero = r?0:1;
    assign negative = (aluc==Sub||aluc==Sra||aluc==Add)?r[31]:0;

    // always @(*)
    //     $display("a:%h b:%h sa:%h sb:%h result:%h sresult:%h r:%h",a,b,sa,sb,result,sresult,r);

endmodule
