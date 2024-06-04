
`define s11                 160000

`define INST_LEN            31:0
`define REG_IDX_LEN         4:0
`define REG_WIDTH           31:0
`define IMM_WIDTH           31:0


`define SWITCH_WIDTH        15:0
`define LED_WIDTH           15:0
`define TUBE_WIDTH          7:0


`define ALU_OP_LEN          1:0
`define INST_TYPES_WIDTH    2:0
`define FUNCT3_WIDTH        2:0
`define FUNCT7_WIDTH        6:0
`define OP_WIDTH            6:0

// OPCODE 不知道定义成什么，先放在这里
`define typeR               3'h1
`define typeI               3'h2
`define typeS               3'h3
`define typeB               3'h4
`define typeJ               3'h5
`define typeU               3'h6
`define typeIL              3'h7

`define opR                 7'b0110011
`define opI                 7'b0010011
`define opIL                7'b0000011
`define opIJ                7'b1100111
`define opIE                7'b1110011
`define opS                 7'b0100011
`define opB                 7'b1100011
`define opJ                 7'b1101111
`define opU                 7'b0110111
`define opAU                7'b0010111


`define UNSIGNED            1'b1
`define SIGNED              1'b0

// compare
`define EQUAL               2'b00
`define LESS                2'b01
`define GREATER_EQ          2'b10

// control
`define PCSEL_JUMP           1'b1
`define PCSEL_PC             1'b0

//VGA
// 水平/垂直数据
`define HDAT_BEGIN          10'd143 
`define HDAT_END            10'd783
`define VDAT_BEGIN          10'd34
`define VDAT_END            10'd514
 // 水平/垂直同步信号
`define HSYNC_END           10'd95
`define VSYNC_END           10'd1
// 水平/垂直像素
`define HPIXEKL_END         10'd799
`define VLINE_END           10'd524

`define A                   6'b00_1010
`define C                   6'b00_1100
`define E                   6'b00_1110
`define L                   6'b01_0101
`define M                   6'b01_0110
`define N                   6'b01_0111
`define O                   6'b01_1000
`define R                   6'b01_1011
`define S                   6'b01_1100
`define T                   6'b01_1101
`define U                   6'b01_1110
    