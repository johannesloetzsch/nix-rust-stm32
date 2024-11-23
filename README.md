# Blink a LED on a Blue pill (build on NixOS).

## Programm via UART1 (using external USB-UART)

### Pins
[pinout for bluepills@c3d2](./pinout.md)

> UART1 RxD: `PA9` (TxD)  
> UART1 TxD: `PA10` (RxD)

### Boot pins (Jumper)
To enter `System memory` boot mode:
> `BO = 1`  
> `B1 = 0`

-> reset (push button)

### stm32flash
```sh
nix develop
make
```

> It turns out some Blue pill boards have gpioc.pc13 not connected to the onboard LED.
> In that case you might want connect an external LED…


## gdb

### Black Magic Probe
```sh
nix develop
make gdb
```

or manually:

```sh
nix develop
gdb
```

```gdb
(gdb) target extended-remote /dev/ttyACM0
Remote debugging using /dev/ttyACM0

(gdb) monitor swdp_scan
Target voltage: ABSENT!
Available Targets:
No. Att Driver
 1      STM32F1 medium density M3/M4

(gdb) attach 1
Attaching to Remote target
```

> [use gdb](https://black-magic.org/usage/gdb-commands.html)


#### Create Black Magic Probe
```sh
git clone git@github.com:mmoskal/blackmagic-bluepill.git
stm32flash -S 0x8000000 -v -w blackmagic-bluepill/dist/blackmagic_all.bin /dev/ttyUSB0
lsusb | grep 'Black Magic Debug Probe'
```
> This version has another [pinout](https://github.com/mmoskal/blackmagic-bluepill?tab=readme-ov-file#pinout)!  
> PB0	SWDIO  
> PA5	SWCLK

<!-- TODO instructions for building https://github.com/blackmagic-debug/blackmagic -->


## Based on work of

Original: https://gitlab.com/jounathaen-projects/embedded-rust/blinky-rust

Blog article: https://jonathanklimt.de/electronics/programming/embedded-rust/rust-on-stm32-2/

Flake: https://gitea.c3d2.de/toon/blackknobs/src/branch/main/flake.nix
