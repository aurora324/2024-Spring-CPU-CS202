`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 23:28:37
// Design Name: 
// Module Name: ctrl_tb
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
/*
input[`INST_LEN] inst,
input[21:0] ALU_result_high, // From executer, Alu_Result[31:10]
output[`REG_IDX_LEN] rs1,
output[`REG_IDX_LEN] rs2,
output[`REG_WIDTH] imm,
output Branch, //beq
output reg [1:0] ALUOp,
output ALUsrc, //
output MemorIOtoReg, // 1 indicates that data needs to be read from memory or I/O to the register
output RegWrite, // 1 indicates that the instruction needs to write to the register
output MemRead, // 1 indicates that the instruction needs to read from the memory
output MemWrite, // 1 indicates that the instruction needs to write to the memory
output IORead, // 1 indicates I/O read
output IOWrite, // 1 indicates I/O write
output [`FUNCT3_WIDTH] funct3,
output [`FUNCT7_WIDTH] funct7

    input [`REG_WIDTH] operand1,
    input [`REG_WIDTH] operand2,
    input [`ALU_OP_LEN] ALUOp, // load/store 00; Branch 01; ËãÊý 10
    input [2:0] funct3, 
    input [6:0] funct7,  
    output reg [31:0] ALUResult
*/

module ctrl_tb();
reg[`INST_LEN] inst;
reg [21:0] ALU_result_high; // From executer, Alu_Result[31:10]
wire[`REG_IDX_LEN] rs1;
wire[`REG_IDX_LEN] rs2;
wire[`REG_WIDTH] imm;
wire Branch; //beq
wire[1:0] ALUOp;
wire ALUsrc; //
wire MemorIOtoReg; // 1 indicates that data needs to be read from memory or I/O to the register
wire RegWrite; // 1 indicates that the instruction needs to write to the register
wire MemRead; // 1 indicates that the instruction needs to read from the memory
wire MemWrite; // 1 indicates that the instruction needs to write to the memory
wire IORead; // 1 indicates I/O read
wire IOWrite; // 1 indicates I/O write
wire [`FUNCT3_WIDTH] funct3;
wire [`FUNCT7_WIDTH] funct7;


Controller u1(inst,ALU_result_high,rs1,rs2,imm,Branch,ALUOp,ALUsrc,MemorIOtoReg,RegWrite,MemRead,MemWrite, // 1 indicates that the instruction needs to write to the memory
IORead,IOWrite,funct3,funct7);

//ALU u2(operand1,operand2, ALUOp,funct3,funct7,ALUResult);
    /*
    0fc10297
    00028293
    0042a303
    00737fb3
    00137f93
    */
    initial begin
        ALU_result_high = 0;
    end
    
    initial begin
        inst = 32'h0fc10297;
        # 10
        inst = 32'h00028293;
        # 10
        inst = 32'h0042a303;
        # 10
        inst = 32'h00737fb3;
        # 10
        inst = 32'h00137f93;
        # 10 $finish;
    end
endmodule
