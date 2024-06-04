module WB(
    input                        clk,
    input       [`IMM_WIDTH]     memData,
    input                        MemorIOtoReg,
    input       [`IMM_WIDTH]     ALUResult,
    output reg  [`IMM_WIDTH]     write_back
);

/****************************************************************
port           I/O     Src/Dst     Description
memData         I      MemOrIO      data from memory
MemtoReg        I    Controller     selection bit  
ALUResult       I      EX/ALU       calculating result
write_back      O     register      the data for reg
****************************************************************/

//reg [`IMM_WIDTH] ALUTmp;
//    always@(posedge clk)begin
//        ALUTmp <= ALUResult;
//    end
    
    always@* begin
        case(MemorIOtoReg)
            1'b1: write_back = memData;
            default: write_back = ALUResult;
        endcase
    end

endmodule
