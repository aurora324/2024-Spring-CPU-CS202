`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/18 12:49:21
// Design Name: 
// Module Name: segs
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


module segs(input clk,                
            input rst,                
            input kickOff,              // CPU mode
            input IOWrite,              // IO sign
            input SEGCtrl,              // SEG ctrl
            input[1:0] segaddr,         // SEG address
            input[`REG_WIDTH] segwdata,       // SEG write data
            output reg[`TUBE_WIDTH] seg_en,    // Bit selective signal
            output reg[`TUBE_WIDTH] seg_out1,    
            output reg[`TUBE_WIDTH] seg_out2);
    // 2KHz
    parameter cnt        = 5_000;
    reg[18:0] divclk_cnt = 0;
    reg divclk           = 0;
    reg[3:0] disp_dat    = 0;
    reg[2:0] disp_bit    = 0;
    reg [3:0] num0, num1, num2, num3, num4, num5, num6, num7;
    reg[15:0] data;
    
    always@(posedge clk)begin
        if (divclk_cnt == cnt)
        begin
            divclk     <= ~divclk;
            divclk_cnt <= 0;
        end
        else
        begin
            divclk_cnt <= divclk_cnt + 1'b1;
        end
    end

//    always@(posedge clk or posedge rst) begin
always@(*) begin
        if (rst) begin
                if (kickOff == 1'b0) begin
                    num7 = 4'h1;
                    num6 = 4'h0;
                    num5 = 4'h0;
                    num4 = 4'h0;
                    num3 = 4'h0;
                    num2 = 4'h0;
                    num1 = 4'h0;
                    num0 = 4'h0;                    
                end
                else begin
                    num7 = 4'h0;
                    num6 = 4'h0;
                    num5 = 4'h0;
                    num4 = 4'h0;
                    num3 = 4'h0;
                    num2 = 4'h0;
                    num1 = 4'h0;
                    num0 = 4'h0; 
                end
            end
        else if (SEGCtrl == 1'b1 && IOWrite == 1'b1) begin
            if (segaddr == 2'b00 || segaddr == 2'b10) begin
                num7 = segwdata[31:28];
                num6 = segwdata[27:24];
                num5 = segwdata[23:20];
                num4 = segwdata[19:16];
                num3 = segwdata[15:12];
                num2 = segwdata[11:8];
                num1 = segwdata[7:4];
                num0 = segwdata[3:0];
            end
        end
        else begin
            num7 = num7;
            num6 = num6;
            num5 = num5;
            num4 = num4;
            num3 = num3;
            num2 = num2;
            num1 = num1;
            num0 = num0;
        end
    end

    always@(posedge divclk) begin
        if (disp_bit > 7) begin
            disp_bit <= 0;
        end
        else begin
            disp_bit <= disp_bit + 1'b1;
            case (disp_bit)
                3'b000 :
                begin
                    disp_dat <= num0;
                    seg_en <= 8'b00000001;
                end
                3'b001 :
                begin
                    disp_dat <= num1;
                    seg_en <= 8'b00000010;
                end
                3'b010 :
                begin
                    disp_dat <= num2;
                    seg_en <= 8'b00000100;
                end
                3'b011 :
                begin
                    disp_dat <= num3;
                    seg_en <= 8'b00001000;
                end
                3'b100 :
                begin
                    disp_dat <= num4;
                    seg_en <= 8'b00010000;
                end
                3'b101 :
                begin
                    disp_dat <= num5;
                    seg_en <= 8'b00100000;
                end
                3'b110 :
                begin
                    disp_dat <= num6;
                    seg_en <= 8'b01000000;
                end
                3'b111 :
                begin
                    disp_dat <= num7;
                    seg_en <= 8'b10000000;
                end
                default:
                begin
                    disp_dat <= 0;
                    seg_en <= 8'b00000000;
                end
            endcase
        end
    end
    
    always@(*) begin
        if (seg_en > 8'b00001000) begin //   4
            case (disp_dat)
                //  ʾ0-F
                4'h0 : seg_out1 = 8'hfc;
                4'h1 : seg_out1 = 8'h60;
                4'h2 : seg_out1 = 8'hda;
                4'h3 : seg_out1 = 8'hf2;
                4'h4 : seg_out1 = 8'h66;
                4'h5 : seg_out1 = 8'hb6;
                4'h6 : seg_out1 = 8'hbe;
                4'h7 : seg_out1 = 8'he0;
                4'h8 : seg_out1 = 8'hfe;
                4'h9 : seg_out1 = 8'hf6;
                4'ha : seg_out1 = 8'hee;
                4'hb : seg_out1 = 8'h3e;
                4'hc : seg_out1 = 8'h9c;
                4'hd : seg_out1 = 8'h7a;
                4'he : seg_out1 = 8'h9e;
                4'hf : seg_out1 = 8'h8e;
                default: seg_out1 = 8'h00;
            endcase
        end
        else begin
            case (disp_dat)
                //  ʾ0-F
                4'h0 : seg_out2 = 8'hfc;
                4'h1 : seg_out2 = 8'h60;
                4'h2 : seg_out2 = 8'hda;
                4'h3 : seg_out2 = 8'hf2;
                4'h4 : seg_out2 = 8'h66;
                4'h5 : seg_out2 = 8'hb6;
                4'h6 : seg_out2 = 8'hbe;
                4'h7 : seg_out2 = 8'he0;
                4'h8 : seg_out2 = 8'hfe;
                4'h9 : seg_out2 = 8'hf6;
                4'ha : seg_out2 = 8'hee;
                4'hb : seg_out2 = 8'h3e;
                4'hc : seg_out2 = 8'h9c;
                4'hd : seg_out2 = 8'h7a;
                4'he : seg_out2 = 8'h9e;
                4'hf : seg_out2 = 8'h8e;
                default: seg_out2 = 8'h00;
            endcase
        end
    end
endmodule