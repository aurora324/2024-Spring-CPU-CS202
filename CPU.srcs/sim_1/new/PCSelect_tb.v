`timescale 1ns / 1ps

module PCSelect_tb();
    reg [31:0] inst;
    reg [31:0] rd1;
    reg [31:0] rd2;
    wire PCSel;
    PCselect PC(inst, rd1, rd2, PCSel);
    initial begin
        inst = 32'h0;
        rd1 = 32'b0;
        rd2 = 32'b0;
    end
    always begin
        #5 inst = 32'hfe050ee3;
           rd1 = 32'b0;
           rd2 = 32'b0;
        
    #5 $finish;
    end
endmodule
