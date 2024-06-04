`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/15 13:12:11
// Design Name: 
// Module Name: switchs
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


module switchs(input clk,                      // 20MHz CPU clk
               input rst,                      // Reset
               input IORead,                   // IO sign
               input SwitchCtrl,               // Switch ctrl
               input [1:0] switchaddr,         // Switch address
               input [15:0] switch,            // Switch
               output reg [15:0] switchrdata); // Switch read data
    
   
    
//    always@(negedge clk or posedge rst) begin
always@(*) begin
        if (rst) begin
            switchrdata = 16'h0000;
        end
        else if (SwitchCtrl && IORead) begin
            if (switchaddr == 2'b00)begin
                switchrdata[15:0] = switch[15:0];
            end else if (switchaddr == 2'b10)begin
                switchrdata[15:0] = { 8'h00, switch[15:8] };
            end else begin
                switchrdata = switchrdata;
            end
        end
        else begin
            switchrdata = switchrdata;
        end
    end
endmodule
