`timescale 1ns / 1ps

module compare_tb();
    reg [31:0] data1;
    reg [31:0] data2;
    reg Unsigned;
    wire[1:0]out;
    compare com(data1, data2, 1'b0, out);
    initial begin
            data1 = 32'b0;
            data2 = 32'b0;
            #5 $finish;
        end
endmodule
