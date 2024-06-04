`timescale 1ns / 1ps

`include "ParamDef.vh"

module Controller( // Combination Logic 
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
    );

    wire[6:0] opcode;
    wire[31:0] imm_I, imm_S,imm_B,imm_U,imm_JAL,imm_JALR;
    
    assign opcode = inst[6:0];
    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];
    
    reg [`INST_TYPES_WIDTH] instType;
    // opcode: instType
    always @* begin
        case(opcode)
            7'b0110011: instType = `typeR;
            7'b0010011,7'b0000011,7'b1100111,7'b1110011: instType = `typeI;
            7'b0100011: instType = `typeS;
            7'b1100011: instType = `typeB;
            7'b1101111: instType = `typeJ;
            7'b0110111,7'b0010111: instType = `typeU;
            default: instType = 3'h0;
        endcase
    end
    
    // immediate
    assign imm_I = {{20{inst[31]}},inst[31:20]};
    assign imm_S = {{20{inst[31]}},inst[31:25],inst[11:7]};
    assign imm_B = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
    assign imm_JAL = {{12{inst[31]}}, inst[19:12],inst[20], inst[30:21],1'b0};
    assign imm_JALR = {{20{inst[31]}},inst[31:20]};
    assign imm_U = {inst[31:12]};
    
    
 /***************************************************************
                            Control bit
    ****************************************************************/
    
    // Branch
    assign Branch = (instType == `typeB)? 1'b1:1'b0;
    
    // ALUOp
    // load/store 00; Branch 01; R-type 10
    always @* begin
        case(opcode)
            `opIL,`opS: ALUOp = 2'b00;
            `opI,`opR: ALUOp = 2'b10;
            `opU,`opAU: ALUOp = 2'b11;
            default: ALUOp = 2'b01;
        endcase
    end
    
    wire lw;
    wire sw;
    assign lw       = (opcode == 6'b100011)? 1'b1:1'b0;
    assign sw       = (opcode == 6'b101011)? 1'b1:1'b0;
    
    // ALUsrc
    assign ALUsrc = (instType == `typeB || instType == `typeR)? 1'b0 : 1'b1;
   
    assign MemWrite     = (sw == 1'b1 && (ALU_result_high[21:0] != 22'b1111111111111111111111))?1'b1:1'b0;
    assign MemRead      = (lw == 1'b1 && (ALU_result_high[21:0] != 22'b1111111111111111111111))?1'b1:1'b0;
    assign IORead       = (lw == 1'b1 && (ALU_result_high[21:0] == 22'b1111111111111111111111))?1'b1:1'b0;
    assign IOWrite      = (sw == 1'b1 && (ALU_result_high[21:0] == 22'b1111111111111111111111))?1'b1:1'b0;
    // Read operations require reading data from memory or I/O to write to the register
    assign MemorIOtoReg = IORead || MemRead;

   
endmodule