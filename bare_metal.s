.thumb
.syntax unified

	.data
src:	.asciz	"Hello binary!!!\n"
	.equ	src_len, (.-src)
	.align	2
uart:	.word	0x09000000

	.text
.globl	main

main:	stmfd	sp!, {lr}
	ldr	r1, =src
	ldr	r0, =uart
	mov	r2, #0x0
write_loop:
	ldrb	r0, [r1], #1
	add	r2, r2, #1
	cmp	r2, #src_len
	blt	write_loop
out:
	ldmfd	sp!, {lr}
	mov	pc, lr

