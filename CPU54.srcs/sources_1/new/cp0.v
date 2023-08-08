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
input mfc0, // ָ��ΪMfc0 ��cp0�Ĵ���
input mtc0, // ָ��ΪMtc0 дcp0�Ĵ���
input [31:0]pc,
input [4:0] Rd, // ָ�� Cp0 �Ĵ���
input [31:0] wdata, // ���ݴ�GP�Ĵ�����CP0�Ĵ���
input exception,    //�쳣�����ź�
input eret, // ָ��ERET (Exception Return)
input [4:0]cause,
// input intr,
output [31:0] rdata, // ���ݴ�CP0�Ĵ�����GP�Ĵ���
output [31:0] status,
// output reg timer_int,
output [31:0]exc_addr // �쳣��ʼ��ַ
);

reg [31:0]CP0_reg[31:0];
//�����Ĵ�����ַ
parameter status_reg = 'd12,cause_reg = 'd13,epc_reg = 'd14;
//�ж�����λ
parameter IE_p = 'd0 , systcall_p = 'd1,break_p = 'd2,teq_p = 'd3;
//�쳣���ͺ�
parameter systcall_func = 5'b01000,break_func = 5'b01001,teq_func = 5'b01101;

assign exc_addr = CP0_reg[epc_reg];         //�쳣��ʼ��ַ
assign rdata = mfc0?CP0_reg[Rd]:32'hxxxxxxxx;      //��CP0
assign status = CP0_reg[status_reg];        //״̬�Ĵ���

always @(posedge clk,posedge rst)begin
    if(rst)begin
        CP0_reg[status_reg] <= 32'b1111; //��λΪ�����κ��ж�
        CP0_reg[cause_reg] <= 32'b0;
        CP0_reg[epc_reg] <= 32'b0;
    end
    else if(mtc0)
        CP0_reg[Rd] <= wdata;
    else if(eret)
        CP0_reg[status_reg] <= CP0_reg[status_reg] >> 5;    //�жϷ���ʱ�ٽ�Status�Ĵ�������5λ�ָ������ݡ�
    else if(exception && CP0_reg[status_reg][IE_p])begin     //�����쳣
        CP0_reg[epc_reg] <= pc;     //������ڷ�����ָ��ĵ�ַ
        CP0_reg[status_reg] <= CP0_reg[status_reg] << 5;//���ǲ�ʵ���ж�Ƕ�ף�������Ӧ�ж��쳣ʱ�� Status �Ĵ������������� 5 λ���ж�
        CP0_reg[cause_reg][6:2] <= cause;
    end

end

endmodule
