[![中文](https://img.shields.io/badge/中文-文档-blue)](VALIDATION.zh.md)

# Validation record

Validation date: 2026-08-20

## Environment

- Windows 11 with WSL2 Ubuntu 22.04
- Repository-bundled GNU Make 4.1 (`build/cmd/linux64/make`)
- GNU Arm Embedded GCC 10.3.1
- Python 2.7.18 and Perl 5
- Target: `lorawan.lorawanapp@eml3047`

## Reproduction

```sh
./tools/build_eml3047.sh
```

The final source tree was clean-built twice. Both runs completed compilation, static-library creation, final link, binary conversion, and memory-map generation. The build log reported no `warning:` or `error:` diagnostics. Note that this historical target includes `-w`, so a zero diagnostic count does not prove that every compiler warning category is clean.

Expected output directory:

```text
out/lorawan.lorawanapp@eml3047/binary/
```

The reviewed build produced a 75,812-byte BIN and reported 74,879 bytes ROM / 8,168 bytes RAM in the AliOS memory summary. Artifact hashes should be regenerated for each reviewed commit because debug paths and toolchain versions can affect ELF-derived outputs.

## Problems reproduced and repaired

- The LoRaWAN component referenced a missing `lora/system/timeServer.c`; the matching implementation was recovered from this repository's `develop` branch and completed with the system-time API declared by the current header.
- The LoRaWAN component omitted its confirmation queue, Class B implementation, and EML3047 radio adapter from the source list.
- The EML3047 public board header required HAL/CMSIS includes and device macros that were scoped only to board-local compilation.
- The MAC and EML3047 radio abstraction used inconsistent public-network and wake-up function names.
- Linux config-file generation doubled backslashes in quoted C macros; GNU Make's built-in file writer is now used for the bundled Make 4.1 path.

## Static evidence

- ASR6501 LoRaWAN entry: `projects/Creator/ASR6501/lorawan.cydsn/main.c` and `classA.c`.
- ASR6501 ping-pong entry: `projects/Creator/ASR6501/pingpong.cydsn/main.c`.
- Creator build manifests: the `.cyprj` files under `projects/Creator`.
- AliOS application entry: `example/lorawan/lorawanapp/lorawanapp.c`.
- Shared stack manifest: `kernel/protocols/lorawan/lorawan.mk`.

## Not validated

- PSoC Creator compilation for ASR6501/ASR6502
- Compatibility with a specific Cypress/PSoC Creator or vendor-device-support version
- Programming or booting any target board
- LoRa RF transmission, regional compliance, antenna matching, or range
- OTAA/ABP join, uplink, downlink, confirmed messages, or Class B beacon timing on hardware
- Low-power current and long-duration timer rollover
- Behavior inside prebuilt ASR libraries

These items require the corresponding proprietary IDE/device support, hardware, RF test setup, network server, credentials, and regional test plan.
