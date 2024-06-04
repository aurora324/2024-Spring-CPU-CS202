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
            `opI,`opIL,`opIE: out = {{20{inst[31]}},inst[31:20]}; // I
            `opIJ: out = {{20{inst[31]}},inst[31:20]}; // jalr
            `opS: out = {{20{inst[31]}},inst[31:25],inst[11:7]}; // S
            `opB: out = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0}; //B
            `opJ: out = {{12{inst[31]}}, inst[19:12],inst[20], inst[30:21],1'b0}; //J
            `opU,`opAU: out = {inst[31:12]}; //U
            default: out = 0;
        endcase
    end

    
endmodule
