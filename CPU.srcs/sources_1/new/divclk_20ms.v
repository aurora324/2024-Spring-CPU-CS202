`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/07 21:31:26
// Design Name: 
// Module Name: divclk_20ms
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


module divclk_20ms(
input clk,
output reg clk_20ms
    );
//    parameter period=2000;
    reg [15:0] cnt;
    always @(posedge clk)
    begin
//        if (~rst_n) begin
//            cnt<=0;
//            clk_20ms<=0;
//        end
//        else
            if (cnt==0)
            begin
                clk_20ms <= ~clk_20ms;
            end
            else begin
                cnt <= cnt+1;
            end 
    end
endmodule