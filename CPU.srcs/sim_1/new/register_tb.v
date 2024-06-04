`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 23:50:18
// Design Name: 
// Module Name: register_tb
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


module register_tb();
            reg clk;
            reg rst;
            reg rs1;
            reg rs2;
            reg write_r;
            reg write_data;
            reg write_en;
            wire rd1;
            wire rd2;
        
     Register reg_tb (
            .clk(clk),
            .rst(rst),
            .rs1(rs1),
            .rs2(rs2),
            .write_r(write_r),
            .write_data(write_data),
            .write_en(write_en),
            .rd1(rd1),
            .rd2(rd2)
        );
    initial begin
            $monitor("inst: %8h rd1: %8h rd2: %8h immOut: %8h PCSelect: %1b", inst,rd1,rd2, immOut, PCSelect);
            clk = 1'b0;
            rst = 1'b1;
            write_en = 1'b1;
            write_r = 5'd6;
            write_data = 32'b0;
            rs1 = 5'b00110;
            rs2 = 5'b00000;
            #5 clk = ~clk;
        end
    
        always begin
            
        end
        
endmodule
