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
ENTRY(boot_reset_handler)
_estack = 0x20030000; /* top of SRAM */

SECTIONS
{
	/* put INTERRUPT_VECTOR and then rest of the code */
	.isr_vector :
	{
		. = ALIGN(4);
		KEEP(startup.o (VECTORS))
		. = ALIGN(4);
	} >flash

	.text :
	{
		. = ALIGN(4);
		* (.text)
		* (.text*)	/* boot_reset_handler goes here */
		. = ALIGN(4);
		_etext = .;
	} >flash

	.rodata :
	{
		. = ALIGN(4);
		* (.rodata)
		* (.rodata*)
		. = ALIGN(4);
	} >flash

	/* startup uses this to init the data */
	_sidata = LOADADDR(.data)

	/*
	 * AT specifies LMA different than VMA (equal by default). Data has to
	 * be copied from FLASH to RAM.
	 */
	.data :
	{
		. = ALIGN(4);
		_sdata = .;
		* (.data)
		* (.data*)
		. = ALIGN(4);
		_edata = .;
	} >ram AT >flash
	/* _data_loadaddr = LOADADDR(.data); */

 /* CCM-RAM section
  *
  * IMPORTANT NOTE!
  * If initialized variables will be placed in this section,
  * the startup code needs to be modified to copy the init-values.
  */
  /* .ccmram : */
  /* { */
  /*   . = ALIGN(4); */
  /*   _sccmram = .;       /1* create a global symbol at ccmram start *1/ */
  /*   *(.ccmram) */
  /*   *(.ccmram*) */

  /*   . = ALIGN(4); */
  /*   _eccmram = .;       /1* create a global symbol at ccmram end *1/ */
  /* } >CCMRAM AT> FLASH */

	.bss :
	{
		. = ALIGN(4);
		_sbss = .;
		*(.bss)
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

