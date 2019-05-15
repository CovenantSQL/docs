---
id: cql_account
title: 账号管理
---

对于 TestNet 环境，我们提供了一个公用的测试账号私钥及配置文件用于快速接入测试，详情请参见 [CovenantSQL TestNet](quickstart) 快速上手教程。另外你也可以选择参照如下教程在本地创建新账号。

## 创建新账号

子命令 `generate` 在指定目录生成私钥及指向 TestNet 的配置文件，示例：

```bash
cql generate
```

> 目前默认生成的配置文件指向测试网，还需要提供生成指向 Docker 一键部署网络的配置方法。

指定目录的参数详见[完整参数说明](#子命令-generate-完整参数)。

输出：

    Generating private key...
    Please enter password for new private key
    Generated private key.
    Generating nonce...
    INFO cpu: 4
    INFO position: 2, shift: 0x0, i: 2
    INFO position: 0, shift: 0x0, i: 0
    INFO position: 3, shift: 0x0, i: 3
    INFO position: 1, shift: 0x0, i: 1
    nonce: {{973366 0 586194564 0} 26 0000002c32aa3ee39e4f461a5f5e7fda50859f597464d81c9618d443c476835b}
    node id: 0000002c32aa3ee39e4f461a5f5e7fda50859f597464d81c9618d443c476835b
    Generated nonce.
    Generating config file...
    Generated config.

    Config file:      ~/.cql/config.yaml
    Private key file: ~/.cql/private.key
    Public key's hex: 03f195dfe6237691e724bcf54359d76ef388b0996a3de94a7e782dac69192c96f0

    Wallet address: dbb7d1ee90452b8ee9cf514540b8d14fe5b7a750cc0c2f3824db6c8b284ada95

    Any further command could costs PTC.
    You can get some free PTC from:
    	https://testnet.covenantsql.io/wallet/dbb7d1ee90452b8ee9cf514540b8d14fe5b7a750cc0c2f3824db6c8b284ada95


### 私钥文件的公钥

子命令 `generate` 同时打印了私钥文件对应的公钥十六进制串。示例：

输出：

    Public key's hex: 03f195dfe6237691e724bcf54359d76ef388b0996a3de94a7e782dac69192c96f0

> 这一信息实际使用过程中暂时不会用到。

### 钱包地址

子命令 `generate` 也打印了钱包地址的十六进制串 (并且保存在了 `config.yaml` 文件中)。示例：

输出：

    Wallet address: dbb7d1ee90452b8ee9cf514540b8d14fe5b7a750cc0c2f3824db6c8b284ada95

    Any further command could costs PTC.
    You can get some free PTC from:
    	https://testnet.covenantsql.io/wallet/dbb7d1ee90452b8ee9cf514540b8d14fe5b7a750cc0c2f3824db6c8b284ada95

拿到一个新的钱包地址之后，你需要按照上面的提示去申请PTC。


## 子命令 `generate` 完整参数

通用参数部分参考 [子命令通用参数](#子命令通用参数)，以下介绍其他子命令时不再另外说明。

    usage: cql generate [common params] [-source template_file] [-miner] [-private existing_private_key] [dest_path]

    生成新私钥及配置文件，或获取指定配置的私钥文件对应的公钥。
    e.g.
        cql generate

    or input a passphrase by

        cql generate -with-password

    Generate params:
      -miner string
        	Generate miner config with specified miner address
      -private string
        	Generate config using an existing private key
      -source string
        	Generate config using the specified config template

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
