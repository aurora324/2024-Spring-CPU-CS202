`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 22:58:30
// Design Name: 
// Module Name: EX
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

module EX(
input   wire [`REG_WIDTH]    rd1,
input   wire [`REG_WIDTH]    rd2,
input   wire [`IMM_WIDTH]    imm,
input   wire [`REG_WIDTH]    pc,
input   wire                 ALUsrc,
input         [2:0]           funct3, 
input         [6:0]           funct7, 
input   wire [`ALU_OP_LEN]   ALUOp,
input   wire [`OP_WIDTH]     opcode,
output  wire [`IMM_WIDTH]    ALUResult

    );
   
    wire [`REG_WIDTH] operand1 = rd1;
    wire [`REG_WIDTH] operand2 = ALUsrc ? imm : rd2;
    
    ALU alu(
        .operand1(operand1),
        .operand2(operand2),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .pc(pc),
        .opcode(opcode),
        .ALUResult(ALUResult)
        );
      
endmodule