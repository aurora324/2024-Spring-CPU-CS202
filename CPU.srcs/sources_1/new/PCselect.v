
`include "ParamDef.vh"

module PCselect(
            input    wire [`INST_LEN]     inst,  
            input    wire [`REG_WIDTH]    rd1,
            input    wire [`REG_WIDTH]    rd2,
            output   reg                  PCSel
    );
    
    wire [`FUNCT3_WIDTH] funct3 = inst[14:12];
    wire [`OP_WIDTH] opcode = inst[6:0];
    wire [1:0] compResult_s;
    wire [1:0] compResult_u;
    
    compare comp(
        .data1(rd1),
        .data2(rd2),
        .Unsigned(`SIGNED),
        .out(compResult_s)
        );  
        compare comp2(
            .data1(rd1),
            .data2(rd2),
            .Unsigned(`UNSIGNED),
            .out(compResult_u)
            );
        
    always@* begin
        if (opcode == `opB) begin
            case(funct3)
                3'h0: PCSel = (compResult_s == `EQUAL)? `PCSEL_JUMP: `PCSEL_PC;
                3'h1: PCSel = (compResult_s != `EQUAL)? `PCSEL_JUMP: `PCSEL_PC;
                3'h4: PCSel = (compResult_s == `LESS)? `PCSEL_JUMP: `PCSEL_PC;
                3'h6: PCSel = (compResult_u == `LESS)? `PCSEL_JUMP: `PCSEL_PC;
                3'h5: PCSel = (compResult_s == `GREATER_EQ || compResult_s == `EQUAL)? `PCSEL_JUMP: `PCSEL_PC;
                3'h7: PCSel = (compResult_u == `GREATER_EQ || compResult_u == `EQUAL)? `PCSEL_JUMP: `PCSEL_PC;
                default PCSel = `PCSEL_PC;
            endcase
        end else if (opcode == `opJ || opcode == `opIJ) PCSel = `PCSEL_JUMP;
        else PCSel = `PCSEL_PC;
    end 
endmodule