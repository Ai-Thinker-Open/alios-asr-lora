[![中文](https://img.shields.io/badge/中文-README-blue)](README.zh.md)

# AliOS ASR LoRa SDK

This repository is a historical AliOS Things fork for LoRa/LoRaWAN development. It contains Cypress PSoC Creator projects for the ASR6501/ASR6502 family, the AliOS kernel and platform layers, the LoRaWAN MAC/region stack, and an EML3047 (STM32L071 + SX1276) GNU Arm build target.

> Maintenance note: the code base and toolchain conventions date from the AliOS 1.3 era. `VERSION` identifies `v4.2_rel`, while the repository also contains later release-style tags. Select a tag or commit explicitly for production work; do not assume the default branch is the newest vendor release.

## Start here

| Goal | Entry point |
| --- | --- |
| ASR6501 LoRaWAN application | `projects/Creator/ASR6501/lorawan.cydsn/lorawan.cyprj` |
| ASR6501 ping-pong example | `projects/Creator/ASR6501/pingpong.cydsn/pingpong.cyprj` |
| ASR6501/ASR6502 minimal AliOS projects | `projects/Creator/ASR6501/alios_small.cydsn` and `projects/Creator/ASR6502/alios_small.cydsn` |
| AliOS LoRaWAN example | `example/lorawan/lorawanapp/lorawanapp.c` |
| LoRaWAN stack | `kernel/protocols/lorawan` |
| EML3047 board port | `board/eml3047` |

Read [Code entry](doc/CODE_ENTRY.md), [Architecture](doc/ARCHITECTURE.md), and [Validation](doc/VALIDATION.md) before changing the stack or board ports.

## Reproduce the validated build

The EML3047 target was built in WSL2 Ubuntu 22.04 with GNU Arm Embedded GCC 10.3.1, Python 2.7, Perl, and the repository's bundled GNU Make 4.1:

```sh
./tools/build_eml3047.sh
```

The script performs a clean build of `lorawan.lorawanapp@eml3047`. Output files are written to:

```text
out/lorawan.lorawanapp@eml3047/binary/
```

The historical `aos make <target>` workflow may also work with a matching AliOS environment. The helper script intentionally calls the bundled Makefile directly so that the reviewed command is reproducible without installing the legacy `aos` CLI.

## Hardware-specific builds

The ASR6501 and ASR6502 projects require the appropriate Cypress PSoC Creator environment, the vendor device support, and matching hardware. Open the `.cyprj` file for the required project and verify its selected device, linker input, radio region, board pinout, and programming settings before building.

## Scope of validation

The EML3047 firmware compiles and links into ELF, BIN, and HEX artifacts. The ASR PSoC Creator projects were inspected for entry points and source references but were not compiled because PSoC Creator is unavailable in the validation environment. Flashing, RF behavior, LoRaWAN join/uplink/downlink, low-power timing, and hardware peripherals still require target-board testing. See [Validation](doc/VALIDATION.md) for the exact boundary.

## License

The repository is distributed under the root [Apache License 2.0](LICENSE). Some imported vendor and protocol-stack files retain their own copyright and license notices; those notices must be preserved when redistributing or modifying the files.
