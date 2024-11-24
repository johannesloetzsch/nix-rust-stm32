/* Linker script for the STM32F103C8T6 */
MEMORY
{
  /** behind dfu sboot_stm32 (requires 4k) **/
  FLASH : ORIGIN = 0x08001000, LENGTH = 60K

  /** multiple apps with 16k offset — apps are allowed to span multiple segments **/
  /* FLASH : ORIGIN = 0x08000000, LENGTH = 64K */
  /* FLASH : ORIGIN = 0x08010000, LENGTH = 48K */
  /* FLASH : ORIGIN = 0x08020000, LENGTH = 32K */
  /* FLASH : ORIGIN = 0x08030000, LENGTH = 16K */

  /** multiple apps with 16k offset — apps are strictly limited to single segment **/
  /* FLASH : ORIGIN = 0x08000000, LENGTH = 16K */
  /* FLASH : ORIGIN = 0x08010000, LENGTH = 16K */
  /* FLASH : ORIGIN = 0x08020000, LENGTH = 16K */
  /* FLASH : ORIGIN = 0x08030000, LENGTH = 16K */

  RAM : ORIGIN = 0x20000000, LENGTH = 20K
}
/* _stack_start = ORIGIN(RAM) + LENGTH(RAM); */
