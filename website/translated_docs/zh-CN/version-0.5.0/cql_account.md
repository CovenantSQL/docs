---
id: cql_account
title: 账号管理
---

对于 TestNet 环境，我们提供了一个公用的测试账号私钥及配置文件用于快速接入测试，详情请参见 [CovenantSQL TestNet](quickstart) 快速上手教程。另外你也可以选择参照如下教程在本地创建新账号。

## 创建新账号

子命令 `generate` 在指定目录生成私钥及指向 TestNet 的配置文件，示例：

```bash
cql generate config
```

> 目前默认生成的配置文件指向测试网，还需要提供生成指向 Docker 一键部署网络的配置方法。

指定目录的参数详见[完整参数说明](#子命令-generate-完整参数)。

输出：

    Generating key pair...
    Enter master key(press Enter for default: ""): 

    Private key file: ~/.cql/private.key
    Public key's hex: 027af3584b8b4736d6ba1e78ace5f0fdefe561f08749c5cac39d23668c3030fe39
    Generated key pair.
    Generating nonce...
    INFO[0075] cpu: 4
    INFO[0075] position: 3, shift: 0x0, i: 3
    INFO[0075] position: 1, shift: 0x0, i: 1
    INFO[0075] position: 0, shift: 0x0, i: 0
    INFO[0075] position: 2, shift: 0x0, i: 2
    nonce: {{1056388 0 0 1424219234} 25 000000737633a77a39fc5e0a1855ca2c441486fef049ac4069e93dde6e58bb01}
    node id: 000000737633a77a39fc5e0a1855ca2c441486fef049ac4069e93dde6e58bb01
    Generated nonce.
    Generating config file...
    Generated nonce.

## 获取私钥文件的公钥

子命令 `generate` 也可以用来获取已经存在的私钥文件对应的公钥十六进制串。示例：

```bash
cql generate public
```

输出：

    Enter master key(press Enter for default: ""): 

    INFO[0011] init config success                           path=/home/levente/.cql/private.key
    INFO[0011] use public key in config file: /home/levente/.cql/config.yaml
    Public key's hex: 02fd4089e7f4ca224f576d4baa573b3e9662153c952fce3f87f9586ffdd11baef6

> 这一功能实际使用过程中暂时不会用到。

## 子命令 `generate` 完整参数

通用参数部分参考 [子命令通用参数](#子命令通用参数)，以下介绍其他子命令时不再另外说明。

特殊地，在使用 `cql generate config` 命令生成新账号配置时，`-config`、`-no-password` 和 `-password` 等参数实际作用于将要生成的新私钥和配置文件，而不是要读取的文件。

    usage: cql generate [通用参数] config | public

    生成新私钥及配置文件，或获取指定配置的私钥文件对应的公钥。

    Params:
      没有额外参数

## 计算 Node ID

子命令 `idminer` 用于计算指定配置文件（对应的私钥）的 Node ID（Node ID 的相关知识请参考[链接](terms#Node-ID)）。示例：

```bash
cql idminer
```

输出：

    INFO[0000] cql build: cql develop-34ae741a-20190415161544 linux amd64 go1.11.5
    Enter master key(press Enter for default: ""):

    INFO[0008] init config success                           path=/home/levente/.cql/config.yaml
    INFO[0008] use public key in config file: /home/levente/.cql/config.yaml
    INFO[0008] cpu: 8
    INFO[0008] position: 3, shift: 0x20, i: 7
    INFO[0008] position: 0, shift: 0x0, i: 0
    INFO[0008] position: 3, shift: 0x0, i: 6
    INFO[0008] position: 1, shift: 0x0, i: 2
    INFO[0008] position: 2, shift: 0x0, i: 4
    INFO[0008] position: 1, shift: 0x20, i: 3
    INFO[0008] position: 2, shift: 0x20, i: 5
    INFO[0008] position: 0, shift: 0x20, i: 1
    nonce: {{1251426 4506240821 0 0} 25 00000041bc2b3de3bcb96328d0004c684628a908f0233eb31fe9998ef0c6288e}
    node id: 00000041bc2b3de3bcb96328d0004c684628a908f0233eb31fe9998ef0c6288e

> 这一功能实际使用过程中暂时不会用到。

## 子命令 `idminer` 完整参数

    usage: cql idminer [通用参数] [-difficulty number] [-loop [true]]

    为指定配置的私钥文件计算新的 Node ID。

    Params:
      -difficulty int
            生成 Node ID 的难度要求，默认值为 24
      -loop
            循环计算以取得更高难度的 Node ID
