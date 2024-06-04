`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/14 17:57:35
// Design Name: 
// Module Name: PCselect
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

module PCselect(
            input    wire [`INST_LEN]     inst,  
            input    wire [`REG_WIDTH]    rd1,
            input    wire [`REG_WIDTH]    rd2,
            output   reg                  PCSel
    );
    
    wire funct3 = inst[14:12];
    wire opcode = inst[6:0];
    wire [1:0] compResult;
    
    compare comp(
        .data1(rd1),
        .data2(rd2),
        .Unsigned(`SIGNED),// Ãÿ ‚≈–∂œlui
        .out(compResult)
        );  
        
    always@* begin
        if (opcode == 7'b1100011) begin
            case(funct3)
                3'h0: PCSel = (compResult == `EQUAL)? `PCSEL_JUMP: `PCSEL_PC;
                3'h1: PCSel = (compResult != `EQUAL)? `PCSEL_JUMP: `PCSEL_PC;
                3'h4: PCSel = (compResult == `LESS)? `PCSEL_JUMP: `PCSEL_PC;
                3'h5: PCSel = (compResult == `GREATER_EQ)? `PCSEL_JUMP: `PCSEL_PC;
                default PCSel = `PCSEL_PC;
            endcase
        end else if (opcode == 7'b1101111) PCSel = `PCSEL_JUMP;
        else PCSel = `PCSEL_PC;
    end 
endmodule
