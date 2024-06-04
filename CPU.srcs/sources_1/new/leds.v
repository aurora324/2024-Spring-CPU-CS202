`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/15 13:10:33
// Design Name: 
// Module Name: leds
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

module leds(input clk,             // 20MHz CPU clk
            input rst,             // Reset
            input kickOff,
            input IOWrite,         // IO sign
            input LEDCtrl,         // LED ctrl
            input[1:0] ledaddr,    // LED address
            input[15:0] ledwdata,  // LED write data
            output reg[15:0] led); // LED
    
//    always@(posedge clk or posedge rst) begin
    always@(*) begin
        if (rst) begin
             if (kickOff == 1'b0) begin
                  led = 16'hffff;
              end
              else begin
                  led = 16'h0000;
              end   
        end
        else if (LEDCtrl && IOWrite) begin
            if (ledaddr == 2'b00)
                led[15:0] = ledwdata[15:0];
            else if (ledaddr == 2'b01)
                led[15:0] = { 8'h00, ledwdata[15:8] };
            else
                led = led;
        end
        else begin
            led = led;
        end
    end
endmodule
