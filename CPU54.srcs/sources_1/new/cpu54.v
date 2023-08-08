`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/05 16:22:45
// Design Name: 
// Module Name: cpu54
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


module cpu54(
    input clk,              //ʱ��
    input rst,              //��λ
    input ena,              //ʹ��
    input [31:0]inst,       //ָ��
    output reg [31:0] pc,   //ָ���ַ
    output dm_w,            //�ڴ�д
    output dm_r,            //�ڴ��
    output dm_sign,
    output [2:0]dm_size,
    output reg[31:0]dm_wdata,  //�ڴ������
    input [31:0]dm_rdata,   //�ڴ�д����
    output reg[11:0]dm_add     //�ڴ��ַ��������coe�ļ�ֻ��Ҫ��ô��ĵ�ַ
    );
    wire [5:0]OP,func;
    assign OP = inst[31:26];
    assign func = inst[5:0];//����

    wire add_, addu_, sub_, subu_, and_, or_, xor_, nor_;
    wire slt_, sltu_, sll_, srl_, sra_, sllv_, srlv_, srav_, jr_;
    assign add_ = (OP == 0 && func == 6'b100_000);
    assign addu_ = (OP == 0 && func == 6'b100_001);
    assign sub_ = (OP == 0 && func == 6'b100_010);
    assign subu_ = (OP == 0 && func == 6'b100_011);
    assign and_ = (OP == 0 && func == 6'b100_100);
    assign or_ = (OP == 0 && func == 6'b100_101);
    assign xor_ = (OP == 0 && func == 6'b100_110);
    assign nor_ = (OP == 0 && func == 6'b100_111);
    assign slt_ = (OP == 0 && func == 6'b101_010);
    assign sltu_ = (OP == 0 && func == 6'b101_011);
    assign sll_ = (OP == 0 && func == 6'b000_000);
    assign srl_ = (OP == 0 && func == 6'b000_010);
    assign sra_ = (OP == 0 && func == 6'b000_011);
    assign sllv_ = (OP == 0 && func == 6'b000_100);
    assign srlv_ = (OP == 0 && func == 6'b000_110);
    assign srav_ = (OP == 0 && func == 6'b000_111);
    assign jr_ = (OP == 0 && func == 6'b001_000);
    
    wire addi_, addiu_, andi_, ori_, xori_, lw_, sw_, beq_, bne_;
    wire slti_, sltiu_, lui_;
    assign addi_ = (OP == 6'b001_000);
    assign addiu_ = (OP == 6'b001_001);
    assign andi_ = (OP == 6'b001_100);
    assign ori_ = (OP == 6'b001_101);
    assign xori_ = (OP == 6'b001_110);
    assign lw_ = (OP == 6'b100_011);
    assign sw_ = (OP == 6'b101_011);
    assign beq_ = (OP == 6'b000_100);
    assign bne_ = (OP == 6'b000_101);
    assign slti_ = (OP == 6'b001_010);
    assign sltiu_ = (OP == 6'b001_011);
    assign lui_ = (OP == 6'b001_111);
    wire j_,jal_;
    assign j_ = (OP == 6'b000_010);
    assign jal_ = (OP==6'b000_011);

    wire clz_,divu_,eret_,jalr_,lb_,lbu_,lhu_,sb_,sh_;
    wire lh_,mfc0_,mfhi_,mflo_,mtc0_,mtho_,mtlo_,mul_,multu_,syscall_,teq_,bgez_,break_,div_;
    assign clz_ = (OP == 6'b011_100 && func == 6'b100_000);
    assign divu_ = (OP==6'b0 && func == 6'b011_011);
    assign eret_ = (OP == 6'b010000 && func == 6'b011_000);
    assign jalr_ = (OP==6'b000000 && func == 6'b001_001);
    assign lb_ = (OP == 6'b100_000);
    assign lbu_ = (OP == 6'b100_100);
    assign lhu_ = (OP== 6'b100_101);
    assign sb_ = (OP == 6'b101_000);
    assign sh_ = (OP == 6'b101_001);

    assign lh_ = (OP == 6'b100_001);
    assign mfc0_ = (OP==6'b010000 && inst[25:21] == 5'b00000);
    assign mtc0_ = (OP==6'b010000 && inst[25:21] == 5'b00100);
    assign mfhi_ = (OP==6'b0 && func == 6'b010000);
    assign mthi_ = (OP==6'b0 && func == 6'b010001);
    assign mflo_ = (OP==6'b0 && func == 6'b010010);
    assign mtlo_ = (OP==6'b0 && func == 6'b010011);                
    assign mul_ = (OP==6'b011100 && func == 6'b000010);
    assign multu_ =(OP==6'b0 && func==6'b011_001);
    assign syscall_ = (OP == 6'b0 && func == 6'b001100);
    assign break_ = (OP== 6'b0 && func == 6'b001101);
    assign teq_ = (OP==6'b0 && func == 6'b110100);
    assign bgez_ = (OP == 6'b000001);
    assign div_ = (OP==6'b0 && func == 6'b011_010);
    
    reg [4:0]Rsc,Rtc,Rdc;

    wire [3:0]aluc;//alu�����ź�
    assign aluc[0] = subu_ | sub_| beq_|bne_| or_ |ori_| nor_ | slt_ | slti_ | srl_ | srlv_;
    assign aluc[1] = add_ | addi_ | sub_ | beq_|bne_| xor_ | xori_ | nor_ | slt_ | slti_ | sltu_ | sltiu_ | sll_ | sllv_;
    assign aluc[2] = and_ | andi_ | or_ | ori_ |xor_ | xori_ |nor_ | sra_|srav_ | sll_ |sllv_|srl_|srlv_;
    assign aluc[3] = lui_|slt_|slti_|sltu_|sltiu_|sra_|srav_|sll_|sllv_|srl_|srlv_;

    wire is_shamt;
    assign is_shamt = sll_ | srl_ | sra_;//�Ƿ���shamt����

    wire [31:0]rs,rt,rd;//rs,rt�ǼĴ���ȡ������a,b��д��alu�Ĳ�������rd��Ҫд��Ĵ������� 
    reg [31:0]a,b;
    wire [31:0]res;//������������
    
    wire zf,cf,nf,vf;//alu��־λ

    reg Rf_w;//�Ƿ񽫴�д��Ĵ���

    wire alu_ena; //alu��ʹ���ź�
    assign alu_ena = addi_ | addiu_ | andi_ | ori_ | sltiu_ | lui_ | xori_ | slti_ | addu_ | 
            and_ | xor_ | nor_ | or_ | sll_ | sllv_ | sltu_ | sra_ | 
            srl_ | subu_ | add_ | sub_ | slt_ | srlv_ | srav_; 

    reg [31:0]jal_res;

    //cp0�쳣���ͺ�
    parameter systcall_func = 5'b01000,break_func = 5'b01001,teq_func = 5'b01101;
    wire[4:0]cp0_cause;
    wire[31:0]cp0_rdata,cp0_status,cp0_exc_addr;
    assign cp0_cause = syscall_?systcall_func:(break_?break_func:(teq_?teq_func:'bz));
    cp0 cp0(
        .clk(clk),  //ʱ�������ظı����ݣ��½��ظı�PC��
        .rst(rst),  //�ߵ�ƽ���и�λ
        .mfc0(mfc0_), // ָ��Ϊmfc0 �ߵ�ƽ��Ч    ��
        .mtc0(mtc0_), // ָ��Ϊmtc0 �ߵ�ƽ��Ч    д
        .pc(pc),
        .Rd(inst[15:11]),     // Reg Adress
        .wdata(rt), // ��д������
        .exception(break_|syscall_|teq_),    //�쳣�����ź�
        .eret(eret_),         //ָ��Ϊeret
        .cause(cp0_cause),   //�쳣ԭ��4:0
        .rdata(cp0_rdata), // ������������
        .status(cp0_status),//״̬
        .exc_addr(cp0_exc_addr) // �쳣������ַ
    );

    regfile cpu_ref(
        .clk(clk),
        .ena(ena),
        .rst(rst),
        .Rsc(Rsc),
        .Rtc(Rtc),
        .Rdc(Rdc),
        .Rs(rs),
        .Rt(rt),
        .Rd(rd),
        .Rf_w(Rf_w)
    );

    alu cpu_alu(
        .a(a),
        .b(b),
        .aluc(aluc),
        .ena(ena & alu_ena),
        .r(res),
        .zero(zf),
        .carry(cf),
        .negative(nf),
        .overflow(vf)
    );

    wire [5:0]clz_res; //clz����Ľ��
    clz clz(
        .ena(ena & clz_),
        .A(a),
        .res(clz_res)
    );

    wire [63:0]div_reg; //�˳�����64λ�Ĵ���
    wire [63:0]mul_reg;
    multu multu(
        //.clk(clk),
        .reset(rst),
        .ena(ena & multu_),
        .a(a),
        .b(b),
        .res(mul_reg)
    );
    mult mult(
        //.clk(clk),
        .reset(rst),
        .ena(ena & mul_),
        .a(a),
        .b(b),
        .res(mul_reg)
    );

    wire div_busy,divu_busy;    //������æ��־λ
    reg div_start;
    divu divu(
        .dividend(a),
        .divisor(b),
        .start(div_start),
        .ena(ena & divu_),
        .clock(clk),
        .reset(rst),
        .q(div_reg[31:0]),   //��
        .r(div_reg[63:32]),   //����
        .busy(divu_busy)
    );
    div div(
        .dividend(a),
        .divisor(b),
        .start(div_start),
        .ena(ena & div_),
        .clock(clk),
        .reset(rst),
        .q(div_reg[31:0]),   //��
        .r(div_reg[63:32]),   //����
        .busy(div_busy)
    );

    wire [31:0]hi_rdata,lo_rdata,hi_wdata,lo_wdata;
    assign hi_wdata= div_|divu_?
                    div_reg[63:32]:(
                    multu_?mul_reg[63:32]:(
                    mthi_?
                    rs:
                    32'bz));
    assign lo_wdata= div_|divu_?
                    div_reg[31:0]:(
                    multu_?mul_reg[31:0]:(
                    mtlo_?
                    rs:
                    32'bz));
    hilo hilo(
        .clk(clk),
        .rst(rst),
        .hir(ena & mfhi_),
        .lor(ena & mflo_),
        .hiw(ena & (mthi_|multu_|div_|divu_)),
        .low(ena & (mtlo_|multu_|div_|divu_)),
        .hi_wdata(hi_wdata),
        .lo_wdata(lo_wdata),
        .hi_rdata(hi_rdata),
        .lo_rdata(lo_rdata)
    );

    assign rd = lw_|lh_|lhu_|lb_|lbu_ ?
           dm_rdata:(
           jal_|jalr_?
                jal_res:
           mul_?
               mul_reg[31:0]:(
           mfc0_?
               cp0_rdata:(
           mfhi_?
               hi_rdata:(
           mflo_?
               lo_rdata:(
           clz_?
               {26'b0,clz_res}:(
           alu_ena?
                res:
                32'bz))))));
    
    //�ڴ�
    assign dm_r=lw_|lh_|lhu_|lb_|lbu_;
    assign dm_w=sw_|sh_|sb_;
    assign dm_sign=lw_|lh_|lb_;
    assign dm_size={lw_|sw_, lh_|lhu_|sh_, lb_|lbu_|sb_};

    //ָ��ִ������
    reg [31:0]pc_temp;//��ʱ��pc�Ĵ���
    reg [4:0]cycle;//ָ�����ڣ�һ��ָ������������
    
    //����������
    always@(posedge clk or posedge rst)
    begin
        if (rst) begin
           pc_temp <= 32'h00400000;
           cycle <= 'b00001;
           Rf_w <= 0;
        end
        else if(cycle[0]) begin //��һ������,ȡָ
            pc <= pc_temp;
            pc_temp <= pc_temp+4;
            cycle <= 'b00010;
            Rf_w <= 0;
            
        end
        else if(cycle[1]) begin // �ڶ������ڣ��������PC��ת
            Rsc = inst[25:21];
            Rtc = inst[20:16];  //�����������ĵ�ַ
            
            //Rd�ĵ�ַ
            if(jal_)
                Rdc <= 'd31;
            else if(OP && !(clz_|mul_))
                Rdc <= inst[20:16];
            else
                Rdc <= inst[15:11];

            //�Ƿ�Ҫ�ڱ�����д��Ĵ���
            if(jal_|jalr_|mfhi_|mflo_|mfc0_)
                Rf_w<=1;
            else
                Rf_w<=0;

            //������ת
            if(j_)//������ָ��
                cycle<=5'b00001;
            else if(mfc0_|mfhi_|mflo_|jal_) //������ָ��
                cycle <=5'b10000;
            else
                cycle <= 5'b00100;     

            //pc��ת
            if(j_|jal_)begin
                pc_temp <= {pc_temp[31:28],inst[25:0],2'b0};//4+26+2
            end
            if(jal_|jalr_)
                jal_res<=pc_temp;
        end
        else if(cycle[2]) begin// ����������
            //ALU������
            //��������������ֵ
            if(sll_ | srl_ | sra_)//�Ƿ���shamt����
                a<={23'b0,inst[10:6]};
            else 
                a <= rs;
            if(OP==0| beq_ |bne_|mul_)
                b <= rt;
            else if(addi_ |addiu_| slti_ | sltiu_ )//�з������������з�����չ
                b <= {{16{inst[15]}},inst[15:0]};
            else
                b <= {16'b0,inst[15:0]};
            //����������������
            div_start<=1; //����������
            if( break_| syscall_ | teq_ )
                pc_temp<=32'h00400004;
            else if((beq_&(rs==rt)) | (bne_ & (rs!=rt)) | (bgez_ & ~rs[31]))
                // if (rs == rt) PC <- PC+4 + (sign-extend)immediate<<2 
                pc_temp <= pc_temp + {{14{inst[15]}},inst[15:0],2'b0};
            else if(jr_)
                pc_temp<=rs;
            else if(eret_)
                pc_temp<=cp0_exc_addr;
            else if(lw_|sw_|lh_|lhu_|sh_|lb_|lbu_|sb_)begin
                dm_add<=rs + {{16{inst[15]}},inst[15:0]}- 32'h10010000;
                if(sw_|sh_|sb_)
                    dm_wdata<=rt;
            end

            //�Ƿ�Ҫ�ڱ�����д��Ĵ���
            if(alu_ena|mul_|mfc0_|clz_)
                Rf_w<=1;                
            else 
                Rf_w<=0;    
            
            //������ת
            if(jr_|beq_|bne_|bgez_|break_|syscall_|teq_|eret_)
                cycle <=5'b00001;
            else if(lw_|lh_|lhu_|lb_|lbu_|div_|divu_|mul_)
                cycle<=5'b01000;
            else
                cycle<=5'b10000;
        end
        else if(cycle[3]) begin //���ĸ�����
            cycle <= 5'b10000;
            div_start<=0; //�������ر�
            //�Ƿ�Ҫ�ڱ�����д��Ĵ���
            if((div_|divu_)&~(div_busy|divu_busy))
                Rf_w<=5'b10000;
            else
                Rf_w<=1; 
        end
        else if(cycle[4]) begin //���������
            cycle <= 5'b00001;
            if(jalr_)
                pc_temp<=rs;
            Rf_w<=0;
        end
        //$display("inst:%h cycle:%b pc:%h pc_temp:%h a:%h b:%h mul_reg:%h rd:%h",inst,cycle,pc,pc_temp,a,b,mul_reg,rd);
    end

endmodule

