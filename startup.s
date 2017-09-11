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
	.weak	reset_handler
	.global	reset_handler
	.set 	reset_handler, default_reset_handler

	.weakref	NMI_handler,default_exception_handler
	.weakref	hard_fault_handler,default_exception_handler
	.weakref	mm_fault_handler,default_exception_handler
	.weakref	bus_fault_handler,default_exception_handler
	.weakref	usg_fault_handler,default_exception_handler
	.weakref	SVC_handler,default_exception_handler
	.weakref	dbg_mon_handler,default_exception_handler
	.weakref	pend_SV_handler,default_exception_handler
	.weakref	sys_tick_handler,default_exception_handler

	.section VECTORS, "x"
	.align 2
/* exporting the name to the linker */

	.long	_estack /* defined in linker-script */
	.long	reset_handler /* Reset */
	.long	NMI_handler /* NMI */
	.long	hard_fault_handler /* Hard fault */
	.long	mm_fault_handler /* Memory management fault */
	.long	bus_fault_handler /* Bus fault */
	.long	usg_fault_handler /* Usage fault */
 	.long	0
 	.long	0
 	.long	0
	.long	0
	.long	SVC_handler /* SVCall */
	.long	dbg_mon_handler /* Mon */
	.long	pend_SV_handler /* PendSV */
	.long	sys_tick_handler /* Systick */

/*	.long	0  IRQ0 */
/*	.long	0  IRQ1 */
/*	...		*/
 	.equ	VECTORS_SZ, (. - VECTORS)

/*
 * 2) code to copy data from Flash to RAM
 */
	.text
	.align 2

default_reset_handler:
	/* branch and save the return address in link register */
	ldr	r0, =_stext
	ldr	r1, =_sdata
	ldr	r2, =_data_sz

	/* in case there is no data */
	cmp	r2, #0
	beq	_init_bss
_copy:
	ldr	r3, [r0], #4
	str	r3, [r1], #4
	subs	r2, r2, #4
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
