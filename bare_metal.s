	.syntax unified

	.data
src:	.asciz	"Hello binary!!!\n"
	.equ	src_len, (.-src)
	.align	2
uart:	.word	0x09000000

	.text
.global	start

start:	stmfd	sp!, {lr}

	ldr	r1, =0x0ffffffd
	mov	r2, #5
	add	r3, r1, r2
	adc	r4, r1, r2
	sub	r5, r4, r1
	sbc	r6, r4, r6

out:
	ldmfd	sp!, {lr}
	mov	pc, lr

