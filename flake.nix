# Env to develop code for stm32fxxx devices
{
  description = "Stm32 rust nixos template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    naersk.url = "github:nix-community/naersk";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, rust-overlay, naersk }:
    let
      name = "stm32-rust-nixos-template";
    in
    utils.lib.eachDefaultSystem
      (system:
        let
          # Imports
          pkgs = import nixpkgs {
            inherit system;
            # Custom rust toolchain
            overlays = [ rust-overlay.overlays.default ];
          };
          openocd-f1 = pkgs.stdenv.mkDerivation {
            name = "openocd-f1-stlink";
            buildInputs = [
              pkgs.openocd
              pkgs.makeWrapper
            ];
            src = ./src;
            noBuild = true;
            installPhase =
              let
                openOcdFlags = [
                  # change this for a newer programmer
                  "-f" "${pkgs.openocd}/share/openocd/scripts/interface/stlink.cfg"
                  "-f" "${pkgs.openocd}/share/openocd/scripts/target/stm32f1x.cfg"
                  "-c" "init"
                ];
              in ''
                mkdir -p $out/bin

                makeWrapper ${pkgs.openocd}/bin/openocd $out/bin/openocd-stlink-blackpill \
                  --add-flags "${pkgs.lib.escapeShellArgs openOcdFlags}"
              '';
          };
          rustToolchain = (pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml);
          naersk' = pkgs.callPackage naersk {
            cargo = rustToolchain;
            rustc = rustToolchain;
          };
        in
        rec {
          devShells.default = with pkgs; mkShell {
            nativeBuildInputs = [
              rustToolchain
              cargo-binutils
              gdb
              openocd
              openocd-f1
              stm32flash
              probe-rs
            ];
          };

          packages.blackknobs = naersk'.buildPackage {
            src = ./.;
          };

          checks = packages;
        }
      );
}
