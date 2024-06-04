`timescale 1ns / 1ps

`include "ParamDef.vh"

module IF(
    input                   cpu_clk, // Be aware of that NEED 2 CYCLES to read data
    input                   rst,
    input                   pcSrc,
    
    input   [`INST_LEN]     imm,
    output  [`INST_LEN]     curPC,
    output  reg [`INST_LEN]     tempPC,
    output  [13:0]          fetch_addr
    );
    
    
    
    reg [`INST_LEN]  pc;
//    wire [`INST_LEN]  curPC;
    initial begin
        pc = 32'h0;
     
    end
    PC IF_pc(
        .clk(cpu_clk),
        .rst(rst),
        .pcSrc(pcSrc),
        .imm(imm), 
        .curPC(pc),
        .nextPC(curPC)
        );
    always@(curPC) begin
        pc = curPC;
    end
    
    always@(posedge cpu_clk) begin
                tempPC<=pc;
    end
    
    assign fetch_addr = curPC[15:2];
//    assign pc_o = curPC; // for auipc
endmodule

