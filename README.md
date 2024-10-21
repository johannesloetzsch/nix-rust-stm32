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


## Based on work of

Original: https://gitlab.com/jounathaen-projects/embedded-rust/blinky-rust

Blog article: https://jonathanklimt.de/electronics/programming/embedded-rust/rust-on-stm32-2/

Flake: https://gitea.c3d2.de/toon/blackknobs/src/branch/main/flake.nix
