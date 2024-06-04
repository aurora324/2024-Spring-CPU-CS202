`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 22:40:22
// Design Name: 
// Module Name: alu_tb
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


module alu_tb(
/*
    input [`REG_WIDTH] operand1,
input [`REG_WIDTH] operand2,
input [`ALU_OP_LEN] ALUOp, // load/store 00; Branch 01; ËãÊý 10
input [2:0] funct3, 
input [6:0] funct7,  
output reg [31:0] ALUResult
*/
    );
    
    reg [`REG_WIDTH] d1;
    reg [`REG_WIDTH] d2;
    reg [`ALU_OP_LEN] ALUOp;
    reg [2:0] f3;
    reg [2:0] f7;
    wire [31:0] ans;
    
    ALU u(d1,d2,ALUOp,f3,f7,ans);
    
    initial begin
        d1 = 32'h5;
        d2 = 32'ha;
        f3 = 3'h0;

        ALUOp = 2'b00;
        repeat(3) #50 ALUOp = ALUOp + 1'b1;
        #50 $finish;
    end
    
    initial begin
        f3 = 3'h0;
        f7 = 7'h0;
        
    end
endmodule
