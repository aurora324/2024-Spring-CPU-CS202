`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/13 13:29:13
// Design Name: 
// Module Name: MEM
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


module MEM(
    input                       cpu_clk,
    input                       mem_enable,
    input                       mem_read_enable,
    input                       mem_write_enable,
    input   [`REG_WIDTH]        mem_address,
    input   [`REG_WIDTH]        mem_write_data,
    input   [`REG_WIDTH]        mem_ecall_write_data,
    input   [`LED_WIDTH]        mem_keyboard_write_data,
    
    // UART Programmer Pinouts
    input                       uart_rst,                  //UPG reset(Active High)
    input                       uart_clk,                  // UPG uart_clk (10MHz)
    input                       uart_write_enable,          // UPG write enable
    input   [13:0]              uart_adr,                  // UPG write address
    input   [`REG_WIDTH]        uart_write_data,           // UPG write data
    input                       uart_done,                 // 1 if programming is finished);
    
    //output
    output  [`REG_WIDTH]        mem_register_output_data
    );
    
    wire counter_cpu_clk = !cpu_clk;
    /* CPU work on normal mode when kickOff is 1.
     CPU work on Uart communicate mode when kickOff is 0.*/
    wire kickOff = uart_rst | ( ~ uart_rst & uart_done);
     
    data_mem dm(
                 .clka (kickOff ?     counter_cpu_clk        : uart_clk),
                 .wea (kickOff ?    mem_write_enable  : uart_write_enable),
                 .addra (kickOff ?   mem_address[13:0]   : uart_adr),
                 .dina (kickOff ?    mem_write_data   : uart_write_data),
                 .douta (mem_register_output_data)
                );
                
    
                
endmodule
