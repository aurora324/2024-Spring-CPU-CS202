`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 20:40:28
// Design Name: 
// Module Name: compare
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


module compare(
input [`IMM_WIDTH ] data1,
input [`IMM_WIDTH ] data2,
input Unsigned,
output reg [1:0] out
    );
    wire [31: 0] Ain = data1;
    wire [31: 0] Bin = data2;
    reg equal;
    reg less;
    // 有符号数转换为移码
//    assign Ain[30: 0] = data1[30: 0];
//    assign Ain[31]    = (Unsigned == `UNSIGNED) ? data1[31] : ~data1[31];
//    assign Bin[30: 0] = data2[30: 0];
//    assign Bin[31]    = (Unsigned == `UNSIGNED) ? data2[31] : ~data2[31];

    always@*begin
        if(Unsigned == `UNSIGNED)begin
            equal = ($unsigned(Ain) == $unsigned(Bin)) ? 1'b1 : 1'b0;
            less  = ($unsigned(Ain) < $unsigned(Bin)) ? 1'b1 : 1'b0;
        end else begin
            equal = ($signed(Ain) == $signed(Bin)) ? 1'b1 : 1'b0;
            less  = ($signed(Ain) < $signed(Bin)) ? 1'b1 : 1'b0;
        end
    end

    always @(*) begin
        if (equal) begin
            out = `EQUAL;
        end
        else if (less) begin
            out = `LESS;
        end
        else begin
            out = `GREATER_EQ;
        end
    end
endmodule
