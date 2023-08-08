`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/05 17:36:16
// Design Name: 
// Module Name: hilo
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


module hilo(
    input clk,
    input rst,
    input hir,  //hi�Ĵ������ź�
    input lor,  //lo�Ĵ������ź�
    input hiw,  //hi�Ĵ���д�ź�
    input low,  //lo�Ĵ���д�ź�
    input [31:0]hi_wdata,
    input [31:0]lo_wdata,
    output reg [31:0]hi_rdata,
    output reg [31:0]lo_rdata
    );
    reg [31:0]hi_reg,lo_reg;
    always@(posedge clk,posedge rst)begin
        if(rst)begin
            hi_reg <= 32'b0;
            lo_reg <= 32'b0;
        end
        else begin
            if(hir)
                hi_rdata <= hi_reg;
            if(lor)
                lo_rdata <= lo_reg;
            if(hiw)
                hi_reg <= hi_wdata;
            if(low)
                lo_reg <= lo_wdata;
        end
    end
endmodule
