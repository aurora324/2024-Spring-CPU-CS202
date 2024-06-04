`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/18 14:48:18
// Design Name: 
// Module Name: ID_tb
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


module ID_tb();
/*
input    wire                 clk,
input    wire                 rst,
input    wire [`INST_LEN]     inst,                
input    wire                 write_en,
input    wire [`REG_IDX_LEN]  write_r,
input    wire [`REG_WIDTH]    write_data,
output   wire [`REG_WIDTH]    rd1,
output   wire [`REG_WIDTH]    rd2,
output   wire [`IMM_WIDTH]    immOut,
output   wire                 PCSelect
*/
reg cpu_clk;
reg rst;
reg [31:0]branch_pc;
wire[31:0]inst;
IF uub(cpu_clk,cpu_clk+1'b1, branch_pc,1'b0,1'b0,14'b0,32'b0, inst);
initial begin
        cpu_clk=1'b0;
        forever #5 cpu_clk=~cpu_clk;
    end
    
    initial begin
        branch_pc=14'h0;
        #5
        repeat(100) #10 branch_pc=branch_pc+1;
        #20 $finish;
    end

endmodule
