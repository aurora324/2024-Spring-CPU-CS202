`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 10:18:22
// Design Name: 
// Module Name: top
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

module top(
input clk,
input fpga_rst, 
input start_pg,         // Uart Start
input confirm,
input up,
input down,
input [`SWITCH_WIDTH] switch,
// UART
input rx,               // Receive
output tx,              // Transmit
// LED
output wire [15:0] led,    
// Seg-tube
output[`TUBE_WIDTH] seg_en,         
output[`TUBE_WIDTH] seg_out1,     
output[`TUBE_WIDTH] seg_out2,
// VGA
output [11:0]       rgb,      // Red, green and blue color signals
output              hsync,    // Line synchronization signal
output              vsync     // Field synchronization signal
);


    
     
  // UART Programmer Pinouts
    wire upg_clk, upg_clk_o;
    wire upg_wen_o; //Uart write out enable
    wire upg_done_o; //Uart rx data have done
    //data to which memory unit of program_rom/dmemory32
    wire [14:0] upg_adr_o;
    //data to program_rom or dmemory32
    wire [31:0] upg_dat_o;
    
    
    wire spg_bufg;
    // 分发复位信号，确保其在整个芯片上同步
    BUFG U1(.I(start_pg), .O(spg_bufg));
    
    reg upg_rst; //active high
    always @ (posedge clk) begin
            if (spg_bufg) upg_rst <= 0;
            if (fpga_rst) upg_rst <= 1;
        end
        
    wire rst;
   assign rst = fpga_rst | !upg_rst; // reset
    
    wire kickOff = upg_rst | (~upg_rst & upg_done_o); 
        
    wire cpu_clk;
    //  Clock
    cpuclk clk1(.clk_in1(clk), .cpu_clk(cpu_clk), .uart_clk(upg_clk));
    
    wire [`INST_LEN] inst;
    wire [`IMM_WIDTH] pc;
    wire [`IMM_WIDTH] immOut;
    wire PCSelect;
    wire PCSelect_back;
    
    wire upg_wen_I = upg_wen_o & (!upg_adr_o[14]);
    wire upg_wen_D = upg_wen_o & (upg_adr_o[14]);
    wire [13:0] upg_addr = upg_adr_o[13:0];
    wire [`INST_LEN] upg_data = upg_dat_o;
    wire upg_done = upg_done_o;

    wire [13:0] fetch_addr;
    
//    assign pc = 0;
    
    wire [`REG_WIDTH] ram_data_out;
   
    //  Uart
    uart_bmpg_0 uart_inst(
    .upg_clk_i(upg_clk),
    .upg_rst_i(upg_rst),
    .upg_rx_i(rx),
    .upg_clk_o(upg_clk_o),
    .upg_wen_o(upg_wen_o),
    .upg_adr_o(upg_adr_o),
    .upg_dat_o(upg_dat_o),
    .upg_done_o(upg_done_o),
    .upg_tx_o(tx)
    );
    wire [`INST_LEN] tempPC;
    // IF
    IF inst_fetch(
    .cpu_clk(cpu_clk), 
    .rst(rst),
    .pcSrc(PCSelect_back),
    .imm(immOut),
    .curPC(pc),
    .tempPC(tempPC),
    .fetch_addr(fetch_addr)
    );
    
    //  Instruction Memory
    programROM rom_inst(
    .rom_clk_i(cpu_clk),
    .rom_adr_i(fetch_addr),
    .Instruction_o(inst),
    .upg_rst_i(upg_rst),
    .upg_clk_i(upg_clk_o),
    .upg_wen_i(upg_wen_I),
    .upg_adr_i(upg_addr),
    .upg_dat_i(upg_dat_o),
    .upg_done_i(upg_done_o)
    );
   
   wire [`REG_IDX_LEN] write_r = inst[11:7];
   wire [`IMM_WIDTH] rd1;
   wire [`IMM_WIDTH] rd2;

   
   wire RegWrite;
   wire [`REG_WIDTH] write_back_data;
   
   wire Branch;
   wire [`ALU_OP_LEN] ALUOp;
   wire ALUsrc;
   
   wire [2:0] funct3;
   wire [6:0] funct7;
   wire [`REG_WIDTH] ALUResult;
   wire MemorIOtoReg;
   wire MemRead;
   wire MemWrite;
   wire IORead;
   wire IOWrite;
   
    // Controller
    Controller controller(.inst(inst),
    .ALU_result_high(ALUResult[31:10]),
    .Branch(Branch),
    .ALUOp(ALUOp),
    .ALUsrc(ALUsrc),
    .MemorIOtoReg(MemorIOtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .IORead(IORead),
    .IOWrite(IOWrite),
    .funct3(funct3),
    .funct7(funct7));
  
  
    // ID
        ID inst_decoder(.clk(cpu_clk), 
        .rst(rst), 
        .inst(inst),
        .write_en(RegWrite),
        .write_r(write_r),
        .write_data(write_back_data),
        .pc(tempPC),
        .MemRead(MemRead),
        .rd1(rd1),
        .rd2(rd2),
        .immOut(immOut),
        .PCSelect(PCSelect)
        );
    
   assign PCSelect_back = PCSelect;
   wire [6:0]opcode = inst[6:0];
   // EX    
   EX executer(.rd1(rd1),
   .rd2(rd2),
   .imm(immOut),
   .pc(tempPC),
   .ALUsrc(ALUsrc),
   .funct3(funct3),
   .funct7(funct7),
   .ALUOp(ALUOp),
   .opcode(opcode),
    .ALUResult(ALUResult)
    );
    
    DMemory32 dmem(
       .cpu_clk(cpu_clk),
       .mem_write_enable(MemWrite),
       .mem_address(ALUResult),
       .mem_write_data(rd2),
       .opcode(opcode),
       .funct3(funct3),
       .upg_rst(upg_rst),                  //UPG reset(Active High)
       .upg_clk(upg_clk),                  // UPG uart_clk (10MHz)
       .upg_write_enable(upg_wen_D),                  // UPG write enable
       .upg_adr(upg_addr),                  // UPG write address
       .upg_write_data(upg_data),           // UPG write data
       .upg_done(upg_done),                 // 1 if programming is finished);
       .mem_register_output_data(ram_data_out)
       );
       
   
          
   wire [31:0] addr_out;    
   wire SwitchCtrl, LEDCtrl, SEGCtrl, VGACtrl, ButtonCtrl;
   wire [31:0] write_data;
   wire [15:0] write_data_led;
   wire [31:0] write_data_seg;
   wire [31:0] write_data_vga;
   wire [31:0] memData;
   
   wire [`SWITCH_WIDTH] switchrdata;
   wire [16:0] all_button;
   
   // IO
   MemOrIO io(.addr_in(ALUResult),
   .mRead(MemRead),
   .mWrite(MemWrite),
   .IORead(IORead),
   .IOWrite(IOWrite),
   .m_rdata(ram_data_out),
   .io_rdata_switch(switchrdata),
   .io_rdata_button(all_button),
   .r_rdata(rd2),
   .r_wdata(memData),
   .write_data(write_data),
   .write_data_led(write_data_led),
   .write_data_seg(write_data_seg),
   .write_data_vga(write_data_vga),
   .addr_out(addr_out),
   .LEDCtrl(LEDCtrl),
   .SEGCtrl(SEGCtrl),
   .VGACtrl(VGACtrl),
   .SwitchCtrl(SwitchCtrl),
   .ButtonCtrl(ButtonCtrl)); 
    
        
   // WB
   WB write_back(.clk(cpu_clk),
       .memData(memData),
       .MemorIOtoReg(MemorIOtoReg),
       .ALUResult(ALUResult),
       .write_back(write_back_data)
       );
       
     // Button 
//     wire confirm_key;
//     debounce_button c(clk_20ms,confirm,confirm_key);   
   
    button button_inst(
        .clk(cpu_clk), 
        .rst(rst),
        .IORead(IORead),
        .ButtonCtrl(ButtonCtrl),
        .buttonaddr(addr_out[1:0]),
        .confirm(confirm), 
        .up(up),
        .down(down),
        .all_button(all_button)
        );
                 

    //  Switch
    switchs switchs_inst(
    .clk(cpu_clk),
    .rst(rst),
    .IORead(IORead),
    .SwitchCtrl(SwitchCtrl),
    .switchaddr(addr_out[1:0]),
    .switch(switch),
    .switchrdata(switchrdata)
    );
       
    //  LED
    leds leds_inst(
    .clk(cpu_clk),
    .rst(rst),
    .kickOff(kickOff),
    .IOWrite(IOWrite),
    .LEDCtrl(LEDCtrl),
    .ledaddr(addr_out[1:0]),
    .ledwdata(write_data_led),
    .led(led)
    );
     

    
      
    //  SEG
    segs segs_inst(
    .clk(cpu_clk),
    .rst(rst),
    .kickOff(kickOff),
    .IOWrite(IOWrite),
    .SEGCtrl(SEGCtrl),
    .segaddr(addr_out[1:0]),
    .segwdata(write_data_seg),
    .seg_en(seg_en),
    .seg_out1(seg_out1),
    .seg_out2(seg_out2)
    );
       
   //  VGA
    vgas vgas_inst(
    .clk(cpu_clk),
    .rst(rst),
    .kickOff(kickOff),
    .IOWrite(IOWrite),
    .VGACtrl(VGACtrl),
    .vgaaddr(addr_out[1:0]),
    .vgawdata(write_data_vga[15:0]),
    .rgb(rgb),
    .hsync(hsync),
    .vsync(vsync)
    );  
    
endmodule