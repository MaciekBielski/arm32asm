	.data
out_patt:
	.asciz	"%#lx plus %#lx gives %#lx\n"
test_patt:
	.asciz	"NZCV: %#x\n"
a_l:	.long	0xfad00000
a_h:	.long	0xc0ca0000
b_l:	.long	0x052fdead
b_h:	.long	0xbeef0000
	
	.text
	.global main

main:	stmfd	sp!, {lr}

	/*
	 * x1 = a_h|a_l
	 * x2 = b_h|b_l
	 * sum = x1 + x2
	 */
	ldr	r5, =a_l	//0xfad0
	ldr	r5, [r5]
	ldr	r6, =b_l	//0xdead
	ldr	r6, [r6]

	/* Check CPSR */
	mrs	r2, CPSR
	lsr	r1, r2, #0x1c
	ldr	r0, =test_patt
	bl	printf
	mov	r0, #0

	/* Reset CPSR */
	mrs	r2, CPSR
	and	r2, r2, #0x0fffffff
	msr	CPSR, r2

	/* TODO: Should carry */
	mov	r1, r5
	mov	r2, r6
	adds	r3, r5, r6
	mrs	r4, CPSR
	ldr	r0, =out_patt
	bl	printf
	mov	r0, #0

	/* Check CPSR */
	lsr	r1, r4, #0x1c
	ldr	r0, =test_patt
	bl	printf
	mov	r0, #0

	/* Return */
	ldmfd	sp!, {lr}
	mov	pc, lr
