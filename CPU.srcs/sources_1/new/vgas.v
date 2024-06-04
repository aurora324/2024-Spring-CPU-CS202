`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 15:20:55
// Design Name: 
// Module Name: vgas
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

`include "ParamDef.vh"

module vgas (input clk,             
             input rst,             
             input IOWrite,         // IO sign
             input VGACtrl,         // VGA ctrl
             input kickOff,         // CPU state
             input[1:0] vgaaddr,    // VGA address
             input [15:0] vgawdata, // VGA write data
             output [11:0] rgb,     // Red, green and blue color signals
             output hsync,          // Line synchronization signal
             output vsync);         // Field synchronization signal
   
    // wire vga_clk;
    reg vga_clk = 0;
    reg cnt_clk = 0;
    reg [11:0] hcount, vcount;
    reg [11:0] data;
    wire hcount_ov;
    wire vcount_ov;
    wire dat_act;
    
    wire [7:0] p[41:0];
    wire [7:0] p1[41:0];
    wire [7:0] p2[48:0];
    wire [7:0] mile[48:0];
    reg [63:0] st[336:0];
    reg [63:0] st1[336:0];
    reg [63:0] st2[392:0];
    reg [63:0] mile_after[392:0];
    reg [5:0] let0, let1, let2, let3, let4, let5;
    reg [3:0] num0, num1, num2, num3, num4, num5, num6;
    reg[15:0] wdata;
   
   
    // 控制 VGA 显示的时序和像素数据
    always @(posedge clk) begin
        if (cnt_clk == 1) begin
            vga_clk          <= ~vga_clk;
            cnt_clk          <= 0;
        end 
        else 
            cnt_clk <= cnt_clk + 1;
    end

    always @(posedge vga_clk) begin
        if (hcount_ov) hcount <= 10'd0;
        else hcount           <= hcount + 10'd1;
    end
    assign hcount_ov = (hcount == `HPIXEKL_END);
    
    always @(posedge vga_clk) begin
        if (hcount_ov) begin
            if (vcount_ov) vcount <= 10'd0;
            else vcount           <= vcount + 10'd1;
        end
    end
    assign vcount_ov = (vcount == `VLINE_END);
    
    assign dat_act = ((hcount >= `HDAT_BEGIN) && (hcount <= `HDAT_END)) && ((vcount >= `VDAT_BEGIN) && (vcount <= `VDAT_END));
    assign hsync   = (hcount > `HSYNC_END);
    assign vsync   = (vcount > `VSYNC_END);
    assign rgb     = (dat_act) ? data : 3'h000;
    
    // 从数组中读取数据，并输出到 VGA 显示器
    integer i;
    integer j;
    
    always @(posedge vga_clk) begin
        for (i = 0; i < 336; i = i + 1) begin
            for (j = 0; j < 64; j = j + 1) begin
                st[i][j]  <= p[i/8][j/8];
                st1[i][j] <= p1[i/8][j/8];
            end
        end
        for (i = 0; i < 392; i = i + 1) begin
            for (j = 0; j < 64; j = j + 1) begin
                st2[i][j]        <= p2[i/8][j/8];
                mile_after[i][j] <= mile[i/8][j/8];
            end
        end
        if (hcount >= 272 && vcount >= 120 && hcount - 272 <= 391 && vcount - 120 <= 255) begin
            if (vcount - 120 <= 63 && hcount - 272 <= 335) begin
                if (st1[hcount-272][vcount-120])
                    data <= 12'h000;
                else 
                    data <= 12'hffc;
                end else if (vcount - 120 > 63 && vcount - 120 <= 127 && hcount - 272 <= 335) begin
                if (st[hcount-272][vcount-184])
                    data <= 12'hcff;
                else 
                    data <= 12'hffc;
                end else if (vcount - 120 > 127 && vcount - 120 <= 191) begin
                if (st2[hcount-272][vcount-248])
                    data <= 12'h000;
                else 
                    data <= 12'hffc;
                end else if (vcount - 120 > 191) begin
                if (mile_after[hcount-272][vcount-312])
                    data <= 12'hcff;
                else 
                    data <= 12'hffc;
        end
        end else data <= 12'hfff;
    end
    
    // 显示CPU状态 通信模式/正常模式   
    always @(posedge vga_clk) begin
        casex (kickOff)
            1'b0: begin // communication
                let0 <= `C;
                let1 <= `O;
                let2 <= `M;
                let3 <= `M;
            end
            1'b1: begin // normal
                let0 <= `N;
                let1 <= `O;
                let2 <= `R;
                let3 <= `M;
                let4 <= `A;
                let5 <= `L;
            end
        endcase
    end

    always@(posedge vga_clk or posedge rst) begin
        if (rst) begin
            num5 <= 4'he;
            num4 <= 4'he;
            num3 <= 4'he;
            num2 <= 4'he;
            num1 <= 4'he;
            num0 <= 4'he;
        end
        else if (VGACtrl == 1'b1 && IOWrite == 1'b1) begin
            if (vgaaddr == 2'b00 || vgaaddr == 2'b10) begin
                wdata <= (vgaaddr == 2'b00) ? vgawdata : (vgawdata[15] == 1'b1) ? ~vgawdata + 1 : vgawdata;
                num5 <= (vgaaddr == 2'b00) ? 4'he : (vgawdata[15] == 1'b1) ? 4'hf : 4'he;
                num4 <= wdata[15:0] / 1_0_000 % 10;
                num3 <= wdata[15:0] / 1_000 % 10;
                num2 <= wdata[15:0] / 1_00 % 10;
                num1 <= wdata[15:0] / 1_0 % 10;
                num0 <= wdata[15:0] / 1 % 10;
            end
            else begin
                num5 <= num5;
                num4 <= num4;
                num3 <= num3;
                num2 <= num2;
                num1 <= num1;
                num0 <= num0;
            end
        end
        else begin
            num5 <= num5;
            num4 <= num4;
            num3 <= num3;
            num2 <= num2;
            num1 <= num1;
            num0 <= num0;
        end
    end
        
    vga_char char_0 (
    .clk (vga_clk),
    .data(let0),
    .col0(p[0]),
    .col1(p[1]),
    .col2(p[2]),
    .col3(p[3]),
    .col4(p[4]),
    .col5(p[5]),
    .col6(p[6])
    );
    vga_char char_1 (
    .clk (vga_clk),
    .data(let1),
    .col0(p[7]),
    .col1(p[8]),
    .col2(p[9]),
    .col3(p[10]),
    .col4(p[11]),
    .col5(p[12]),
    .col6(p[13])
    );
    vga_char char_2 (
    .clk (vga_clk),
    .data(let2),
    .col0(p[14]),
    .col1(p[15]),
    .col2(p[16]),
    .col3(p[17]),
    .col4(p[18]),
    .col5(p[19]),
    .col6(p[20])
    );
    vga_char char_3 (
    .clk (vga_clk),
    .data(let3),
    .col0(p[21]),
    .col1(p[22]),
    .col2(p[23]),
    .col3(p[24]),
    .col4(p[25]),
    .col5(p[26]),
    .col6(p[27])
    );
    vga_char char_4 (
    .clk (vga_clk),
    .data(let4),
    .col0(p[28]),
    .col1(p[29]),
    .col2(p[30]),
    .col3(p[31]),
    .col4(p[32]),
    .col5(p[33]),
    .col6(p[34])
    );
    vga_char char_5 (
    .clk (vga_clk),
    .data(let5),
    .col0(p[35]),
    .col1(p[36]),
    .col2(p[37]),
    .col3(p[38]),
    .col4(p[39]),
    .col5(p[40]),
    .col6(p[41])
    );
    vga_char char_10 (
    .clk (vga_clk),
    .data(`S),
    .col0(p1[0]),
    .col1(p1[1]),
    .col2(p1[2]),
    .col3(p1[3]),
    .col4(p1[4]),
    .col5(p1[5]),
    .col6(p1[6])
    );
    vga_char char_11 (
    .clk (vga_clk),
    .data(`T),
    .col0(p1[7]),
    .col1(p1[8]),
    .col2(p1[9]),
    .col3(p1[10]),
    .col4(p1[11]),
    .col5(p1[12]),
    .col6(p1[13])
    );
    vga_char char_12 (
    .clk (vga_clk),
    .data(`A),
    .col0(p1[14]),
    .col1(p1[15]),
    .col2(p1[16]),
    .col3(p1[17]),
    .col4(p1[18]),
    .col5(p1[19]),
    .col6(p1[20])
    );
    vga_char char_13 (
    .clk (vga_clk),
    .data(`T),
    .col0(p1[21]),
    .col1(p1[22]),
    .col2(p1[23]),
    .col3(p1[24]),
    .col4(p1[25]),
    .col5(p1[26]),
    .col6(p1[27])
    );
    vga_char char_14 (
    .clk (vga_clk),
    .data(`E),
    .col0(p1[28]),
    .col1(p1[29]),
    .col2(p1[30]),
    .col3(p1[31]),
    .col4(p1[32]),
    .col5(p1[33]),
    .col6(p1[34])
    );
    vga_char char_15 (
    .clk (vga_clk),
    .data(6'b11_1110),
    .col0(p1[35]),
    .col1(p1[36]),
    .col2(p1[37]),
    .col3(p1[38]),
    .col4(p1[39]),
    .col5(p1[40]),
    .col6(p1[41])
    );
    vga_char char_20 (
    .clk (vga_clk),
    .data(`R),
    .col0(p2[0]),
    .col1(p2[1]),
    .col2(p2[2]),
    .col3(p2[3]),
    .col4(p2[4]),
    .col5(p2[5]),
    .col6(p2[6])
    );
    vga_char char_21 (
    .clk (vga_clk),
    .data(`E),
    .col0(p2[7]),
    .col1(p2[8]),
    .col2(p2[9]),
    .col3(p2[10]),
    .col4(p2[11]),
    .col5(p2[12]),
    .col6(p2[13])
    );
    vga_char char_22 (
    .clk (vga_clk),
    .data(`S),
    .col0(p2[14]),
    .col1(p2[15]),
    .col2(p2[16]),
    .col3(p2[17]),
    .col4(p2[18]),
    .col5(p2[19]),
    .col6(p2[20])
    );
    vga_char char_23 (
    .clk (vga_clk),
    .data(`U),
    .col0(p2[21]),
    .col1(p2[22]),
    .col2(p2[23]),
    .col3(p2[24]),
    .col4(p2[25]),
    .col5(p2[26]),
    .col6(p2[27])
    );
    vga_char char_24 (
    .clk (vga_clk),
    .data(`L),
    .col0(p2[28]),
    .col1(p2[29]),
    .col2(p2[30]),
    .col3(p2[31]),
    .col4(p2[32]),
    .col5(p2[33]),
    .col6(p2[34])
    );
    vga_char char_25 (
    .clk (vga_clk),
    .data(`T),
    .col0(p2[35]),
    .col1(p2[36]),
    .col2(p2[37]),
    .col3(p2[38]),
    .col4(p2[39]),
    .col5(p2[40]),
    .col6(p2[41])
    );
    vga_char char_26 (
    .clk (vga_clk),
    .data(6'b11_1110),
    .col0(p2[42]),
    .col1(p2[43]),
    .col2(p2[44]),
    .col3(p2[45]),
    .col4(p2[46]),
    .col5(p2[47]),
    .col6(p2[48])
    );

    //---------------------------------------------------------
    
    vga_num_ram_module number_6 (
    .clk (vga_clk),
    .data(num5),
    .col0(mile[0]),
    .col1(mile[1]),
    .col2(mile[2]),
    .col3(mile[3]),
    .col4(mile[4]),
    .col5(mile[5]),
    .col6(mile[6])
    );
    vga_num_ram_module number_5 (
    .clk (vga_clk),
    .data(num4),
    .col0(mile[7]),
    .col1(mile[8]),
    .col2(mile[9]),
    .col3(mile[10]),
    .col4(mile[11]),
    .col5(mile[12]),
    .col6(mile[13])
    );
    vga_num_ram_module number_4 (
    .clk (vga_clk),
    .data(num3),
    .col0(mile[14]),
    .col1(mile[15]),
    .col2(mile[16]),
    .col3(mile[17]),
    .col4(mile[18]),
    .col5(mile[19]),
    .col6(mile[20])
    );
    vga_num_ram_module number_3 (
    .clk (vga_clk),
    .data(num2),
    .col0(mile[21]),
    .col1(mile[22]),
    .col2(mile[23]),
    .col3(mile[24]),
    .col4(mile[25]),
    .col5(mile[26]),
    .col6(mile[27])
    );
    vga_num_ram_module number_2 (
    .clk (vga_clk),
    .data(num1),
    .col0(mile[28]),
    .col1(mile[29]),
    .col2(mile[30]),
    .col3(mile[31]),
    .col4(mile[32]),
    .col5(mile[33]),
    .col6(mile[34])
    );
    vga_num_ram_module number_1 (
    .clk (vga_clk),
    .data(num0),
    .col0(mile[35]),
    .col1(mile[36]),
    .col2(mile[37]),
    .col3(mile[38]),
    .col4(mile[39]),
    .col5(mile[40]),
    .col6(mile[41])
    );
    vga_num_ram_module number_0 (
      .clk (vga_clk),
      .data(4'he),
      .col0(mile[42]),
      .col1(mile[43]),
      .col2(mile[44]),
      .col3(mile[45]),
      .col4(mile[46]),
      .col5(mile[47]),
      .col6(mile[48])
    );
endmodule
            
            
