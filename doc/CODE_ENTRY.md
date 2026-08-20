[![中文](https://img.shields.io/badge/中文-文档-blue)](CODE_ENTRY.zh.md)

# Code entry points

## ASR6501 LoRaWAN project

The PSoC Creator project is `projects/Creator/ASR6501/lorawan.cydsn/lorawan.cyprj`.

Runtime flow:

```text
main.c:main
  -> application_start() in classA.c
     -> board/radio initialization
     -> LoRaMacInitialization()
     -> LoRaMacMlmeRequest() / LoRaMacMcpsRequest()
     -> application event loop
```

The project file selects the source files and prebuilt ASR libraries used by this target. Treat it as the authoritative build manifest for the Creator project.

## ASR6501 ping-pong project

The project is `projects/Creator/ASR6501/pingpong.cydsn/pingpong.cyprj`. Its `main.c` calls `application_start()`, which runs the point-to-point radio example rather than the LoRaWAN MAC application.

## AliOS EML3047 target

The application entry is `example/lorawan/lorawanapp/lorawanapp.c:application_start`:

```text
AliOS component startup
  -> application_start()
     -> HW_Init()
     -> DBG_Init()
     -> lora_Init()
     -> lora_fsm()
```

`kernel/protocols/lorawan/lorawan.mk` assembles the MAC, region, timer, radio, and EML3047 adapter sources. `board/eml3047/eml3047.mk` provides STM32L071 board sources, device definitions, and HAL/CMSIS include paths.

## Configuration points

- LoRaWAN keys and device parameters: start with the application `Commissioning.h` and `kernel/protocols/lorawan/commissioning.h`.
- Region selection: check the target's `REGION_*` build definitions before use. The validated EML3047 target selected `REGION_CN470`.
- Board and radio pins: `board/asr6501` or `board/eml3047`, depending on the target.
- Radio drivers: `device/lora/asr6501_lrwan`, `device/lora/sx1276`, and their board adapters.

Never commit production AppKey/NwkKey material to a public repository. Confirm frequency-plan legality and antenna/RF settings for the deployment region.
