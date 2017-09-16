	.syntax unified

	.text
	.global	start

start:	stmfd	sp!, {lr}

	/* Modify NZCVQ bits, zeroize C */
	mrs	r1, APSR
	bic	r1, r1, #0x20000000
	msr	APSR_nzcvq, r1

	mov	r2, #0xf
	mov	r3, #6
	subs	r5, r3, r2

	/* Modify NZCVQ bits, zeroize C */
	mrs	r1, APSR
	bic	r1, r1, #0x20000000
	msr	APSR_nzcvq, r1

	sbcs	r6, r3, r2

out:
	ldmfd	sp!, {lr}
	mov	pc, lr

