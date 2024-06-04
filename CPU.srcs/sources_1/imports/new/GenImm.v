`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 19:50:07
// Design Name: 
// Module Name: GenImm
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

module GenImm(
    input [`REG_WIDTH] inst,
    output reg [`IMM_WIDTH] out
    );
    wire[6:0] opcode;
    assign opcode = inst[6:0];
    
    // opcode: instType
    always @* begin
        case(opcode)
            7'b0010011,7'b0000011,7'b1100111,7'b1110011: out = {{20{inst[31]}},inst[31:20]}; // I
            7'b0100011: out = {{20{inst[31]}},inst[31:25],inst[11:7]}; // S
            7'b1100011: out = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0}; //B
            7'b1101111: out = {{12{inst[31]}}, inst[19:12],inst[20], inst[30:21],1'b0}; //J
            7'b0110111,7'b0010111: out = {inst[31:12]}; //U
            default: out = 0;
        endcase
    end


    //assign imm_JALR = {{20{inst[31]}},inst[31:20]};
    
    // control bit
    
endmodule

//module GenImm(
//    input [`REG_WIDTH] inst,
//    output [`IMM_WIDTH] out
//    );

//    reg [`IMM_WIDTH]temp;
//    wire opcode = inst[6:0];
//    always @* begin
    
//        // I
//        if(opcode==7'b1110011||opcode==7'b1100111||opcode==7'b0100011||opcode==7'b0000011||opcode==7'b0011011||opcode==7'b0010011)begin
//            temp = {20'h00000,inst[31:20]};
//        end
//        // U
//        else if(opcode==7'b0010111)begin
//            temp = {12'h000,inst[31:12]};
//        end
        
//        // S
//        else if(opcode==7'b0100011)begin
//            temp = {20'h00000, inst[31:25], inst[11:7]};
//        end
        
//        // R
//        else if(opcode==7'b0110011)begin
//             //temp = {in[12:31],3'h000};
//             temp = 32'h00000000;
//        end
        
//        // SB
//        else if(opcode==7'b1100011)begin
//            temp = {19'b000_0000_0000_0000_0000, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
//        end
        
//        // UJ
//        else if(opcode==7'b1101111)begin
//            temp = {11'b0000_0000_000, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
//        end
//    end
//    assign out = temp;
//endmodule

