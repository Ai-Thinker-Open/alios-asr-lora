[![English](https://img.shields.io/badge/English-Docs-green)](CODE_ENTRY.md)

# 代码入口

## ASR6501 LoRaWAN 工程

PSoC Creator 工程文件为 `projects/Creator/ASR6501/lorawan.cydsn/lorawan.cyprj`。

运行流程：

```text
main.c:main
  -> classA.c 中的 application_start()
     -> 板级/无线初始化
     -> LoRaMacInitialization()
     -> LoRaMacMlmeRequest() / LoRaMacMcpsRequest()
     -> 应用事件循环
```

工程文件决定该 Creator 目标使用的源码和 ASR 预编译库，应将它视为 Creator 工程的权威构建清单。

## ASR6501 Ping-Pong 工程

工程文件为 `projects/Creator/ASR6501/pingpong.cydsn/pingpong.cyprj`。其 `main.c` 调用 `application_start()`，运行点对点无线示例，而不是 LoRaWAN MAC 应用。

## AliOS EML3047 目标

应用入口为 `example/lorawan/lorawanapp/lorawanapp.c:application_start`：

```text
AliOS 组件启动
  -> application_start()
     -> HW_Init()
     -> DBG_Init()
     -> lora_Init()
     -> lora_fsm()
```

`kernel/protocols/lorawan/lorawan.mk` 组合 MAC、区域、定时器、无线驱动和 EML3047 适配源码；`board/eml3047/eml3047.mk` 提供 STM32L071 板级源码、器件宏以及 HAL/CMSIS 头文件路径。

## 主要配置位置

- LoRaWAN 密钥和设备参数：从应用的 `Commissioning.h` 与 `kernel/protocols/lorawan/commissioning.h` 开始检查。
- 区域选择：使用前核对目标的 `REGION_*` 构建宏；本次验证的 EML3047 目标选择了 `REGION_CN470`。
- 板级与无线引脚：按目标检查 `board/asr6501` 或 `board/eml3047`。
- 无线驱动：`device/lora/asr6501_lrwan`、`device/lora/sx1276` 及其板级适配。

不要把生产环境的 AppKey/NwkKey 提交到公开仓库。部署前还必须确认当地频率规划以及天线和射频设置的合法性。
