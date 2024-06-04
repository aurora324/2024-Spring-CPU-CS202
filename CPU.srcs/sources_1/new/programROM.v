`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 17:35:35
// Design Name: 
// Module Name: programROM
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


module programROM(
                   // Program ROM Pinout
                   input rom_clk_i,             // ROM clock
                   input [13:0] rom_adr_i,      // Instruction Address From IFetch
                   output [31:0] Instruction_o, // INstruction To IFetch
                   
                   // UART Programmer Pinouts
                   input upg_rst_i,             // UPG reset (Active High)
                   input upg_clk_i,             // UPG clock (10MHz)
                   input upg_wen_i,             // UPG write enable
                   input[13:0] upg_adr_i,       // UPG write address
                   input[31:0] upg_dat_i,       // UPG write data
                   input upg_done_i);           // 1 if program finished
                       
                   /* if kickOff is 1 means CPU work on normal mode, otherwise CPU work on Uart communication mode.*/
                   wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
                       
      inst_mem rom_inst(
            .clka (kickOff ? rom_clk_i : upg_clk_i),
            .wea (kickOff ? 1'b0 : upg_wen_i),
            .addra (kickOff ? rom_adr_i : upg_adr_i),
            .dina (kickOff ? 32'h0000_0000 : upg_dat_i),
            .douta (Instruction_o)
        );                 
endmodule
