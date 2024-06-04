`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/22 09:10:18
// Design Name: 
// Module Name: top_tb
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

module top_tb();

reg clk;
reg fpga_rst;
reg start_pg;         // Uart Start
reg confirm;
reg [`SWITCH_WIDTH] switch;
// UART
reg rx;               // Receive



wire tx;              // Transmit
// LED
wire [15:0] led;    
// Seg-tube
wire[`TUBE_WIDTH] seg_en;        
wire[`TUBE_WIDTH] seg_out1; 
wire[`TUBE_WIDTH] seg_out2;
// VGA
wire [11:0]       rgb;      // Red, green and blue color signals
wire              hsync;    // Line synchronization signal
wire              vsync;     // Field synchronization signal


top seg_error(  clk,
                fpga_rst,
                start_pg,
                confirm,
                switch,
                rx,
                
                tx,
                led,
                seg_en,
                seg_out1,
                seg_out2,
                rgb,
                hsync,
                vsync);


initial begin
        switch = 16'b0;
        #112000 switch = 16'h0300;
end
initial begin
        confirm = 1'b0;
        #80000 confirm = 1'b1;
        #10000 confirm = ~confirm;
        #120000 confirm = ~confirm;
        #1000000000 confirm = ~confirm;
end

initial begin
        rx = 1'b1;
        
        clk=1'b0;
        forever #100 clk=~clk;
//        repeat(50) #5 clk=~clk;
//        #5 $finish;
    end
    
    initial begin
        start_pg = 1'b0;
        #140 start_pg = ~start_pg;
        #280 start_pg = ~start_pg;
    end
    
    initial begin
        fpga_rst = 1'b0;
        #140 fpga_rst = ~fpga_rst;
        #280 fpga_rst = ~fpga_rst;
        #44000 fpga_rst = ~fpga_rst;
        #10000 fpga_rst = ~fpga_rst;
    end
endmodule
