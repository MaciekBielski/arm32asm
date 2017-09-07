	.thumb
	.syntax unified

/* creates section containing executable code */
.section INTERRUPT_VECTOR, "x"
/* exporting the name to the linker */
.global _Reset
_Reset:
	B	ResetHandler /* Reset */
	B	. /* Undefined */
	B	. /* SWI */
	B	. /* Prefetch Abort */
	B	. /* Data Abort */
	B	. /* reserved */
	B	. /* IRQ */
	B	. /* FIQ */

ResetHandler:
	/* stack_top will be defined during linking */
	//ldr	sp, =stack_top
	/* branch and save the return address in link register */
	//bl	main
	mov	r0, #4
	mov	r1, #3
	add	r2, r1, r0
loop:
	b	loop

