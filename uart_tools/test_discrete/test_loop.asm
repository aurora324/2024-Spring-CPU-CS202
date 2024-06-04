.data 
	a: .word 0xFFFFFC00
.text
	la t2, a
	lw t2, 0(t2)
	addi t2, t2, 0x70
	
	li t1, -1
	loop:
		slli t3, t3, 1
		addi t3, t3, 1
		bne  t3, t1, loop
	sw t3, 0(t2)
	
	## 结果是数码管全是F
		
		