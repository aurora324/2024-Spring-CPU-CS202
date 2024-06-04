`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/07 22:12:17
// Design Name: 
// Module Name: Register
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
//ok
`include "ParamDef.vh"

module Register(
    input                   clk,
    input                   rst,
    input   [`REG_IDX_LEN]  rs1,
    input   [`REG_IDX_LEN]  rs2,
    input   [`REG_IDX_LEN]  write_r,
    input   [`REG_WIDTH]    write_data,
    input                   write_en,
    output [`REG_WIDTH] rd1,
    output [`REG_WIDTH] rd2
);

/****************************************************************
 port           I/O     Src/Dst     Description
 rs1             I        ID        Index of first register
 rs2             I        ID        Index of second register
 write_r         I        ID        Index of write-back register
 write_data      I        Top       Data to write back
 write_en        I        Top       Write back enable
 clk             I        Top       CPU clock signal
 rst             I      H'ware      Reset signal
 rd1             O        ALU       Value of first register
 rd2             O        ALU       Value of second register
****************************************************************/

reg [`REG_WIDTH] registers [`REG_WIDTH];
//reg write_en_tmp;
//always @(negedge clk)
//begin
//    write_en_tmp<=write_en;
//end
//assign read_ra = registers[1];

always @(posedge clk)
begin
    if(rst) begin
        registers[5'd0] <= 32'h0000_0000;
        registers[5'd1] <= 32'h0000_0000;
        registers[5'd2] <= 32'h7fff_effc;
        registers[5'd3] <= 32'h0000_0080;
        registers[5'd4] <= 32'h0000_0000;
        registers[5'd5] <= 32'h0000_0000;
        registers[5'd6] <= 32'h0000_0000;
        registers[5'd7] <= 32'h0000_0000;
        registers[5'd8] <= 32'h0000_0000;
        registers[5'd9] <= 32'h0000_0000;
        registers[5'd10] <= 32'h0000_0000;
        registers[5'd11] <= 32'h0000_0000;
        registers[5'd12] <= 32'h0000_0000;
        registers[5'd13] <= 32'h0000_0000;
        registers[5'd14] <= 32'h0000_0000;
        registers[5'd15] <= 32'h0000_0000;
        registers[5'd16] <= 32'h0000_0000;
        registers[5'd17] <= 32'h0000_0000;
        registers[5'd18] <= 32'h0000_0000;
        registers[5'd19] <= 32'h0000_0000;
        registers[5'd20] <= 32'h0000_0000;
        registers[5'd21] <= 32'h0000_0000;
        registers[5'd22] <= 32'h0000_0000;
        registers[5'd23] <= 32'h0000_0000;
        registers[5'd24] <= 32'h0000_0000;
        registers[5'd25] <= 32'h0000_0000;
        registers[5'd26] <= 32'h0000_0000;
        registers[5'd27] <= 32'h0000_0000;
        registers[5'd28] <= 32'h0000_0000;
        registers[5'd29] <= 32'h0000_0000;
        registers[5'd30] <= 32'h0000_0000;
        registers[5'd31] <= 32'h0000_0000;
     end 
     else begin
        if( write_en && (write_r != 5'b00000)) begin registers[write_r] = write_data;end
     end
end

assign rd1 = registers[rs1];
assign rd2 = registers[rs2];
endmodule