# CS202-Project-CPU

# 开发者说明

## 成员

|   学号   |  姓名  | 贡献比 |
| :------: | :----: | :----: |
| 12210652 | 张伟祎 | 33.3%  |
| 12210723 | 王禀钦 | 33.3%  |
| 12210360 | 黄奕凡 | 33.3%  |



|        | top  | uart | asm1 | asm2 | 模块实现 | 模块测试 | MMIO |
| :----: | :--: | :--: | :--: | ---- | :------: | :------: | ---- |
| 张伟祎 |  √   |  √   |  √   |      |    √     |    √     | √    |
| 王禀钦 |      |      |  √   | √    |    √     |    √     | √    |
| 黄奕凡 |      |  √   |  √   |      |    √     |    √     | √    |

## 开发计划日程安排

### 5.1-5.7

project放出第一周，开始阅读项目要求，各自设计CPU部分

### 5.8-5.14

* 完成各个模块的初步设计，包括`PC, Controller, GenImm, ALU, inst_mem, data_mem`

* 一些输出和显示模块：`vga, led`

### 5.15-5.21

* 连接uart

* 连接5个阶段内部：`IF, ID, EX, MEM, WB`

* 连接顶层`top`

### 5.22-5.26

* 单元测试

# CPU架构设计说明

## CPU 特性

> * ISA（含所有指令（指令名、对应编码、使用方式），参考的ISA，基于参考ISA本次作业所做的更新或优化；寄存器（位宽和数目）等信息）； 对于异常处理的支持情况。
> *  CPU 时钟、CPI ，属于单周期还是多周期CPU ，是否支持 pipeline （如支持，是几级流水，采用什么方式解决的流水线冲突问题）。
> * 寻址空间设计：属于冯. 诺依曼结构还是哈佛结构；寻址单位，指令空间、数据空间的大小，栈空间的基地址。
> * 对外设IO 的支持：采用单独的访问外设的指令（以及相应的指令）还是 MMIO （以及相关外设对应的地址），采用轮询还是中断的方式访问IO。


### ISA（指令集架构）

- **参考的ISA**: RISC-V
- **寄存器**: 32比特寄存器，包括通用寄存器、程序计数器（PC）、栈
- **异常处理**: 

### 实现指令集
* R: `add,sub,xor,or,and,sll,srl,sra,slt,sltu`
* I: `addi,xori,ori,andi,slli,srli,srai,slti,sltiu`
* Load: `lb,lbu,lw,lh,lhu`
* Store: `sw`
* B: `beq,bne,blt,bge,bltu,bgeu`
* Jump: `jal,jalr`
* U: `auipc,lui`

### 时钟与性能

- **CPU时钟**: 
	- FPGA (clk): 25MHz
	- Uart (uart_clk): 10Mhz
	- CPU (cpu_clk): 10Mhz
- **CPI**: 1
- **CPU类型**: 单周期（Single-Cycle）

### 寻址空间设计

- **结构类型**: 哈佛结构
- **寻址单位**: 以一个word为单位
- **指令空间与数据空间**: 提供指令空间和数据空间的大小，例如16MB指令空间、32MB数据空间等。
- **栈空间**: 
	- 栈空间的基地址`0x7fff_effc`
	- 大小：和内存等大 16384

### 对外设IO的支持

- **MMIO** CPU通过内存映射IO（MMIO）访问外设
  
    地址映射表
    
    | 输入输出设备   | 对应地址   |
    | -------------- | ---------- |
    | 拨码开关[16个] | 0xFFFFFC50 |
    | led灯          | 0xFFFFFC60 |
    | 七段数码显示管 | 0xFFFFFC70 |
    | 按钮           | 0xFFFFFC90 |
    
    
    
- **IO访问方式**: CPU是采用轮询的方法

## CPU 接口

* 时钟、复位、 uart 接口、其他常用IO接口说明。

## CPU 内部结构

*  CPU 内部各子模块的接口连接关系图

<center>
    picture of RTL
</center>

*  CPU 内部子模块的设计说明（子模块端口规格及功能说明）

### programROM

* 用一个信号控制是否使用uart。如果不用uart，直接根据读入的内存地址读取出需要的指令地址值；如果要使用uart，与要使用uart时钟，和一个 active high 的 reset 控制 uart 的开关，并且需要读取指令，就把指令放在对应的位置。

### IF

* 

## Bonus 部分

* Uart

* lui auipc

* CEO文件创作工具

# 系统上板使用说明

* 点击按钮 left [V1] 开启通信模式，所有led灯全亮，传输结束后led灯回熄灭
* 点击 center [R15] 进入CPU工作模式
* 使用后三位拨码开关选择case 选择的case会实时显示在七段数码显示管上
* 点击 right [R11]确认case选择 
* 在每个ca'se交替点击 up[U4]， down [R17] 确定输入或结束显示（结束循环）
* <img src="C:\Users\lenovo\Documents\WeChat Files\wxid_dvb4tq9ufmeh22\FileStorage\Temp\aace154a3fd9755b4ad7958cf8ac11b.png" alt="aace154a3fd9755b4ad7958cf8ac11b" style="zoom: 67%;" />

# 自测说明
* 以表格的方式罗列出测试方法（仿真、上板）、测试类型（单元、集成）、测试用例（除本文及OJ 以外的用例）描述、测试结果（通过、不通过），以及最终的测试结论。
## 总体测试

1. 出现timing的critical warning

   解决：将uart的控制时钟(upg_clk)由23MHz换位10MHz

2. 出现reset信号逻辑错误

​	解决：使用按键V1 R15 均为低电平有效 明确不同reset信号的功能

```verilog
input start_pg  
input fpga_rst, // 用于开启cpu工作模式
input start_pg, // 用于控制uart进入通信模式
wire spg_bufg;
// 分发复位信号，确保其在整个芯片上同步
    BUFG U1(.I(start_pg), .O(spg_bufg));
    
    reg upg_rst; //active high
    always @ (posedge clk) begin
            if (spg_bufg) upg_rst <= 0;
            if (fpga_rst) upg_rst <= 1;
        end
        
 wire rst = fpga_rst|!upg_rst // 用于传入各个模块进行reset
 wire kickOff = upg_rst | (~upg_rst & upg_done_o); 
```





## 单元测试

### Uart

| 测试方法 |                       问题描述                        | 解决方案                                                     | 测试结果 |
| :------: | :---------------------------------------------------: | ------------------------------------------------------------ | -------- |
|   仿真   | upg_rst和fpga_rst之间的逻辑错误，无法正确开启通信模式 | 项目所用按钮按下为高电平，upg_rst用于控制uart，使用按键V1；fpga_rst用于进入工作模式，使用按键R15 | 通过     |
|   上板   |    使用串口传输助手发送，出现了先接收后发送的问题     | 原来换个板子就好了：)                                        | 通过     |



### IF模块



### ID模块

1. 计算pc和计算ALU_Result都通过alu模块，会产生冲突。基于**下降沿更新pc、上升沿取指、下降沿写入Mem**的设计，最初在时钟下降沿写回Register。如图所示为lw指令，会将Mem取回的值错误的存在下一条指令对应的寄存器。

   <img src="D:\CPU\pic\1.png" alt="1" style="zoom:50%;" />

   ​	解决：在最初的解决方式中我们尝试了对ALUResult进行延迟处理，发现行不通后又继续往前对很多传递途径中涉及的信号进行了延迟，时钟没有解决问题。

   ​	最终我们发现一条指令的处理周期不能超过两个时钟周期，因此我们改为在**时钟上升沿写回Register**，解决了lw指令的问题，并进一步对pc进行半个周期的latch，以服务于指令跳转







### EX模块
`EX` 模块最为主要的是`ALU`部分
实现了

| 测试方法 |                  测试用例描述                  | 测试结果 |
| :--: | :--------------------------------------: | ---- |
|  仿真  | 测试`load`,`store`指令时`ALU`计算情况（`ALUOp=00`） | 通过   |
|  仿真  |   测试`I,R`两种类型指令在不同funct3，funct7影响下计算结果   | 通过   |
|  仿真  |                测试`auipc`                 | 通过   |
|  仿真  |         测试`jal,jalr` 能否实现`pc+4`          | 通过   |









### MMIO

| 测试方法 |                    测试用例描述                     | 测试结果 |
| :------: | :-------------------------------------------------: | -------- |
|   上板   | 通过拨码开关与按钮输入，通过LED和七段数码显示管输出 | 通过     |

遇到的问题及解决方案：

1. 输入输出无法交互，输出设备无显示

   解决：所有输入设备的读入和更新、所有输出设备的更新均使用组合逻辑，避免因为时钟沿更新导致的冲突和错误

2. 用按钮实现确定、跳转等功能时，因为按钮0-1状态不稳定，而读取输入和显示输出又需要在loop里反复执行，一个确认按钮很容易导致一次跳转多个循环

​	解决：使用两个按钮交替作为确认按键，通过规定常数（001，010，100）来表示不同的按钮。

```assembly
addi a5, zero, 0x4 #confrm--100--for scene choose
addi a6, zero, 0x2 #up--010
addi a7, zero, 0x1 #down--001

##场景选择##

case0:
	sw zero, 0x70(s11)
	sw zero, 0x60(s11)
loop1:
    	lw a0, 0x50(s11)
    	lw a1, 0x90(s11)
    	bne a1, a6, loop1 #a6
  
loop2:
     	sw a0, 0x60(s11)
     	lw a1, 0x90(s11)
     	bne a1, a7, loop2 #a7
     
loop3:
	sw zero, 0x60(s11)
    	lw a0, 0x50(s11)
   	lw a1, 0x90(s11)
    	bne a1, a6, loop3 #a6
  
loop4:
     	sw a0, 0x60(s11)
     	lw a1, 0x90(s11)
     	bne a1, a7, loop4 #a7

loop5:
	sw zero, 0x60(s11)
	lw a1, 0x90(s11)  
	bne a1,a6,loop5 #a6
	beq zero,zero,choose

```

3. 数码管出现闪烁问题，且显示内容与预期不符，发现原因是在同一个loop中对led灯和七段数码显示管赋不同的值，会导致硬件中ALUResult的结果反复变化，存入输出设备的值也在循环变化。

​	解决: 每个循环中如果led和七段数码显示管同时需要展示结果，则展示相同的结果，且每次进入一个case的时候先对数码管和led灯进行清空，清除上一个case中可能存储的脏数据。例如：

```assembly
sw zero, 0x70(s11)
```

4. Type Error 寄存器用混导致输出结果不正确

​	解决：以测试场景1为例，以a0专门存储输出结果，以a1专门存储按钮的结果，

<img src="D:\CPU\pic\2.png" alt="2" style="zoom:50%;" />



# 问题及总结

* 
