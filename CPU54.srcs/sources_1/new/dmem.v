`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/08 22:38:44
// Design Name: 
// Module Name: dmem
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

module dmem(
    input clk,
    input ena,
    input dm_w,
    input dm_r,
    input dm_sign,
    input [2:0]dm_size,
    input [11:0] dm_add,//10+2
    input [31:0] dm_wdata,
    output reg[31:0] dm_rdata
    );

    reg [31:0] d_mem[0:1023];
    //always @(posedge dm_W or dm_add or dm_wdata) begin
    always @(posedge clk) 
    if(ena)begin
        if (dm_w) begin
            if(dm_size[0])//8
                case(dm_add[1:0])
                    2'b00:d_mem[dm_add[11:2]][7:0]<=dm_wdata[7:0];
                    2'b01:d_mem[dm_add[11:2]][15:8]<=dm_wdata[7:0];
                    2'b10:d_mem[dm_add[11:2]][23:16]<=dm_wdata[7:0];
                    2'b11:d_mem[dm_add[11:2]][31:24]<=dm_wdata[7:0];
                endcase
            else if(dm_size[1])begin//16
                case(dm_add[1])
                    1'b0:d_mem[dm_add[11:2]][15:0]<=dm_wdata[15:0];
                    1'b1:d_mem[dm_add[11:2]][31:16]<=dm_wdata[15:0];
                endcase
            end else if(dm_size[2])begin//32
                d_mem[dm_add[11:2]]<=dm_wdata[31:0];
            end
        end else if(dm_r)begin
            if(dm_size[0])//8
                case(dm_add[1:0])
                    2'b00: dm_rdata <= {dm_sign ? {24{d_mem[dm_add[11:2]][7]}}:24'b0, d_mem[dm_add[11:2]][7:0]};
                    2'b01: dm_rdata <= {dm_sign ? {24{d_mem[dm_add[11:2]][15]}}:24'b0, d_mem[dm_add[11:2]][15:8]};
                    2'b10: dm_rdata <= {dm_sign ? {24{d_mem[dm_add[11:2]][23]}}:24'b0, d_mem[dm_add[11:2]][23:16]};
                    2'b11: dm_rdata <= {dm_sign ? {24{d_mem[dm_add[11:2]][31]}}:24'b0, d_mem[dm_add[11:2]][31:24]};
                endcase
            else if(dm_size[1])begin//16
                case(dm_add[1])
                    1'b0: dm_rdata <= {dm_sign ? {16{d_mem[dm_add[11:2]][15]}}:16'b0, d_mem[dm_add[11:2]][15:0]};
                    1'b1: dm_rdata <= {dm_sign ? {16{d_mem[dm_add[11:2]][31]}}:16'b0, d_mem[dm_add[11:2]][31:16]};
                endcase
            end else if(dm_size[2])begin//32
                dm_rdata <= d_mem[dm_add[11:2]];
            end    
        end
    end
endmodule


