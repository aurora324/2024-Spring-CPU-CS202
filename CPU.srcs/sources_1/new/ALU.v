`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 10:17:03
// Design Name: 
// Module Name: ALU
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

module ALU(
    input [`REG_WIDTH] operand1,
    input [`REG_WIDTH] operand2,
    input [`ALU_OP_LEN] ALUOp, // load/store 00; Branch 01; ËãÊý 10
    input [`FUNCT3_WIDTH] funct3, 
    input [`FUNCT7_WIDTH] funct7, 
    input [`REG_WIDTH] pc, 
    input [`OP_WIDTH] opcode,
    output reg [31:0] ALUResult
    );
    reg [3:0] ALUControl;
    
    always@* begin
        if(ALUOp==2'b00) ALUControl = 4'h0;
        else if(ALUOp==2'b10) begin
            case(funct3)
                3'h0: begin if(funct7 == 7'h20) ALUControl = 4'h6; // sub 
                            else ALUControl = 4'h0; // add addi
                      end
                3'h1: ALUControl = 4'h5; // sll slli
                3'h2: ALUControl = 4'h9; // slt slti
                3'h3: ALUControl = 4'ha; // sltu sltiu
                3'h4: ALUControl = 4'h4; // xor xori
                3'h5: begin if(funct7 == 7'h20) ALUControl = 4'h8; // sra srai 
                            else ALUControl = 4'h7; // srl
                      end
                3'h6: ALUControl = 4'h1; // or ori
                3'h7: ALUControl = 4'h3; // and andi
            endcase
        end
        else if(ALUOp == 2'b11 && opcode == `opU) ALUControl = 4'hb; // lui
        else if(ALUOp == 2'b11 && opcode == `opAU) ALUControl = 4'hc; // auipc
        else if(ALUOp == 2'b01 && (opcode == `opJ || opcode == `opIJ)) ALUControl = 4'hd; // jal jalr
        else ALUControl = 4'hf;
//        else ALUControl = {ALUOp,2'b10};
     end
      
    always@* begin
             case(ALUControl)
             4'h0: ALUResult = operand1 + operand2; //add addi load store
             4'h1: ALUResult = operand1 | operand2; //or ori
//             4'h2: ALUResult = $signed(operand1) + $signed(operand2); //add addi lw sw
             4'h3: ALUResult = operand1 & operand2; //andu andi
             4'h4: ALUResult = operand1 ^ operand2; //xor xori
             4'h5: ALUResult = operand1 << operand2; // sll slli lui
             4'h6: ALUResult = $signed(operand1) - $signed(operand2); // sub 
             4'h7: ALUResult = operand1 >> operand2; // srl srli
             4'h8: ALUResult = $signed(operand1) >>> $signed(operand2); // sra srai
             4'h9: ALUResult = ($signed(operand1) < $signed(operand2))? 32'h1 : 32'h0; // slt slti
             4'hA: ALUResult = ($unsigned(operand1) < $unsigned(operand2))? 32'h1 : 32'h0; // sltu sltui
             4'hB: ALUResult = operand2 << 12; // lui
             4'hC: ALUResult = pc + (operand2 << 12) + 32'h00400000-32'h10010000; // auipc
//             4'hC: ALUResult = pc + (operand2 << 12) + 32'h00400000 - 32'h10010000 - 32'hc8; // auipc
             4'hD: ALUResult = pc + 4; // jal jalr
             default: ALUResult = 32'h0;
             endcase      
          end        
//assign zero = (ALUResult == 32'h0) ? 1'b1:1'b0;                
endmodule