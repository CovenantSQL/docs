---
id: quickstart
title: 🌏 TestNet 快速开始
---

## CovenantSQL 工具包

### 工具包简介

请根据您使用的操作系统平台选择 [下载最新版 CovenantSQL 工具包](https://github.com/CovenantSQL/CovenantSQL/releases)。

例如，您使用的是：

- MacOS 平台请下载：[**CovenantSQL-v0.3.0.osx-amd64.tar.gz**](https://github.com/CovenantSQL/CovenantSQL/releases/download/v0.3.0/CovenantSQL-v0.3.0.osx-amd64.tar.gz)
- Linux 平台请下载：[**CovenantSQL-v0.3.0.linux-amd64.tar.gz**](https://github.com/CovenantSQL/CovenantSQL/releases/download/v0.3.0/CovenantSQL-v0.3.0.linux-amd64.tar.gz)
- Windows 平台我们稍后发布，有需求请戳这里：[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/CovenantSQL/CovenantSQL)

解压之后，你将得到以下命令行工具，包括：`cql`、`cql-utils` 等。

| 工具名     | 介绍                                                                   |
| ---------- | ---------------------------------------------------------------------- |
| cql        | CovenantSQL 的客户端，类似 mysql 命令，用于执行 SQL                    |
| cql-utils  | CovenantSQL 工具箱，用于和主链交互                                     |
| cql-minerd | CovenantSQL 矿工客户端，用于运行数据库赚取奖励，以后会开放加入         |
| cqld       | CovenantSQL 主链节点，主要由 CovenantLabs 以及合作伙伴以 DPoS 模式运行 |

### 测试网快速接入

目前，我们已经发布了测试网 v0.3.0，供大家进行原理性验证和体验。你可以选在使用公共的测试账号快速进行接入测试。

测试账号的配置文件和私钥：[config.yaml](https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/develop/conf/testnet/config.yaml)、[private.key](https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/develop/conf/testnet/private.key) ，或者使用以下命令：

```bash
mkdir conf
wget https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/develop/conf/testnet/config.yaml -O conf/config.yaml
wget https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/develop/conf/testnet/private.key -O conf/private.key
chmod 600 conf/private.key
```

**测试网注**：

> 该账号是公共的且只供测试使用，请不要在该账号创建的数据库中存放你的应用信息，我们会不定期清理数据库数据。
>
> 测试网暂时由 3 个 Miner 组成，所以暂时最大只支持`create 3`创建 3 个节点组成的数据库。

## 创建并访问 CovenantSQL 数据库

### 创建数据库

```shell
./cql -config conf/config.yaml -create 1
```

输出：

```
covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872
```

这里表示你提交了 `0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872` 这个数据库的创建请求到主链。

> 我们需要等待大概 30s 的时间，等待数据库创建，大致过程为：
>
> 1. 收到请求的 出块节点（Block Producer）进行 Miner 和数据库创建请求的撮合
> 2. 数据库创建请求在 其它出块节点 进行验证和确认
> 3. SQLChain 的符合条件的 Miner 收到数据库任务
> 4. SQLChian 组建 Kayak 数据库集群
> 5. 所有 Miner 准备就绪等待请求

### 访问数据库

```shell
./cql -config conf/config.yaml -dsn covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872
```

连接上数据库后，你可以按你操作数据库的习惯来操作 CovenantSQL 上的数据库。比如执行 `CREATE TABLE` 创建表、`SELECT` 查询数据等操作。

### 数据库 SDK

- [Golang 开发指引](./development)

## SQLChain 区块浏览器

CovenantSQL 有一个特性是**其操作记录是不可变且可跟踪的**，你可以通过 [测试网区块浏览器](https://explorer.dbhub.org/) 来查询某个数据库的操作记录。

> 测试网的`区块浏览器`目前是开放权限的，所以任何知道数据库 ID 的人都能看到您的数据

查询时，请在其页面右上角填入你的数据库 ID。例如：`0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872`

## 创建账号

我们的测试网支持你创建自己的的账号，并在自己的账号下创建数据库。通过以下的命令创建账号（会询问设置主密码，测试期间建议直接回车留空）：

```shell
./cql-utils -tool confgen
```

输出：

```
Generating key pair...
Enter master key(press Enter for default: ""):
Private key file: conf/private.key
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
```

该命令会为你创建一个 `conf` 目录：

- `conf/private.key`: 为你生成的私钥通过主密码加密保存在该文件中，你的账号地址需要使用该文件创建；
- `conf/config.yaml`: 为你生成的配置，cql 可以通过读取该配置来访问 CovenantSQL 测试网。

再运行命令用来生成账号地址（也叫钱包地址、CovenantSQL 地址）：

```shell
./cql-utils -tool addrgen -private conf/private.key
```

输出：

```toml
wallet address: 4kcCg4niPjWURuFyT633V8TF9Xb9PvUR5Xbf6aTvGxFZkJFQaS9
```

你可以在我们的 [CovenantSQL 测试网](https://testnet.covenantsql.io/) 输入你生成的钱包地址，通过发微博、推特等社交媒体来帮助我们推广我们的项目，我们会为你的钱包充值。有任何问题请来这里讨论：[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/CovenantSQL/CovenantSQL)

使用 cql 命令行工具查询余额：

```shell
./cql -config conf/config.yaml -get-balance
```

输出：

```
INFO[0000] stable coin balance is: 100                   caller="main.go:246 main.main"
INFO[0000] covenant coin balance is: 0                   caller="main.go:247 main.main"
```

恭喜，你已收到我们发出的 PTC 稳定币，现在即可开始使用 CovenantSQL， 你可以参考 [Golang 使用 CovenantSQL 文档](./development) 进行开发。
