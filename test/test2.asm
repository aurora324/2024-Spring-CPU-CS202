.data
	a: .word 0xFFFFFC00
.text
#IO基地址0xFFFFFC
addi s11, s11, 0xFF
slli s11, s11, 8
addi s11, s11, 0xFF
slli s11, s11, 8
addi s11, s11, 0xFC
slli s11, s11, 8
li s11, 0xFFFFFc00

addi a5, x0, 0x4 #confrm--100--for scene choose
addi a6, x0, 0x2 #up--010
addi a7, x0, 0x1 #down--001
add t6, zero, zero #t6用于存储ab

choose:
	lw t2, 0x50(s11)#拨码开关后三位 选择case
	sw t2, 0x60(s11)
	
	slli t2, t2, 29
	srli t2, t2, 29
	
	lw a1, 0x90(s11)#读按钮数据
	bne a1, a5, choose#没按按钮重复循环
	
	#确定模式选择
	add s10, s10, zero
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

	j choose

case0:
loop01: 
	# 等上显示数字
	lw t0, 0x50(s11)
	sw t0, 0x60(s11)
	
    	lw s0, 0x90(s11) #s0 button
    	bne s0, a6, loop01

	
	mv  s10, t0
	# 循环计算
loop02:
	srli s10, s10, 1
	addi s9, s9,1
	bne s10, zero, loop02
	
	# 得出结果
	addi s10, s10, 8
	sub s1, s10, s9

	
loop03: 
	sw s1, 0x70(s11)
	sw s1, 0x80(s11)
	lw s0, 0x90(s11)  
	bne s0, a7, loop03 #a7
	j choose


case1:
# in
loop11: 
	lw t0, 0x50(s11)
	sw t0, 0x60(s11)
    	lw s0, 0x90(s11)
    	bne s0, a6, loop11
    	

    	add s0, t0, zero
	
	# original sign
	srli s1, s0, 15
	
	# original exponent
	slli s2, s0, 17
	srli s2, s2, 27
	addi s2, s2, -15
	
	# original fraction
	slli s3, s0, 22
	srli s3, s3, 22
	addi s3, s3, 1000
	addi s3, s3, 24
	
	# s4 is number of shift, +:shift left   -:shift right
	li s10, -10
	add s4, s10, s2

	# s4 is the shift 
	
	# shiftleft
	bge s4, zero, shiftleft1
	
	# shiftleft
	# s6 is the fraction s5 is the shift s7 is the result
	sub s4, zero, s4
	srl s7, s3, s4
	li s10, 32
	sub s5, s10, s4
	sll s6, s3, s5
	srl s6, s6, s5
	bne s6, zero, case1add
	j case1end
	
	case1add:
		addi s7, s7, 1
		j case1end
	
shiftleft1:
	add s6, zero, zero
	sll s7, s3, s4 
	j case1end
		
	case1end:
		bne s1, zero, minus1
loop12:
	sw s7, 0x70(s11)
	sw s7, 0x60(s11)
	lw s0, 0x90(s11)  
	bne s0 , a7, loop12 #a7
	minus1:
		sub s7, zero, s7
		blt zero, s6, case1add1
		j case1end1
	case1add1:
		addi s7, s7, 1
	case1end1:
		
loop13:
	sw s7, 0x70(s11)
	sw s7, 0x60(s11)
	lw s0, 0x90(s11)  
	bne s0 , a7, loop13 #a7
	j choose
	
case2:
loop21: 
	lw t0, 0x50(s11)
	sw t0, 0x60(s11)
    	lw s0, 0x90(s11)
    	bne s0, a6, loop21
    	
	add s0, t0, zero
	
	# s1: original sign
	srli s1, s0, 15
	
	# s2: original exponent
	slli s2, s0, 17
	srli s2, s2, 27
	addi s2, s2, -15
	
	# s3: original fraction
	slli s3, s0, 22
	srli s3, s3, 22
	addi s3, s3, 1000
	addi s3, s3, 24
	
	# s4 is number of shift, +:shift left   -:shift right
	li s10, -10
	add s4, s10, s2

	# s4 is the shift 
	
	# shiftleft
	bge s4, zero, shiftleft2
	
	# shiftleft
	# s6 is the fraction s5 is the shift
	# s7: 整数部分
	sub s4, zero, s4
	srl s7, s3, s4
	
	# s6小数部分
	li s10, 32
	sub s5, s10, s4
	sll s6, s3, s5
	srl s6, s6, s5
	j case2end
	
shiftleft2:
	li s6, 0
	sll s7, s3, s4 
	j case2end
		
	case2end:
		bne s1, zero, minus2
loop22:
	sw s7, 0x80(s11)
	sw s7, 0x70(s11)
	sw s7, 0x60(s11)
	lw s0, 0x90(s11)  
	bne s0 , a7, loop22 #a7
	j choose
	
	minus2:
		sub s7, zero, s7
		blt zero, s6, case2add2
		j case2end2
	case2add2:
		addi s7, s7, -1
	case2end2:
		
loop23:
	sw s7, 0x80(s11)
	sw s7, 0x70(s11)
	sw s7, 0x60(s11)
	lw s0, 0x90(s11)  
	bne s0 , a7, loop23 #a7
	j choose
	

case3: 
loop31: 
	lw t0, 0x50(s11)
	sw t0, 0x60(s11)
    	lw s0, 0x90(s11)
    	bne s0, a6, loop31

	mv s0, t0
	# s1: original sign
	srli s1, s0, 15
	
	# s2: original exponent
	slli s2, s0, 17
	srli s2, s2, 27
	addi s2, s2, -15
	
	# s3: original fraction
	slli s3, s0, 22
	srli s3, s3, 22
	addi s3, s3, 1000
	addi s3, s3, 24
	
	# s4 is number of shift, +:shift left   -:shift right
	li s10, -10
	add s4, s10, s2

	# s4 is the shift 
	
	# shiftleft
	bge s4, zero, shiftleft3
	
	# shiftleft
	# s6 is the fraction s5 is the shift
	# s7: 整数部分
	sub s4, zero, s4
	srl s7, s3, s4
	
	# s6小数部分
	li s10, 32
	sub s5, s10, s4
	sll s6, s3, s5
	srl s6, s6, s5
	# s8 sishewuru
	
	li s10, 2
	bgt s4, s10, compress
	j continue
compress:
	addi s10, s4, -2
	srl s8, s6, s10
continue:
	beq s8, zero, case30
	li s10, 1
	beq s8, s10, case31
	li s10, 2
	beq s8, s10, case32
	li s10, 3
	beq s8, s10, case33
	j case3end
	
case30:
	j case3end
	
case31:
	j case3end
case32:
	srli s7, s7, 1
	slli s7, s7, 1
	addi s7, s7, 1
	j case3end
case33:
	addi s7, s7, 1
	
shiftleft3:
	li s6, 0
	li s8, 0
	sll s7, s3, s4 
	j case3end
		
	case3end:
		bne s1, zero, minus3
loop32:
	sw s7, 0x70(s11)
	sw s7, 0x80(s11)
	sw s7, 0x60(s11)
	lw s0, 0x90(s11)  
	bne s0 , a7, loop32 #a7
	j choose
	minus3:
		sub s7, zero, s7

loop33:
	sw s7, 0x70(s11)
	sw s7, 0x80(s11)
	sw s7, 0x60(s11)
	lw s0, 0x90(s11)  
	bne s0 , a7, loop33 #a7
	j choose


case4:
loop41: 
	lw t0, 0x50(s11)
	sw t0, 0x60(s11)
    	lw s0, 0x90(s11)
    	bne s0, a6, loop41

	slli s0, t0, 16
	srli s0, s0, 24

	slli s1, t0, 24
	srli s1, s1, 24
	
	add s2, s0, s1
	srli s3, s2, 8
	li s10, 1
	beq s3, s10, operation
loop45:
	sw s2, 0x70(s11)
	sw s2, 0x80(s11)
	sw s2, 0x60(s11)
	lw s0, 0x90(s11)  
	bne s0 , a7, loop45 #a7
	j choose
	
	operation:
		addi s2, s2, 1
		addi s10, zero, -1
		xor s2, s10, s2
		slli s2, s2, 24
		srli s2, s2, 24
loop46:
	sw s2, 0x70(s11)
	sw s2, 0x80(s11)
	sw s2, 0x60(s11)
	lw s0, 0x90(s11)  
	bne s0 , a7, loop46 #a7
	j choose
	
	
case5:
loop51: 
	lw t0, 0x50(s11)
	sw t0, 0x60(s11)
    	lw s0, 0x90(s11)
    	bne s0, a6, loop51
    	
    	
	andi s10, t0, 0xf #取后4bit
	add s9, s10, zero# 加
	slli s9, s9, 4
	
	srli t0, t0, 4
	andi s10, t0, 0xf #取后4bit
	add s9, s10, s9# 加
	slli s9, s9, 4
	
	srli t0, t0, 4
	andi s10, t0, 0xf #取后4bit
	add s9, s10, s9# 加

loop52:
	sw s9, 0x70(s11)
	sw s9, 0x80(s11)
	lw s0, 0x90(s11)  
	bne s0 , a7, loop52 #a7
	j choose


case6:
loop61: 
	lw t0, 0x50(s11)
	sw t0, 0x60(s11)
    	lw s0, 0x90(s11)
    	bne s0, a6, loop61

		li s0, 1# i
		# t0, max
		li s1, 0
	loop62:
		mv a0, s0
		jal fi
		add s1, s1, a4
		bge a0, t0, break6
		addi s0, s0, 1
		j loop62
	
	# a5-1      a4
	break6:
		addi s0, s0, -1
		add s2, s0, zero
		slli s2, s2, 16
		add s2, s2, s1

loop63:
	sw s2, 0x70(s11)
	sw s2, 0x80(s11)
	lw s0, 0x90(s11)  
	bne s0, a7, loop63 #a7
	j choose


case7:
loop71: 
	lw t0, 0x50(s11)
	sw t0, 0x60(s11)
    	lw s0, 0x90(s11)
    	bne s0, a6, loop71

		li s0, 1# i
		# t0, max
		li s1, 0
	loop72:
		mv a0, s0
		jal fi
		add s1, s1, a4
		bge a0, t0, break7
		addi s0, s0, 1
		j loop72
	
	# a5-1      a4
	break7:
		addi s0, s0, -1
		add s2, s0, zero
		slli s2, s2, 16
		add s2, s2, s1

loop73:
	lw s0, 0x90(s11)  
	bne s0, a7, loop73 #a7
	j choose





fi:
	ble 	a0, zero, endfi0
        	
        li 	a3, 1
       	beq 	a0, a3, endfi1
       	
       	li 	a3, 2
       	beq 	a0, a3, endfi2
        
        addi    	sp, sp, -12
       	# 记录进栈
       	addi 	a4, a4, 1
       	sw      	ra, 8(sp)
       	sw      a1, 4(sp)
       	sw      	a2, 0(sp)
       	mv      	a1, a0
       	addi    	a0, a0, -1
	jal 	fi	
        mv      	a2, a0
        addi    	a0, a1, -2
	jal 	fi
        add     	a0, a2, a0
        lw      	ra, 8(sp)
        lw      	a1, 4(sp)
        lw      	a2, 0(sp)
        addi    	sp, sp, 12
         # 记录出栈
        addi 	a4, a4, 1
        jalr 	ra
endfi0:
	li 	a0, 0
	jalr 	ra
endfi1:
	li 	a0, 1
	jalr 	ra
endfi2:
	li 	a0, 2
	jalr 	ra
	

fib:
	addi 	a4, a4, 1
	ble 	a0, zero, endfib0	
        li 	a3, 1
        beq 	a0, a3, endfib1
        li 	a3, 2
        beq 	a0, a3, endfib2
        addi    	sp, sp, -12
        
fib1:
	lw s0, 0x90(s11)  
	bne s0, a6, fib1 #a7
	j choose
        
        sw      	ra, 8(sp)
        	
fib2:
	lw s0, 0x90(s11)  
	bne s0, a7, fib2 #a7
	j choose
        	
fib3:
	lw s0, 0x90(s11)  
	bne s0, a6, fib3 #a7
	j choose
	
        	
        sw      a1, 4(sp)
        
fib4:
	lw s0, 0x90(s11)  
	bne s0, a7, fib4 #a7
	j choose
        	
       
        	
fib5:
	lw s0, 0x90(s11)  
	bne s0, a6, fib5 #a7
	j choose
	
        sw      	a2, 0(sp)
        	
       	
        	
fib6:
	lw s0, 0x90(s11)  
	bne s0, a7, fib6 #a7
	j choose
	
       	mv      	a1, a0
       	addi    	a0, a0, -1
	jal 	fib
        mv      	a2, a0
        addi    	a0, a1, -2
	jal 	fib
        add     	a0, a2, a0
        lw      	ra, 8(sp)
        lw      	a1, 4(sp)
        lw      	a2, 0(sp)
        addi    	sp, sp, 12
        jalr 	ra
endfib0:
	li 	a0, 0
	jalr 	ra
endfib1:
	li 	a0, 1
	jalr 	ra
endfib2:
	li 	a0, 2
	jalr 	ra






