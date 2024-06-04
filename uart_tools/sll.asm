.data 
	a: .word 0xFFFFFC00
.text
	addi s11, s11, 0xFF
	slli s11 ,s11, 8
	addi s11, s11, 0xFF
	slli s11 ,s11, 8
	addi s11, s11, 0xFC
	slli s11 ,s11, 8

	li s10, 0x563
	slli s10, s10, 29
	srli s10, s10, 29
	sw s10, 0x70(s11)
	
