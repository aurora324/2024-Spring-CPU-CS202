`timescale 1ns / 1ps


module pc_tb();
/*
input clk,
input rst,
input pcSrc,
input [`REG_WIDTH] imm, 
input [`REG_WIDTH] curPC,
output reg [`REG_WIDTH] nextPC
*/
reg cpu_clk;
reg rst;
reg pcSrc;
reg [31:0]imm;
reg [31:0]pc;
wire[31:0]nextpc;
PC u(cpu_clk,rst,pcSrc, imm,pc,nextpc);
initial begin
        cpu_clk=1'b0;
        #10 rst = 1'b1;
        rst = 1'b0;
        forever #5 cpu_clk=~cpu_clk;
    end
    
    initial begin
        imm = 32'ha;
        rst = 1'b0;

    end
    
    initial begin
        pcSrc = 1'b0;
        forever #50 pcSrc =~pcSrc;
    end
    
    initial begin
        pc=14'h0;
        #5
        repeat(100) #10 pc=pc+1;
        #20 $finish;
    end
endmodule
