module DMemory32(
    input                       cpu_clk,
    input                       mem_write_enable,
    input   [`REG_WIDTH]        mem_address,
    input   [`REG_WIDTH]        mem_write_data,
    input   [`OP_WIDTH]         opcode,
    input   [`FUNCT3_WIDTH]     funct3,
    
    // UART Programmer Pinouts
    input                       upg_rst,                  //UPG reset(Active High)
    input                       upg_clk,                  // UPG uart_clk (10MHz)
    input                       upg_write_enable,                  // UPG write enable
    input   [13:0]              upg_adr,                  // UPG write address
    input   [`REG_WIDTH]        upg_write_data,           // UPG write data
    input                       upg_done,                 // 1 if programming is finished);
    
    //output
    output  [`REG_WIDTH]    mem_register_output_data
    );
    
    wire counter_cpu_clk = !cpu_clk;   
    /* CPU work on normal mode when kickOff is 1.
     CPU work on Uart communicate mode when kickOff is 0.*/
    wire kickOff = upg_rst | ( ~ upg_rst & upg_done);
    wire [`REG_WIDTH] out;
    reg  [`REG_WIDTH] mem_o;

    data_mem dm(
                 .clka  (kickOff ? counter_cpu_clk   : upg_clk),
                 .wea   (kickOff ? mem_write_enable  : upg_write_enable),
                 .addra (kickOff ? mem_address[15:2] : upg_adr),
                 .dina  (kickOff ? mem_write_data    : upg_write_data),
                 .douta (out)
                );
                
     wire [1:0] offset = mem_address[1:0];

     always@* begin
        if(opcode == `opIL) begin
            case(funct3)
                3'h0: mem_o = (offset == 2'b01) ? {{24{out[15]}},out[15:8]}: 
                              (offset == 2'b10) ? {{24{out[23]}},out[23:16]}: 
                              (offset == 2'b11) ? {{24{out[31]}},out[31:24]}: 
                                                  {{24{out[7]}},out[7:0]}; // lb
                3'h1: mem_o = (offset == 2'b10) ? {{16{out[31]}},out[31:16]} : {{16{out[15]}},out[15:0]}; // lh
                3'h4: mem_o = (offset == 2'b01) ? {24'b0,out[15:8]}: 
                              (offset == 2'b10) ? {24'b0,out[23:16]}: 
                              (offset == 2'b11) ? {24'b0,out[31:24]}:
                                                  {24'b0,out[7:0]}; // lbu
                3'h5: mem_o = (offset == 2'b10) ? {16'b0,out[31:16]} : {16'b0,out[15:0]}; // lhu
                default: mem_o = out;
            endcase
        end else mem_o = out;
     end
     
     assign mem_register_output_data = mem_o;
endmodule
