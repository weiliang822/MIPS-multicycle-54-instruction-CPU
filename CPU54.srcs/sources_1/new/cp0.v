`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:50:26
// Design Name: 
// Module Name: cp0
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


module cp0(
input clk,
input rst,
input mfc0, // 指令为Mfc0 读cp0寄存器
input mtc0, // 指令为Mtc0 写cp0寄存器
input [31:0]pc,
input [4:0] Rd, // 指定 Cp0 寄存器
input [31:0] wdata, // 数据从GP寄存器到CP0寄存器
input exception,    //异常发生信号
input eret, // 指令ERET (Exception Return)
input [4:0]cause,
// input intr,
output [31:0] rdata, // 数据从CP0寄存器到GP寄存器
output [31:0] status,
// output reg timer_int,
output [31:0]exc_addr // 异常起始地址
);

reg [31:0]CP0_reg[31:0];
//三个寄存器地址
parameter status_reg = 'd12,cause_reg = 'd13,epc_reg = 'd14;
//中断屏蔽位
parameter IE_p = 'd0 , systcall_p = 'd1,break_p = 'd2,teq_p = 'd3;
//异常类型号
parameter systcall_func = 5'b01000,break_func = 5'b01001,teq_func = 5'b01101;

assign exc_addr = CP0_reg[epc_reg];         //异常起始地址
assign rdata = mfc0?CP0_reg[Rd]:32'hxxxxxxxx;      //读CP0
assign status = CP0_reg[status_reg];        //状态寄存器

always @(posedge clk,posedge rst)begin
    if(rst)begin
        CP0_reg[status_reg] <= 32'b1111; //复位为允许任何中断
        CP0_reg[cause_reg] <= 32'b0;
        CP0_reg[epc_reg] <= 32'b0;
    end
    else if(mtc0)
        CP0_reg[Rd] <= wdata;
    else if(eret)
        CP0_reg[status_reg] <= CP0_reg[status_reg] >> 5;    //中断返回时再将Status寄存器右移5位恢复其内容。
    else if(exception && CP0_reg[status_reg][IE_p])begin     //发生异常
        CP0_reg[epc_reg] <= pc;     //存放正在发生的指令的地址
        CP0_reg[status_reg] <= CP0_reg[status_reg] << 5;//我们不实现中断嵌套，所以相应中断异常时把 Status 寄存器的内容左移 5 位关中断
        CP0_reg[cause_reg][6:2] <= cause;
    end

end

endmodule
