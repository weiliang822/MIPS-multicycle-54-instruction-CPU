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
    input [31:0] a,         //操作数1
    input [31:0] b,         //操作数2
    input [3:0] aluc,       //运算器控制数
    input ena,              //使能信号
    output [31:0] r,        //运算结果
    output zero,            //0标志位，运算结果为0时置1
    output reg carry,       //加法进位、减法借位标志
    output negative,        //负数标志
    output reg overflow     //溢出标志
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
    wire signed [31:0]sa = a,sb = b;//有符号运算
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
                    overflow <= result[32]^result[31];//双符号位判溢出
                end
                Subu:begin
                    result <= {1'b0,a} - {1'b0,b};
                    carry <= result[32];
                end
                Sub: begin
                    result <= {a[31],a}-{b[31]+b};
                    sresult <= sa - sb;
                    overflow <= result[32]^result[31];//双符号位判溢出
                end
                Lui: 
                    result <= {1'b0,b[15:0],16'b0};//立即数放在寄存器的高16位
                And:
                    result <= a & b;
                Or:
                    result <= a | b; 
                Xor:
                    result <= a ^ b;
                Nor://或非
                    result <= ~(a | b);
                Slt:
                    result <= (sa<sb)?1:0;
                Sltu://verilog默认无符号数
                    result <= (a<b)?1:0;
                Sra://数学右移>>>，保留符号位
                    sresult <= sb >>> sa;
                Sll://逻辑左移
                    result <= b << a;
                Srl://逻辑右移
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
