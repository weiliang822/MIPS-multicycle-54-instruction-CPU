`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/06 20:15:27
// Design Name: 
// Module Name: sccomp_dataflow
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

module sccomp_dataflow(
    input clk_in,
    input reset,
     output [31:0] inst,
     output [31:0] pc
/*    output [7:0] o_seg,  //数码管显示
	output [7:0] o_sel  //数码管选择*/
);

//    wire [31:0]inst;
//    wire [31:0] pc;
    wire [31:0] im_add;
    assign im_add = pc - 32'h0040_0000;
    wire dm_w,dm_r,dm_sign;
    wire [2:0]dm_size;
    wire [11:0]dm_add;
    wire [31:0]dm_rdata,dm_wdata;

    wire clk;
    imem imem(
        .im_add(im_add[12:2]),
        .inst(inst)
    );

    dmem dmem(
        .clk(clk_in),
        .ena(dm_w|dm_r),
        .dm_w(dm_w),
        .dm_r(dm_r),
        .dm_sign(dm_sign),
        .dm_size(dm_size),
        .dm_add(dm_add),
        .dm_wdata(dm_wdata),
        .dm_rdata(dm_rdata)
    );

    cpu54 sccpu(
        .clk(clk_in),
        .rst(reset),
        .ena('b1),
        .inst(inst),
        .pc(pc),
        .dm_w(dm_w),
        .dm_r(dm_r),
        .dm_sign(dm_sign),
        .dm_size(dm_size),
        .dm_wdata(dm_wdata),
        .dm_rdata(dm_rdata),
        .dm_add(dm_add)
    );

//    //下板

//    reg clk_r;

//    //分频器
//    reg clk_r;
//    reg [20:0]cnt;
//    always @(posedge clk_in or posedge reset)begin
//        if(reset)begin
//            cnt <= 0;
//            //clk_r <= clk_in;      
//        end
//        else if(cnt == 400000)begin
//            clk_r <= ~clk_r;
//            cnt <= 0;
//        end
//        else
//            cnt <= cnt + 1;
//    end
    
//    assign clk = clk_r;

//    seg7x16 uut(
//        .clk(clk_in),
//        .reset(reset),
//        .cs(1'b1),
//        .i_data(pc),
//        .o_seg(o_seg),
//        .o_sel(o_sel)
//    );

endmodule
