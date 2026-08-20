[![English](https://img.shields.io/badge/English-Docs-green)](VALIDATION.md)

# 验证记录

验证日期：2026-08-20

## 环境

- Windows 11 + WSL2 Ubuntu 22.04
- 仓库自带 GNU Make 4.1（`build/cmd/linux64/make`）
- GNU Arm Embedded GCC 10.3.1
- Python 2.7.18、Perl 5
- 目标：`lorawan.lorawanapp@eml3047`

## 复现方式

```sh
./tools/build_eml3047.sh
```

最终源码树执行了两次全新构建，两次均完成编译、静态库生成、最终链接、二进制转换和内存映射生成。构建日志中没有 `warning:` 或 `error:` 诊断。需要注意，此历史目标包含 `-w`，因此“零诊断”不能证明所有编译器告警类别都已清零。

预期输出目录：

```text
out/lorawan.lorawanapp@eml3047/binary/
```

本次审核构建生成的 BIN 为 75,812 字节，AliOS 内存汇总为 ROM 74,879 字节、RAM 8,168 字节。调试路径和工具链版本可能影响 ELF 派生文件，因此每个待审核 Commit 都应重新生成文件哈希。

## 已复现并修复的问题

- LoRaWAN 组件引用了缺失的 `lora/system/timeServer.c`；从本仓库 `develop` 分支恢复了匹配实现，并补齐当前头文件声明的系统时间接口。
- LoRaWAN 组件的源码清单遗漏了确认队列、Class B 实现和 EML3047 无线适配。
- EML3047 公共板级头文件依赖 HAL/CMSIS 头文件和器件宏，但原配置只对板级组件局部生效。
- MAC 与 EML3047 无线抽象中的公共网络和唤醒时间函数命名不一致。
- Linux 配置文件生成会重复转义 C 字符串宏中的反斜杠；现改用仓库自带 Make 4.1 支持的 GNU Make 文件写入函数。

## 静态证据

- ASR6501 LoRaWAN 入口：`projects/Creator/ASR6501/lorawan.cydsn/main.c` 和 `classA.c`。
- ASR6501 Ping-Pong 入口：`projects/Creator/ASR6501/pingpong.cydsn/main.c`。
- Creator 构建清单：`projects/Creator` 下的 `.cyprj` 文件。
- AliOS 应用入口：`example/lorawan/lorawanapp/lorawanapp.c`。
- 共享协议栈清单：`kernel/protocols/lorawan/lorawan.mk`。

## 未验证项目

- ASR6501/ASR6502 的 PSoC Creator 编译
- 与特定 Cypress/PSoC Creator 或厂商设备支持包版本的兼容性
- 任一目标板的烧录和启动
- LoRa 射频发送、区域法规、天线匹配和通信距离
- 硬件上的 OTAA/ABP 入网、上行、下行、确认消息和 Class B 信标时序
- 低功耗电流及长时间定时器回绕
- ASR 预编译库内部行为

这些项目需要对应的专有 IDE/设备支持、硬件、射频测试条件、网络服务器、密钥和区域测试计划。
