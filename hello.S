	.data
src:	.asciz	"This is a string of 8 bytes!!!!\n"
	.align	2
idx:	.byte	4,7,9,16,19,21	//index of spaces in the string
	.equ	idx_sz, (.-idx)
dst:	.space	32,'X'
	.space	4, 0x0		//oterwise it also prints next string
patt_xor:
	.asciz	"0x3 eor 0x5 = %#x\n"
patt_xnor:
	.asciz	"0x3 orn 0x5 = %#x\n"	// not implemented function
patt_div:
	.asciz "Div %u / %u = %u\n"
patt_cpsr:
	.asciz "CPSR: %#x\n"

	.text
	.globl main
	/*
	   @ Beginning of main()
	 */
main:	stmfd	sp!, {lr}
	ldr	r1, =src
	ldr	r0, =dst
	mov	r6, #0			// This is our counter

	/* First test ldm, stm */
copy_loop:
	ldmia	r1!, {r2-r5}
	stmia	r0!, {r2-r5} 
	add	r6, r6, #1		// Increment counter
	cmp	r6, #2
	blt	copy_loop

	/* Replace all spaces with underscores */
	ldr	r1, =dst		// address of the string
	ldr	r6, =idx		// address of idx table
	mov	r7, #0			// idx position counter
	mov	r8, #'_'		// fixed value
get_id:
	ldrb	r0, [r6], #1		// get first element and post-inc
	strb	r8, [r1, r0]		// replace character

	add	r7, r7, #1		// increment idx counter
	cmp	r7, #idx_sz		// all idx elems iterated?
	blt	get_id

	/* Print result string */
	ldr	r0, =dst
	bl	printf
	mov	r0, #0

	/* bitwise XOR */
	mov	r6, #0b00000011
	eor	r1, r6, #0b00000101
	ldr	r0, =patt_xor
	bl	printf
	mov	r0, #0

	/* XNOR==NOT(r1) == XOR(r1,0xFF) */
	mov	r1, r6
	eor	r1, r6, #0b00000101
	eor	r1, r1, #0b1111
	ldr	r0, =patt_xnor
	bl	printf
	mov	r0, #0

	/* Division - not available */
	ldr	r1, =0xfef8		// 65272
	mov	r2, #0x8
	udiv	r3, r1, r2
	ldr	r0, =patt_div
	bl	printf
	mov	r0, #0

	/* Read the CPSR */
	mrs	r1, CPSR
	ldr	r0, =patt_cpsr
	bl	printf
	mov	r0, #0

	/* Return */
	ldmfd	sp!, {lr}
	mov	pc, lr

