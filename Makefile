flash:
	cargo objcopy --release -- -O binary target/app.bin
	stm32flash -w target/app.bin -v -g 0x08000000 /dev/ttyUSB0
