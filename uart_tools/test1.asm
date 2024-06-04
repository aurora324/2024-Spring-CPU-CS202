.data 
	a: .word 0xFFFFFC00
.text
	# switch: 	FFFF_FC50	
	# LED:  		FFFF_FC60	
	# segment: 	FFFF_FC70	
	# VGA: 		FFFF_FC80	
	# botton		FFFF_FC90	
	
	
# t: a, b, test number
# 一直读入，并检查确定键的状态，直到确定键执行完成，再终止读入过程
# t0: a  
# t1: b
	addi s11, s11, 0xFF
	slli s11, s11, 8
	addi s11, s11, 0xFF
	slli s11, s11, 8
	addi s11, s11, 0xFC
	slli s11, s11, 8
choose1:
	li s10, 0x555
	sw s10, 0x70(s11)
	
	lw s10, 0x90(s11)
	beq s10, zero, choose1 
endchoose1:
	li s10, 0x666
	sw s10, 0x70(s11)
	
	lw s10, 0x90(s11)
	bne s10, zero, endchoose1
	
	
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
	
case0:

loada0:
	li s10, 0x777
	sw s10, 0x70(s11)
	
	lb t0, 0x51(s11)
	sb t0, 0x61(s11)
	
	lb s9, 0x90(s11)
	beq s9, zero, loada0
endloada0:
	li s10, 0x888
	sw s10, 0x70(s11)
	
	lw s10, 0x90(s11)
	bne s10, zero, endloada0

choose2:
	li s10, 0x555
	sw s10, 0x70(s11)
	
	lw s10, 0x90(s11)
	beq s10, zero, choose2
endchoose2:
	li s10, 0x666
	sw s10, 0x70(s11)
	
	lw s10, 0x90(s11)
	bne s10, zero, endchoose2

loadb0:
	li s10, 0x777
	sw s10, 0x70(s11)
	
	lb t1, 0x51(s11)
	sb t1, 0x61(s11)
	
	lb s9, 0x90(s11)
	beq s9, zero, loadb0
endloadb0:
	li s10, 0x888
	sw s10, 0x70(s11)
	
	lw s10, 0x90(s11)
	bne s10, zero, endloadb0
	

	j choose
case1:
	loada1:
		# 左键读入a 
		lb t0, 0x51(s11)
		
		# 显示结果
		sw t0, 0x70(s11)
		
		li s10, 2
		bne s0, s10, loada1
	
	j choose
case2:
	loadb2:
		# 左键读入b
		lbu t1, 1(s11)
		
		# 显示结果
		sb t1, 17(s11)
		
		#jal button
		# s0 is the result of button
		li s10, 2
		bne s0, s10, loadb2
	
	sb zero, 0x61(s11)# 0x61
	sb zero, 0x60(s11)# 0x60
	sw t1, 32(s11)# 0x70
	sw t1, 48(s11)# 0x80
	
	j choose
case3:	
	beq t0, t1, case3i
	
	j case3end
	case3i:
		li s10, -1
		sw s10, 16(s11) # 0x60
		sw zero, 32(s11)# 0x70
		sw zero, 48(s11)
		j choose
	case3end:
		sw zero, 16(s11)# 0x60
		sw zero, 32(s11)# 0x70
		sw zero, 48(s11)# 
		j choose
case4:
	blt t0, t1, case4i
	j case4end
	case4i:
		li s10, -1
		sw s10, 16(s11)# 0x60
		sw zero, 32(s11)# 0x70
		sw zero, 48(s11)# 
		j choose
	case4end:
		sw zero, 16(s11)# 0x60
		sw zero, 32(s11)# 0x70
		sw zero, 48(s11)# 
		j choose
case5:
	bge t0, t1, case5i
	
	j case5end
	case5i:
		li s10, -1
		sw s10, 16(s11)  # 0x60
		sw zero, 32(s11)# 0x70
		sw zero, 48(s11)# 0x80
		j choose
	case5end:
		sw zero, 16(s11)# 0x60 
		sw zero, 32(s11)# 0x70 
		sw zero, 48(s11)#  
		j choose
case6:
	bltu t0, t1, case6i
	j case6end
	case6i:
		li s10, -1
		sw s10, 16(s11)  # 0x60
		sw zero, 32(s11)# 0x70
		sw zero, 48(s11)# 
		j choose
	case6end:
		sw zero, 16(s1)# 0x60 
		sw zero, 32(s1)# 0x70 
		sw zero, 48(s1)# 
		j choose
case7:
	bgeu t0, t1, case7i
	j case7end
	case7i:
		li s10, -1
		sw s10, 16(s11)  # 0x60
		sw zero, 32(s11)# 0x70
		sw zero, 48(s11)# 
		j choose
	case7end:
		sw zero, 16(s11)# 0x60 
		sw zero, 32(s11)# 0x70 
		sw zero, 48(s11)# 
		j choose



# functions botton, s0 is the return value
#button:
#li s0, 0
# if botton = 0, 结束button; 其他情况再读入上升，不上升不返回
#down:
#	lw s1, 0x90(s11)
#	beq s1, zero, endbutton
#	addi s0, s0, 1
	

#up:
#	lb s1, 0x90(s11)
	
	# test
#	li s10, 0x171
#	slli s10, s10, 16
#	sw s10, 0x70(s11)
	
#	li s10, 1
#	beq s1, s10, up
	
#	addi s0, s0, 1
	
	
#endbutton:
#	jalr ra
