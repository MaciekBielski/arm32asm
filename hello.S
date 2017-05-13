	.data
str:	.asciz "Hello ASM world! \n"

	.text
	.globl main
	/*
	   Beginning of main()
	 */
main:	stmfd	sp!,{lr}
	ldr	r0, =str
	bl	printf
	mov	r0, #0
	ldmfd	sp!,{lr}
	mov	pc, lr

