	.syntax unified
/*
 * C startup procedure:
 * 1) vectors
 * 2) code to copy data from Flash to RAM
 * 3) zero-out the .bss
 * 4) setup stack pointer
 * 5) b main
 */

/*
 * 1) vectors
 * description: DUI05531_cortex_m4_dgug.pdf, p.37
 */
.section VECTORS, "x"
.align 2
/* exporting the name to the linker */
.global ResetHandler
	.long	_estack /* top of kernel stack */
	.long	ResetHandler /* Reset */
	.long	0 /* NMI */
	.long	0 /* Hard fault */
	.long	0 /* Memory management fault */
	.long	0 /* Bus fault */
	.long	0 /* Usage fault */
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0 /* SVCall */
	.long	0
	.long	0
	.long	0 /* PendSV */
	.long	0 /* Systick */
	.long	0 /* IRQ0 */
	.long	0 /* IRQ1 */
	.long	0 /* IRQ2 */
	.equ	VECTORS_SZ, (. - VECTORS)

/*
 * 2) code to copy data from Flash to RAM
 */
	.text
	.align 2
ResetHandler:
	//ldr	sp, =stack_top
	/* branch and save the return address in link register */
	mov	r5, #0x45
	mov	r6, #0x45
	mov	r7, #0x45
	mov	r8, #0x45
	mov	r9, #0x45
	mov	r10, #0x45
	mov	r11, #0x45
	mov	r12, #0x45

	ldr	r0, =_stext
	ldr	r1, =_sdata
	ldr	r2, =_data_sz

	/* in case there is no data */
	ldr	r4, =_data_sz
	cmp	r4, #0x0
	beq	_init_bss
_copy:
	ldrb	r3, [r0], #1
	strb	r3, [r1], #1
	subs	r2, r2, #1
	bne	_copy

/*
 * 3) zero-out the .bss
 */
_init_bss:
	ldr	r0, =_sbss
	ldr	r1, =_ebss

	ldr	r4, =_bss_sz
	cmp	r4, #0x0
	beq	_init_sp

	mov	r2, #0x0
_zeroize:
	strb	r2, [r0], #1
	subs	r1, r1, #1
	bne	_zeroize

/*
 * 4) setup stack pointer
 */
_init_sp:
	mov	r1, #1
	mov	r2, #2
	add	r3, r1, r2

_stop:	b	_stop
