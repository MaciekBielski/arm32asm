/*
   This is an exercise of putting arguments on stack for a subroutine in a
   loop, the simpler variant would be to use 'stm' for that, showed below.
   When manipulating with chars the endianness does matter.

http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0552a/I1835.html

Rules:
- calling function has to remove the 4th and further arguments after called
  function returns
- return address is in 'lr'
- R4-R11 should be saved if used inside a function
- IP (R12) is volatile, can be use instead of putting one variable on the stack
- SP should be restored to inital value, no matter how the function returns!
- LR will be loaded to PC at the end of a routine
- if a function calls subfunction then it has to save LR on stack or in
  non-volatile registers (R4-R11)

  [     SAFE LR         ]
  [  PREPARE THE STACK  ]
  [    -------------    ]
  [    FUNCTION BODY    ]
  [    -------------    ]
  [     RESTORE LR      ]
  [   CLEAN THE STACK   ]

 */
	.syntax unified

	.data
ltrs:	.asciz	"AbCdEfG"
delim:	.align	2
ltrs2:	.asciz	"pQrStuV"
delim2:	.align	2
patt:	.asciz	"Letters: %c %c %c %c %c %c %c\n"

	.text
	.global main

main:	stmfd	sp!, {lr}
	ldr	r4, =ltrs
	ldrb	r1, [r4], #0x1	//loading first 3 arguments
	ldrb	r2, [r4], #0x1
	ldrb	r3, [r4], #0x1	// r4 -> d
	ldr	r5, =delim
	sub	r5, r5, #0x1	// r5 -> G
	/*
	 * Stack pushing loop.
	 * printf takes 4th and next arguments in the pattern string
	 * from the stack, reading the pattern from left to right
	 */
	mov	r7, #0			// count how many elemets pushed on stack
loop:	ldrb	r6, [r5, #-0x1]!	// only one byte of a word is valid
	strb	r6, [sp, #-0x4]!	// args are taken from stack as words
	add	r7, r7, #0x1
	cmp	r4, r5
	blt	loop
	/* Now arguments are pushed in the correct order */
	ldr	r0, =patt
	bl	printf
	mov	r0, #0
	add	sp, sp, r7, lsl #2	// restore the stack

	/* now lets do the same with stm */
	ldr	r4, =ltrs2
	ldrb	r1, [r4], #0x1
	ldrb	r2, [r4], #0x1
	ldrb	r3, [r4], #0x1	// r4 -> s
	/*
	 * Lowest register goes to lowest add = stack top, will be popped first
	 * and a function is substituting them to pattern left-to-right
	 */
	ldrb	r5, [r4], #0x1
	ldrb	r6, [r4], #0x1
	ldrb	r7, [r4], #0x1
	ldrb	r8, [r4], #0x1
	mov	r9, sp
	stmfd	sp!, {r5-r8}
	rsb	r9, sp, r9	// reverse since stack grows downwards

	ldr	r0, =patt
	bl	printf
	mov	r0, #0
	add	sp, sp, r9


	/*Return */
	ldmfd	sp!, {lr}
	mov	pc, lr
