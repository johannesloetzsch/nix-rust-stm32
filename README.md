# Blink a LED on a Blue pill (build on NixOS).

## Programm via UART1 (using external USB-UART)

### Pins
> UART1 TxD: `PA9`  
> UART1 RxD: `PA10`

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

## Test
It turns out some Blue pill boards have gpioc.pc13 not connected to the onboard LED.
In that case you might want connect an external LED…


## Enjoy the [Asm](https://developer.arm.com/documentation/dui0489/i/arm-and-thumb-instructions/arm-and-thumb-instruction-summary?lang=en)
```sh
cargo rustc -- --emit asm
grep -m1 main_loop: -A43 target/thumbv7m-none-eabi/debug/deps/blinky_rust-*.s | bat --file-name example.s
cargo objdump -- -S target/thumbv7m-none-eabi/debug/deps/blinky_rust-1246b2f482d8d8c6 | grep -m1 '<main_loop>' -A 26
```

## Based on work of

Original: https://gitlab.com/jounathaen-projects/embedded-rust/blinky-rust

Blog article: https://jonathanklimt.de/electronics/programming/embedded-rust/rust-on-stm32-2/

Flake: https://gitea.c3d2.de/toon/blackknobs/src/branch/main/flake.nix
