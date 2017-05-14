	.data
src:	.asciz	"This is a string of 8 bytes!!!!\n"
idx:	.byte	4,7,9,16,19,21	//index of spaces in the string
	.equ	idx_sz, (.-idx)
dst:	.space	32,'X'

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
	ldmfd	sp!, {lr}
	mov	pc, lr

