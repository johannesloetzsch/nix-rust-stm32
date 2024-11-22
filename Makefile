flash:
	#cargo objcopy --release -- -O binary target/app.bin
	cargo objcopy -- -O binary target/app.bin
	stm32flash -w target/app.bin -v -g 0x08000000 /dev/ttyUSB0

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
