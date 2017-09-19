	.syntax unified
/*
 * startup code executed on boot reset
 */

/* this is placed in flash */
	.section .text.boot_reset_handler
	.weak boot_reset_handler
	.type boot_reset_handler, %function
boot_reset_handler:
	/* set stack pointer */
	ldr	sp, =_estack

	/* init data copying */
	ldr	r0, =_sdata
	ldr	r2, =_edata
	mov	r1, r0
	/* jump to final check */
	b _copy_check

_copy_loop:
	/* copy and increment r1 until reaches r2 */
	/* todo */
	/* ldr	r1, [r0], #4 */
	/* str	r3, [r1], #4 */
	/* subs	r2, r2, #4 */
	/* bne	_copy */

_copy_check:
	cmp	r2, r1
	bne	_copy_loop

/*
 * 3) zero-out the .bss
 */
_init_bss:
	ldr	r0, =_sbss
	ldr	r1, =_ebss

	ldr	r4, =_bss_sz
	cmp	r4, #0x0
	beq	_init_sp

	ldr	r2, =0x0
_zeroize:
	strb	r2, [r0], #1
	subs	r1, r1, #1
	bne	_zeroize

/*
 * 4) setup stack pointer
 */
_init_sp:
	ldr	sp, =_estack
	bl	start
_stop:	b	_stop

/*
 * description: DUI05531_cortex_m4_dgug.pdf, p.37
 */
	/* .weakref 	reset_handler, default_reset_handler */
	/* .weakref	NMI_handler,default_exception_handler */
	/* .weakref	hard_fault_handler,default_exception_handler */
	/* .weakref	mm_fault_handler,default_exception_handler */
	/* .weakref	bus_fault_handler,default_exception_handler */
	/* .weakref	usg_fault_handler,default_exception_handler */
	/* .weakref	SVC_handler,default_exception_handler */
	/* .weakref	dbg_mon_handler,default_exception_handler */
	/* .weakref	pend_SV_handler,default_exception_handler */
	/* .weakref	sys_tick_handler,default_exception_handler */

	/* .section VECTORS, "x" */
	/* .align 2 */
/* exporting the name to the linker */

	/* .long	_estack /1* defined in linker-script *1/ */
	/* .long	reset_handler /1* Reset *1/ */
	/* .long	NMI_handler /1* NMI *1/ */
	/* .long	hard_fault_handler /1* Hard fault *1/ */
	/* .long	mm_fault_handler /1* Memory management fault *1/ */
	/* .long	bus_fault_handler /1* Bus fault *1/ */
	/* .long	usg_fault_handler /1* Usage fault *1/ */
 	/* .long	0 */
 	/* .long	0 */
 	/* .long	0 */
	/* .long	0 */
	/* .long	SVC_handler /1* SVCall *1/ */
	/* .long	dbg_mon_handler /1* Mon *1/ */
	/* .long	pend_SV_handler /1* PendSV *1/ */
	/* .long	sys_tick_handler /1* Systick *1/ */

/*	.long	0  IRQ0 */
/*	.long	0  IRQ1 */
/*	...		*/
 	/* .equ	VECTORS_SZ, (. - VECTORS) */

