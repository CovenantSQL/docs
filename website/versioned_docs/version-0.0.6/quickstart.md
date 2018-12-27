---
id: version-0.0.6-quickstart
title: 快速开始
original_id: quickstart
---

## 下载 CovenantSQL 工具包

请 [下载最新版 CovenantSQL 工具包](https://github.com/CovenantSQL/CovenantSQL/releases)。您将得到以下命令行工具：`cql`、`cql-utils`。

## 创建并访问 CovenantSQL 数据库

我们已经上线了 CovenantSQL 测试网，也为您准备了一个公共的测试账号，请下载账号配置文件和私钥：[config.yaml](https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/feature/chainBus-SQLChain/test/service/node_c/config.yaml)、[private.key](https://github.com/CovenantSQL/CovenantSQL/raw/feature/chainBus-SQLChain/test/service/node_c/private.key) 用于测试。

**注**：该账号是公共的且只供测试使用，请不要在该账号创建的数据库中存放您的应用信息，我们会不定期清理数据库数据。

### 使用 cql 命令行工具创建数据库

```shell
./cql -config config.yaml -create 1
```

输出：

```
INFO[0000] the newly created database is: "covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872?use_follower=false&use_leader=true"
```

这里表示您创建了 `0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872` 这个数据库。

### 使用 cql 命令行工具访问数据库

```shell
./cql -config config.yaml -dsn covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872
```

连接上数据库后，您可以按您操作数据库的习惯来操作 CovenantSQL 上的数据库。比如执行 `CREATE TABLE` 创建表、`SELECT` 查询数据等操作。

### 使用数据库驱动访问数据库

- [Go](./development)
- [Java](https://github.com/CovenantSQL/covenant-connector)
- [Python](https://github.com/CovenantSQL/python-driver)
- [NodeJS](https://github.com/CovenantSQL/node-covenantsql)
- [Web (WIP)](https://github.com/CovenantSQL/cql.js)

## 通过区块浏览器查看您的数据库操作记录

CovenantSQL 有一个特性是**其操作记录是不可变且可跟踪的**，您可以通过 [测试网区块浏览器](https://explorer.dbhub.org/) 来查询某个数据库的操作记录。查询时，请在其页面右上角填入您的数据库地址。

## 创建账号

我们的测试网支持您创建自己的的账号，并在自己的账号下创建数据库。通过以下的命令创建账号（需要输入主密码）：

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

- `conf/private.key`: 为您生成的私钥通过主密码加密保存在该文件中，您的账号地址需要使用该文件创建；
- `conf/config.yaml`: 为您生成的配置，cql 可以通过读取该配置来访问 CovenantSQL 测试网。

再运行命令用来生成账号地址（也叫钱包地址、CovenantSQL 地址）：

```shell
./cql-utils -tool addrgen -private conf/private.key
```

输出：

```
wallet address: 4kcCg4niPjWURuFyT633V8TF9Xb9PvUR5Xbf6aTvGxFZkJFQaS9
```

您可以在我们的 [CovenantSQL 测试网](https://testnet.covenantsql.io/) 输入您生成的钱包地址，通过发微博、推特等社交媒体来帮助我们推广我们的项目，我们会为您的钱包充值。

使用 cql 命令行工具查询余额：

```shell
./cql -config conf/config.yaml -get-balance
```

输出：

```
INFO[0000] stable coin balance is: 100                   caller="main.go:246 main.main"
INFO[0000] covenant coin balance is: 0                   caller="main.go:247 main.main"
```

## 部署私有 CovenantSQL 数据库（搭建私链）

如果您是企业用户，希望在自己的网络搭建 CovenantSQL 数据库服务，请参考：

- [Docker 一键部署 CovenantSQL 测试网](./deployment)

## CovenantSQL 联盟链解决方案

正在建设中，如需咨询请邮件至 webmaster@covenantsql.io。
