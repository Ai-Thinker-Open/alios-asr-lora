[![中文](https://img.shields.io/badge/中文-文档-blue)](ARCHITECTURE.zh.md)

# Architecture

## Layer map

```text
Application projects and examples
  projects/Creator/...        example/lorawan/lorawanapp
               \              /
                LoRaWAN service/API
              kernel/protocols/lorawan
                         |
        LoRaMAC + regions + crypto + timers
                         |
           Radio abstraction (Radio_s)
                /                    \
      ASR6501 integrated radio      SX1276 driver
                |                    |
          board/asr6501         board/eml3047
                \                    /
               AliOS kernel and HAL
```

## Responsibilities

| Layer | Main locations | Responsibility |
| --- | --- | --- |
| Applications | `projects/Creator`, `example/lorawan` | Product behavior, credentials, join/send policy, callbacks |
| LoRaWAN MAC | `kernel/protocols/lorawan/lora/mac` | MAC state, Class A/B/C behavior, commands, confirmations |
| Regions | `kernel/protocols/lorawan/lora/mac/region` | Channel plans, data rates, receive windows, TX limits |
| System support | `kernel/protocols/lorawan/lora/system` | Timers, delay, low power, crypto utilities |
| Radio drivers | `device/lora` | Radio register/state operations behind `Radio_s` |
| Board ports | `board/asr6501`, `board/eml3047` | Pins, interrupts, SPI, RTC/time adapter, RF switching |
| OS/platform | `kernel`, `platform` | Scheduler, HAL, startup, MCU drivers, linking |

## Build models

The repository has two distinct build models:

1. PSoC Creator `.cyprj` files select ASR6501/ASR6502 source and prebuilt library inputs.
2. AliOS `.mk` components resolve an application, board, MCU family, and protocol components into a GNU Arm firmware image.

Do not assume that a file added to an AliOS `.mk` target is automatically included by a Creator project, or vice versa. When changing shared LoRaWAN code, inspect both manifests.

## Change-risk boundaries

- MAC and region changes can affect certification, timing, duty cycle, and interoperability.
- Timer or low-power changes can cause missed receive windows even when compilation succeeds.
- `Radio_s` is a positional function-pointer table; declaration and every initializer must stay in the same order.
- Board include paths and device macros must be visible to components that include board-owned public headers.
- Prebuilt libraries hide part of the ASR execution path; source-level review cannot prove their behavior.
