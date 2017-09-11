/* If data is to be placed in RAM during execution, the load address should
 * correspond to Flash and the run-time address should correspond to RAM
 * LMA - Load Memory Address - address in Flash memory
 * VMA - Virtual Memory Address - address in RAM
 *
 * LMA different from VMA can be specified using the AT keyword:
 * 	VMA AT(LMA)
 */
/*
https://github.com/libopencm3/libopencm3/blob/master/lib/stm32/f4/libopencm3_stm32f4.ld<Paste>
https://github.com/gonium/stm32f4-discovery-skeleton/blob/master/stm32f4-discovery.ld
*/

MEMORY
{
	flash (rx)	: ORIGIN = 0x8000000, LENGTH = 2M
	ram (rwx)	: ORIGIN = 0x20000000, LENGTH = 192K
}

/* Enforce emmition of the vector table. */
EXTERN (VECTORS)

/* Define the entry point of the output file. */
ENTRY(default_reset_handler)
_estack = 0x20004000; /* end of 64K CCM RAM */

SECTIONS
{
	/* put INTERRUPT_VECTOR and then rest of the code */
	. = ALIGN(4);
	_stext = .;	/* used to place data in flash */
	.text :
	{
	    KEEP(startup.o (VECTORS))
	    * (.text*)
	    . = ALIGN(4);
	    * (.rodata*)
	    . = ALIGN(4);

		_etext = .;	/* used to place data in flash */
	} >flash

	/*
	 * AT specifies LMA different than VMA (equal by default). Data has to
	 * be copied from FLASH to RAM.
	 */
	.data :
	{
		_sdata = .;
		* (.data*)
		. = ALIGN(4);
		_edata = .;
	} >ram AT >flash
	_data_sz = _edata - _sdata;
	_data_loadaddr = LOADADDR(.data);

	.bss :
	{
		_sbss = .;
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);
		_ebss = .;
	} >ram
	_bss_sz = _ebss - _sbss;

	. = ALIGN(4);
	end = .;
}

PROVIDE(end = .);
_end = .;

