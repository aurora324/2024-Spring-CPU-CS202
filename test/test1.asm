.data
	a: .word 0x0
.text

#IO基地址0xFFFFFC
addi s11, s11, 0xFF
slli s11, s11, 8
addi s11, s11, 0xFF
slli s11, s11, 8
addi s11, s11, 0xFC
slli s11, s11, 8

addi a5, zero, 0x4 #confrm--100--foe scene choose
addi a6, zero, 0x2 #up--010
addi a7, zero, 0x1 #down--001
add t5, zero, zero #t5用于存储ab
choose:
	lw t2, 0x50(s11)#拨码开关后三位 选择case
	sw t2, 0x60(s11)
	sw t2, 0x70(s11)
	sw t2, 0x80(s11)
	li zero, 0
	li a0, 0
	lw a1, 0x90(s11)#读按钮数据
	slli t2, t2, 29
	srli t2, t2, 29
	bne a1, a5, choose#没按按钮重复循环
	#确定模式选择
	li s10, 0
	beq t2, s10, case0
	addi s10, s10, 1
	beq t2, s10, case1
	addi s10, s10, 1
	beq t2, s10, case2
	addi s10, s10, 1
	beq t2, s10, case3
	addi s10, s10, 1
	beq t2, s10, case4
	addi s10, s10, 1
	beq t2, s10, case5
	addi s10, s10, 1
	beq t2, s10, case6
	addi s10, s10, 1
	beq t2, s10, case7

	beq zero, zero, choose

case0:
	sw zero, 0x70(s11)
	sw zero, 0x80(s11)
	sw zero, 0x60(s11)
loop1:
    	lw a0, 0x50(s11)
    	lw a1, 0x90(s11)
    	bne a1, a6, loop1
  
loop2:
     	sw a0, 0x60(s11)
     	lw a1, 0x90(s11)
     	bne a1, a7, loop2
     
loop3:
	sw zero, 0x60(s11)
    	lw a0, 0x50(s11)
   	lw a1, 0x90(s11)
    	bne a1, a6, loop3
  
loop4:
     	sw a0, 0x60(s11)
     	lw a1, 0x90(s11)
     	bne a1, a7, loop4

loop5:
	sw zero, 0x60(s11)
	lw a1, 0x90(s11)  
	bne a1,a6,loop5
	beq zero,zero,choose
     
     
case1:
	sw zero, 0x70(s11)
	sw zero, 0x80(s11)
	sw zero, 0x60(s11)
loop11: 
	lw a0, 0x50(s11)
    	lw a1, 0x90(s11)
	bne a1, a6, loop11 

        sw a0,4(zero) #将拨码开关的数据存进内存 4
        lb a0,4(zero) #读取内存中的数据
        slli t5, a0, 16 # a 存到高位

loop12:
	sw a0, 0x60(s11)
	sw a0, 0x70(s11)
	sw a0, 0x80(s11)
	lw a1, 0x90(s11)
	bne a1, a7, loop12 

loop13:
	sw zero, 0x60(s11)
	sw zero, 0x70(s11)
	sw zero, 0x80(s11)
	lw a1, 0x90(s11)  
	bne a1,a6,loop13
	beq zero,zero,choose


case2:
	sw zero, 0x70(s11)
	sw zero, 0x80(s11)
	sw zero, 0x60(s11)
loop21: 
	lw a0, 0x50(s11)
    	lw a1, 0x90(s11)
	bne a1, a6, loop21 

	sw a0,8(zero) #将拨码开关的数据存进内存 8
	lbu a0,8(zero) #读取内存中的数据
	add t5, t5, a0 #b存到低位
	############################
loop22:
	sw a0, 0x60(s11)
	sw a0, 0x70(s11)
	sw a0, 0x80(s11)
	lw a1, 0x90(s11)
	bne a1, a7, loop22 

loop23:
	sw zero, 0x60(s11)
	sw zero, 0x70(s11)
	sw zero, 0x80(s11)
	lw a1, 0x90(s11)  
	bne a1,a6,loop23
	beq zero,zero,choose


case3:
	sw zero, 0x70(s11)
	sw zero, 0x80(s11)
	sw zero, 0x60(s11)
	#sw zero, 0x60(s11)
	lb a2,4(zero)
	lbu a3,8(zero)
	################################################
	slli t5, a2, 16 # a 存到高位
	add t5, t5, a3
	#################################################
loop30:
	sw t5, 0x70(s11)
	sw t5, 0x80(s11)
	lw a1, 0x90(s11)
	bne a1,a6,loop30 #a6
	
	beq a2, a3, loop31 
	# 在最后一个led展示是否beq
	add a0, zero, zero
loop32:
	sw zero, 0x60(s11)
	lw a1, 0x90(s11) 
	bne a1,a7,loop32 #a7
	beq zero,zero,choose
loop31:
	addi a0, zero, 1
loop33:
	sw a0, 0x60(s11)
	lw a1, 0x90(s11) 
	bne a1,a7,loop31 #a7
	beq zero,zero,choose


case4:
	sw zero, 0x70(s11)
	sw zero, 0x80(s11)
	sw zero, 0x60(s11)
	#sw zero, 0x60(s11)
	lb a2,4(zero)
	lbu a3,8(zero)
	################################################
	slli t5, a2, 16 # a 存到高位
	add t5, t5, a3
	#################################################
loop40:
	sw t5, 0x70(s11)
	sw t5, 0x80(s11)
	lw a1, 0x90(s11)
	bne a1,a6,loop40 #a6
	
	blt a2, a3, loop41 
	# 在最后一个led展示是否beq
	add a0, zero, zero
loop42:
	sw zero, 0x60(s11)
	lw a1, 0x90(s11) 
	bne a1,a7,loop42 #a7
	beq zero,zero,choose
loop41:
	addi a0, zero, 1
loop43:
	sw a0, 0x60(s11)
	lw a1, 0x90(s11) 
	bne a1,a7,loop41 #a7
	beq zero,zero,choose


case5:
	sw zero, 0x70(s11)
	sw zero, 0x80(s11)
	sw zero, 0x60(s11)
	#sw zero, 0x60(s11)
	lb a2,4(zero)
	lbu a3,8(zero)
	################################################
	slli t5, a2, 16 # a 存到高位
	add t5, t5, a3
	#################################################

loop50:
	sw t5, 0x70(s11)
	sw t5, 0x80(s11)
	lw a1, 0x90(s11)
	bne a1,a6,loop50 #a6

	bge a2,a3,loop51
	# 在最后一个led展示是否bge
	add a0,zero,zero
loop52: 
	sw zero, 0x60(s11)
	lw a1, 0x90(s11)  
	bne a1,a7,loop52 #a7
	beq zero,zero,choose

loop51:
	addi a0,zero,1
loop53: 
	sw a0, 0x60(s11)
	lw a1, 0x90(s11) 
	bne a1,a7,loop53 #a7
	beq zero,zero,choose


case6:
	sw zero, 0x70(s11)
	sw zero, 0x80(s11)
	sw zero, 0x60(s11)
	#sw zero, 0x60(s11)
	lb a2,4(zero)
	lbu a3,8(zero)
	################################################
	slli t5, a2, 16 # a 存到高位
	add t5, t5, a3
	#################################################

loop60:
	sw t5, 0x70(s11)
	sw t5, 0x80(s11)
	lw a1, 0x90(s11)
	bne a1,a6,loop60 #a6

	bltu a2,a3,loop61
	# 在最后一个led展示是否bltu
	add a0,zero,zero
loop62: 
	sw zero, 0x60(s11)
	lw a1, 0x90(s11)  
	bne a1,a7,loop62 #a7
	beq zero,zero,choose

loop61:
	addi a0,zero,1
loop63: 
	sw a0, 0x60(s11)
	lw a1, 0x90(s11) 
	bne a1,a7,loop63 #a7
	beq zero,zero,choose


case7:
	sw zero, 0x70(s11)
	sw zero, 0x80(s11)
	sw zero, 0x60(s11)
	#sw zero, 0x60(s11)
	lb a2,4(zero)
	lbu a3,8(zero)
	################################################
	slli t5, a2, 16 # a 存到高位
	add t5, t5, a3
	#################################################

loop70:
	sw t5, 0x70(s11)
	sw t5, 0x80(s11)
	lw a1, 0x90(s11)
	bne a1,a6,loop70 #a6
	
	bgeu a2,a3,loop71
	# 在最后一个led展示是否bgeu
	add a0,zero,zero
loop72: 
	sw zero, 0x60(s11)
	lw a1, 0x90(s11)  
	bne a1,a7,loop72 #a7
	beq zero,zero,choose

loop71:
	addi a0,zero,1
loop73: 
	sw a0, 0x60(s11)
	lw a1, 0x90(s11) 
	bne a1,a7,loop73 #a7
	beq zero,zero,choose 
     
    
     
