objcopy:
	#cargo objcopy --release -- -O binary target/app.bin
	cargo objcopy -- -O binary target/app.bin
	readelf target/thumbv7m-none-eabi/debug/blinky-rust --sections | egrep '\s080'
	readelf target/thumbv7m-none-eabi/debug/blinky-rust --file-header | grep 'Entry point address'


.DEFAULT_GOAL := flash
flash:	objcopy
	## behind dfu sboot_stm32 (requires 4k)
	stm32flash -w target/app.bin -v -S 0x08001000:61440 -g 0x08001000 /dev/ttyUSB0
	
	@## multiple apps with 16k offset — apps are allowed to span multiple segments
	@#stm32flash -w target/app.bin -v -S 0x08000000:65536 -g 0x08000000 /dev/ttyUSB0
	@#stm32flash -w target/app.bin -v -S 0x08010000:49152 -g 0x08010000 /dev/ttyUSB0
	@#stm32flash -w target/app.bin -v -S 0x08020000:32768 -g 0x08020000 /dev/ttyUSB0
	@#stm32flash -w target/app.bin -v -S 0x08030000:16384 -g 0x08030000 /dev/ttyUSB0
	
	@## multiple apps with 16k offset — apps are strictly limited to single segment
	@#stm32flash -w target/app.bin -v -S 0x08000000:16384 -g 0x08000000 /dev/ttyUSB0
	@#stm32flash -w target/app.bin -v -S 0x08010000:16384 -g 0x08010000 /dev/ttyUSB0
	@#stm32flash -w target/app.bin -v -S 0x08020000:16384 -g 0x08020000 /dev/ttyUSB0
	@#stm32flash -w target/app.bin -v -S 0x08030000:16384 -g 0x08030000 /dev/ttyUSB0


dfu:	objcopy
	## dfu-bootloader must be installed first (see README.md)
	## required offset for the bootloader must be defined at memory.x
	dfu-util -D target/app.bin

gdb:
	cargo build
	ls /dev/ttyACM*
	## example: blink 10 times
	gdb	-iex 'target extended-remote /dev/ttyACM0' -iex 'target extended-remote /dev/ttyACM1' \
		-iex 'monitor swdp_scan' -iex 'attach 1' \
		-iex 'file target/thumbv7m-none-eabi/debug/blinky-rust' \
	        -iex 'load' \
		-iex 'break blinky_rust::led_off' \
		-iex 'run' \
		-iex 'continue 10' \
