`timescale 1ns / 1ps

`include "ParamDef.vh"

module IF_tb();

reg cpu_clk;
reg rst;
reg pcSrc;
reg [31:0]imm;
reg [31:0]pc;
wire[13:0]fetch_addr;
IF uub(cpu_clk,rst,pcSrc, imm,pc,fetch_addr);
initial begin
        cpu_clk=1'b0;
        #10 rst = 1'b1;
        rst = 1'b0;
        forever #5 cpu_clk=~cpu_clk;
    end
    
    initial begin
        imm = 32'h5;
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