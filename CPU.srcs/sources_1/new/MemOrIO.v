`timescale 1ns / 1ps
`include "ParamDef.vh"

module MemOrIO(input mRead,                  // Read memory, from Controller
          input mWrite,                 // Write memory, from Controller
          input IORead,                 // Read IO, from Controller
          input IOWrite,                // Read IO, from Controller
          input[31:0] addr_in,          // From Alu_result in ALU
          output[31:0] addr_out,        // Address to Data-Memory
          input[31:0] m_rdata,          // Data read from Data-Memory
          input[15:0] io_rdata_switch,  // Data read from IO, 16 bits
          input[15:0] io_rdata_button,
          input[31:0] r_rdata,          // Data read from Decoder(register file)
          output[31:0] r_wdata,         // Data to Decoder(register file)
          output reg [31:0] write_data, // Data to memory or I/O
          output reg [15:0] write_data_led, // Data to I/O
          output reg [31:0] write_data_seg, // Data to I/O
          output reg [31:0] write_data_vga, // Data to I/O
          output LEDCtrl,               // LED Chip Select
          output SEGCtrl,               // SEG Chip Select
          output VGACtrl,               // VGA Chip Select
          output SwitchCtrl,            // Switch Chip Select
          output ButtonCtrl);           
    
    reg [15:0] io_rdata;
    always @* begin
        if(ButtonCtrl) io_rdata = io_rdata_button;
        else if (SwitchCtrl) io_rdata = io_rdata_switch;
    end
    
    assign addr_out   = addr_in;
    assign r_wdata    = (IORead  == 1'b1)?{16'h0000,io_rdata}:m_rdata; // may from memory or I/O, if from I/O, it is rdata's lower 16bit
    assign ButtonCtrl = (IORead == 1'b1 && addr_in[7:4] == 4'b1001)?1'b1:1'b0; //buttonCtrl, 1 is effective   ? 0xFFFF_FC90
    assign SwitchCtrl = (IORead == 1'b1 && addr_in[7:4] == 4'b0101)?1'b1:1'b0; //switchCtrl, 1 is effective   ? 0xFFFF_FC50
    assign LEDCtrl    = (IOWrite == 1'b1 && addr_in[7:4] == 4'b0110)?1'b1:1'b0; // ledCtrl, 1 is effective   ? 0xFFFF_FC60
    assign SEGCtrl    = (IOWrite == 1'b1 && addr_in[7:4] == 4'b0111)?1'b1:1'b0; //segCtrl, 1 is effective   ? 0xFFFF_FC70
    assign VGACtrl    = (IOWrite == 1'b1 && addr_in[7:4] == 4'b1000)?1'b1:1'b0; //vgaCtrl, 1 is effective   ? 0xFFFF_FC80
    
    
    always @*begin
        if ((mWrite == 1'b1)||(IOWrite == 1'b1)) begin
            write_data = ((mWrite == 1'b1)?r_rdata:{16'h0000,r_rdata[15:0]});
            write_data_led = r_rdata[15:0];
            write_data_seg = r_rdata;
            write_data_vga = r_rdata;
            end
//        else begin
//            write_data = 32'hZZZZ_ZZZZ;
//            write_data_seg = 32'hZZZZ_ZZZZ;
//            write_data_vga = 32'hZZZZ_ZZZZ;
//        end
    end
endmodule