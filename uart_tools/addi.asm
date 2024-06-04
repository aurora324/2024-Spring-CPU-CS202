.text
	li s10, 0x52
	addi s10, s10, 0x400
	addi s10, s10, 0x10
	
	addi s11, s11, 0xFF
	slli s11, s11, 8
	addi s11, s11, 0xFF
	slli s11, s11, 8
	addi s11, s11, 0xFC
	slli s11, s11, 8
		
	sw s10, 0x70(s11)