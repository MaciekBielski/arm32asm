	.data
out_patt:
	.asciz	"%#lx plus %#lx gives %#lx\n"
test_patt:
	.asciz	"NZCV: %#x\n"
a_l:	.long	0xfad00000
a_h:	.long	0xc0ca0000
b_l:	.long	0xdead0000
b_h:	.long	0xbeef0000
	
	.text
	.global main

main:	stmfd	sp!, {lr}
	/* Check CPSR */
	mrs	r4, CPSR
	mov	r5, #0xf
	and	r4, r4, r5, lsl #0x1b
	lsr	r1, r5, #0x1b
	ldr	r0, =test_patt
	bl	printf
	mov	r0, #0

	/*
	 * x1 = a_h|a_l
	 * x2 = b_h|b_l
	 * sum = x1 + x2
	 */
	ldr	r1, =a_l	//0xfad0
	ldr	r1, [r1]
	ldr	r2, =b_l	//0xdead
	ldr	r2, [r2]
	adds	r3, r1, r2
	ldr	r0, =out_patt
	bl	printf
	mov	r0, #0

/* TODO: Why carry bit is not affected?? */
	/* Check CPSR */
	mov	r5, #0xf
	and	r4, r4, r5, lsl #0x1b
	lsr	r1, r5, #0x1b
	ldr	r0, =test_patt
	bl	printf
	mov	r0, #0

	/* Return */
	ldmfd	sp!, {lr}
	mov	pc, lr
