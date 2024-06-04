.data 
	a: .word 0xFFFFFC00
.text
	la t2, a
	lw t2, 0(t2)
	addi t2, t2, 0x70
	
	la t3, a
	lw t3, 0(t3)
	addi t3, t3, 0x70
	
	sw t2, 0(t2)
	
	
