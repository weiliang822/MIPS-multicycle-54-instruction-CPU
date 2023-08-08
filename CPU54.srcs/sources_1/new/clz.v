`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// EngAeer: 
// 
// Create Date: 2023/07/05 19:54:24
// Design Name: 
// Module Name: clz
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


module clz(
    input ena,
    input [31:0]A,
    output reg[5:0]res
    );

    always@(*)
    begin
        if(!ena) res<='bz;
        else if(A[31]) res<=32'd0;
        else if(A[30]) res<=32'd1;
        else if(A[29]) res<=32'd2;
        else if(A[28]) res<=32'd3;
        else if(A[27]) res<=32'd4;
        else if(A[26]) res<=32'd5;
        else if(A[25]) res<=32'd6;
        else if(A[24]) res<=32'd7;
        else if(A[23]) res<=32'd8;
        else if(A[22]) res<=32'd9;
        else if(A[21]) res<=32'd10;
        else if(A[20]) res<=32'd11;
        else if(A[19]) res<=32'd12;
        else if(A[18]) res<=32'd13;
        else if(A[17]) res<=32'd14;
        else if(A[16]) res<=32'd15;
        else if(A[15]) res<=32'd16;
        else if(A[14]) res<=32'd17;
        else if(A[13]) res<=32'd18;
        else if(A[12]) res<=32'd19;
        else if(A[11]) res<=32'd20;
        else if(A[10]) res<=32'd21;
        else if(A[9]) res<=32'd22;
        else if(A[8]) res<=32'd23;
        else if(A[7]) res<=32'd24;
        else if(A[6]) res<=32'd25;
        else if(A[5]) res<=32'd26;
        else if(A[4]) res<=32'd27;
        else if(A[3]) res<=32'd28;
        else if(A[2]) res<=32'd29;
        else if(A[1]) res<=32'd30;
        else if(A[0]) res<=32'd31;
        else res<=32'd32;
    end
endmodule
