[![English](https://img.shields.io/badge/English-Docs-green)](ARCHITECTURE.md)

# 架构说明

## 分层关系

```text
应用工程与示例
  projects/Creator/...        example/lorawan/lorawanapp
               \              /
                LoRaWAN 服务/API
              kernel/protocols/lorawan
                         |
        LoRaMAC + 区域 + 加密 + 定时器
                         |
             无线抽象（Radio_s）
                /                    \
        ASR6501 集成无线           SX1276 驱动
                |                    |
          board/asr6501         board/eml3047
                \                    /
                AliOS 内核与 HAL
```

## 各层职责

| 层级 | 主要位置 | 职责 |
| --- | --- | --- |
| 应用 | `projects/Creator`、`example/lorawan` | 产品行为、密钥、入网/发送策略、回调 |
| LoRaWAN MAC | `kernel/protocols/lorawan/lora/mac` | MAC 状态、Class A/B/C、命令和确认队列 |
| 区域 | `kernel/protocols/lorawan/lora/mac/region` | 信道规划、速率、接收窗口和发送限制 |
| 系统支持 | `kernel/protocols/lorawan/lora/system` | 定时、延时、低功耗和加密工具 |
| 无线驱动 | `device/lora` | 通过 `Radio_s` 抽象操作无线寄存器和状态 |
| 板级适配 | `board/asr6501`、`board/eml3047` | 引脚、中断、SPI、RTC/时间接口和射频切换 |
| OS/平台 | `kernel`、`platform` | 调度、HAL、启动、MCU 驱动和链接 |

## 两种构建模型

仓库存在两套不同的构建模型：

1. PSoC Creator `.cyprj` 文件选择 ASR6501/ASR6502 的源码和预编译库。
2. AliOS `.mk` 组件把应用、开发板、MCU 系列和协议组件组合成 GNU Arm 固件。

加入 AliOS `.mk` 的文件不会自动进入 Creator 工程，反之亦然。修改共享 LoRaWAN 代码时必须同时检查两类构建清单。

## 高风险边界

- MAC 和区域修改可能影响认证、时序、占空比及互操作性。
- 定时器或低功耗修改即使能够编译，也可能导致接收窗口丢失。
- `Radio_s` 是按位置初始化的函数指针表，声明顺序与所有初始化器必须一致。
- 被其他组件包含的板级公共头文件，其依赖路径和器件宏必须全局可见。
- ASR 工程包含预编译库，源码审核无法证明其中的运行行为。
