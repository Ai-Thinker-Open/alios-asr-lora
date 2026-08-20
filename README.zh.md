[![English](https://img.shields.io/badge/English-README-green)](README.md)

# AliOS ASR LoRa SDK

本仓库是面向 LoRa/LoRaWAN 开发的历史 AliOS Things 分支，包含 ASR6501/ASR6502 的 Cypress PSoC Creator 工程、AliOS 内核与平台层、LoRaWAN MAC/区域协议栈，以及 EML3047（STM32L071 + SX1276）的 GNU Arm 构建目标。

> 维护提示：代码和工具链约定来自 AliOS 1.3 时期。`VERSION` 标识为 `v4.2_rel`，仓库中同时存在更晚的发布式标签。生产使用时应明确选定 Tag 或 Commit，不要默认认为主分支就是最新厂商版本。

## 从这里开始

| 目标 | 入口 |
| --- | --- |
| ASR6501 LoRaWAN 应用 | `projects/Creator/ASR6501/lorawan.cydsn/lorawan.cyprj` |
| ASR6501 Ping-Pong 示例 | `projects/Creator/ASR6501/pingpong.cydsn/pingpong.cyprj` |
| ASR6501/ASR6502 最小 AliOS 工程 | `projects/Creator/ASR6501/alios_small.cydsn` 和 `projects/Creator/ASR6502/alios_small.cydsn` |
| AliOS LoRaWAN 示例 | `example/lorawan/lorawanapp/lorawanapp.c` |
| LoRaWAN 协议栈 | `kernel/protocols/lorawan` |
| EML3047 板级适配 | `board/eml3047` |

修改协议栈或板级代码前，请先阅读[代码入口](doc/CODE_ENTRY.zh.md)、[架构说明](doc/ARCHITECTURE.zh.md)和[验证记录](doc/VALIDATION.zh.md)。

## 复现已验证构建

EML3047 目标已在 WSL2 Ubuntu 22.04 中使用 GNU Arm Embedded GCC 10.3.1、Python 2.7、Perl 和仓库自带的 GNU Make 4.1 完成构建：

```sh
./tools/build_eml3047.sh
```

脚本会清理并重新构建 `lorawan.lorawanapp@eml3047`，输出目录为：

```text
out/lorawan.lorawanapp@eml3047/binary/
```

在匹配的旧版 AliOS 环境中，也可以尝试历史的 `aos make <target>` 工作流。辅助脚本直接调用仓库自带 Makefile，因此无需安装旧版 `aos` CLI 即可复现本次审核使用的命令。

## 硬件专用构建

ASR6501 和 ASR6502 工程需要对应的 Cypress PSoC Creator 环境、厂商设备支持包和真实硬件。请打开目标工程的 `.cyprj` 文件，并在构建前核对器件型号、链接输入、无线区域、板级引脚和烧录配置。

## 验证范围

EML3047 固件已完成编译和链接，并生成 ELF、BIN、HEX 文件。ASR PSoC Creator 工程已检查入口和源码引用，但验证环境没有 PSoC Creator，因此未执行编译。烧录、射频行为、LoRaWAN 入网/上行/下行、低功耗时序和硬件外设仍需在目标板上测试。准确边界见[验证记录](doc/VALIDATION.zh.md)。

## 许可证

仓库根目录采用 [Apache License 2.0](LICENSE)。部分厂商代码和协议栈文件保留了各自的版权及许可证声明，重新分发或修改时必须保留这些声明。
