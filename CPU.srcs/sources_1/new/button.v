`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/31 19:56:37
// Design Name: 
// Module Name: button
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


module button(input clk,                      // 20MHz CPU clk                  
               input rst,                      // Reset
               input IORead,                   // IO sign
               input ButtonCtrl,               // Button ctrl
               input [1:0] buttonaddr,         // Button address
               input confirm,            // Button right
               input up,            // Button up
               input down,            // Button down
               output [16:0] all_button
               ); // Button read data
 
          reg right_buttondata;
          reg up_buttondata; 
          reg down_buttondata;      
               
            always@* begin
               if (ButtonCtrl && IORead) begin
                     right_buttondata=confirm;
                     up_buttondata=up;
                     down_buttondata=down;
                     
               end
            end   
            
            assign all_button={13'b0000000000000,right_buttondata,up_buttondata,down_buttondata};
            
//            always @ (negedge clk or posedge rst) begin
//                  if(rst)
//                     all_button<=16'b0;
//                  else
//                     all_button<={14'b00000000000000,up_buttondata,right_buttondata};
//            end
            
            
//                reg pre_pulse1;
//                reg now_pulse1;
//               always @ (negedge clk or posedge rst) begin
//                    if(rst)
//                    begin
//                        right_buttondata <= 1'b0;
//                        pre_pulse1<=1'b0;
//                        now_pulse1<=1'b0;
//                     end
//                    else
//                       if (ButtonCtrl && IORead) begin
//                            pre_pulse1<=now_pulse1;
//                            now_pulse1<=confirm;
//                            right_buttondata<=1'b0;
//                            if(~pre_pulse1&now_pulse1)
//                                begin
//                                  right_buttondata<=~right_buttondata;
//                                end 
//                            else         
//                                begin
//                                    right_buttondata<=right_buttondata;
//                                end
//                          end 
//                    end
                    
//                    reg pre_pulse2;
//                    reg now_pulse2;
//                    always @ (negedge clk or posedge rst) begin
//                                        if(rst)
//                                        begin
//                                            up_buttondata <= 1'b0;
//                                            pre_pulse2<=1'b0;
//                                            now_pulse2<=1'b0;
//                                         end
//                                        else
//                                           if (ButtonCtrl && IORead) begin
//                                                pre_pulse2<=now_pulse2;
//                                                now_pulse2<=choose;
//                                                up_buttondata<=1'b0;
//                                                if(~pre_pulse2&now_pulse2)
//                                                    begin
//                                                      up_buttondata<=~up_buttondata;
//                                                    end 
//                                                else         
//                                                    begin
//                                                        up_buttondata<=up_buttondata;
//                                                    end
//                                              end 
//                                        end
                                   
endmodule

