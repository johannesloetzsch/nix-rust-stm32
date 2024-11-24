# Blink a LED on a Blue pill (build on NixOS).

STM32 can be programmed in multiple ways. This repo contains multiple demos:

|          | B0  | B1  | pins         | adapter           | preparation        | tool       | demo       |
| -------- | --- | --- | ------------ | ----------------- | ------------------ | ---------- | ---------- |
| **UART** | 1   | 0   | RX, TX       | USB-UART          | none               | stm32flash | make flash |
| **DFU**  | 0   | 0*  | USB d+,d-    | none              | install bootloader | dfu-util   | make dfu   |
| **OCD**  | (0) | (1) | SWDIO, SWCLK | Black Magic Probe | none               | gdb        | make gdb   |


## Programm via UART1 (using external USB-UART)

### Pins
[pinout for bluepills@c3d2](./pinout.md)

> UART1 RxD: `PA9` (TxD)  
> UART1 TxD: `PA10` (RxD)

### Boot pins (Jumper)
To enter `System memory` boot mode, reset (push button) with:
> `BO = 1`  
> `B1 = 0`

### stm32flash
```sh
nix develop
make flash
```

> It turns out some Blue pill boards have gpioc.pc13 not connected to the onboard LED.
> In that case you might want connect an external LED…


## gdb (ocd)

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


## dfu

### [sboot\_stm32](https://github.com/dmitrystu/sboot_stm32)

#### build and install bootloader
```sh
git git@github.com:dmitrystu/sboot_stm32.git; cd sboot_stm32
make prerequisites
make DFU_BOOTSTRAP_GPIO=GPIOB DFU_BOOTSTRAP_PIN=2 DFU_CIPHER=_DISABLE DFU_DETACH=_ENABLE stm32f103x8
stm32flash -S 0x8000000 -v -w build/firmware.bin /dev/ttyUSB0
```

#### use dfu
in memory.x use address from `grep __app_start build/firmware.map`:
> FLASH : ORIGIN = 0x08001000, LENGTH = 60K

> `BO = 0`  
> `B1 = 0`

reset to bootloader with:
```sh
lsusb | grep DFU
make dfu
```

reset to boot app with:
> `BO = 0`  
> `B1 = 1`


## Based on work of

Original: https://gitlab.com/jounathaen-projects/embedded-rust/blinky-rust

Blog article: https://jonathanklimt.de/electronics/programming/embedded-rust/rust-on-stm32-2/

Flake: https://gitea.c3d2.de/toon/blackknobs/src/branch/main/flake.nix
