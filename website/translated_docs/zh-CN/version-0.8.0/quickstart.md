---
id: quickstart
title: Quick Start
---

## CovenantSQL 工具包

### 工具包安装

请根据您使用的操作系统平台选择安装方式：

#### MacOS 平台

- 🍺 Homebrew 用户可以直接在命令行：

    ```bash
    brew install cql
    ```

- 非 Homebrew，可以执行：

    ```bash
    sudo bash -c 'curl -L "https://mac.gridb.io/cql" | \
     tar xzv -C /usr/local/bin/ --strip-components=1'
    ```

#### Linux 平台

- 在命令行中执行：

    ```bash
    sudo bash -c 'curl -L "https://linux.gridb.io/cql" | \
    tar xzv -C /usr/local/bin/ --strip-components=1'
    ```

安装完成后可以执行下面的命令，查看是否安装成功

```bash
cql version
```

如果对于 MacOS 或者 Linux 平台有任何错误，可以执行如下命令进行修复：

```bash
sudo chmod a+x /usr/local/bin/cql*         # Fix Permission
sudo ln -s /usr/local/bin/cql* /usr/bin/   # Fix if /usr/local/bin not in $PATH
```

如果问题依旧存在请在我们的 GitHub 页面 [提交 Issue](https://github.com/CovenantSQL/CovenantSQL/issues/new?assignees=&labels=bug&template=bug_report.md&title=%5BBUG%5D)。

### 工具包介绍

| 工具名     | 介绍                                                         |
| ---------- | ------------------------------------------------------------ |
| cql        | CovenantSQL 的客户端，`cql console` 命令类似 mysql 命令，用于执行 SQL。还有其他丰富的工具链 |
| cql-fuse   | CovenantSQL 的 FUSE 客户端，可以把 CovenantSQL 数据库 mount 成文件系统 |
| cql-minerd | CovenantSQL 矿工客户端，用于运行数据库赚取奖励，以后会开放加入 |
| cqld       | CovenantSQL 主链节点，主要由 CovenantLabs 以及合作伙伴以 DPoS 模式运行 |

> Windows 平台我们稍后发布，有需求请在 GitHub [提 Issue](https://github.com/CovenantSQL/CovenantSQL/issues/new?assignees=&labels=&template=feature_request.md&title=) 讨论。

### 测试网快速接入

目前，我们已经发布了测试网 v0.8.0，供大家进行原理性验证和体验。你可以选在使用公共的测试账号快速进行接入测试。

测试账号的配置文件和私钥：[config.yaml](https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/develop/conf/testnet/config.yaml)、[private.key](https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/develop/conf/testnet/private.key) (密码为空)，或者使用以下命令：

```bash
mkdir -p ~/.cql/testnet-conf
curl -L https://git.io/fhFZe --output ~/.cql/testnet-conf/config.yaml
curl -L https://git.io/fhFZv --output ~/.cql/testnet-conf/private.key
chmod 600 ~/.cql/testnet-conf/private.key
```

**测试网注**：

> 该账号是公共的且只供测试使用，请不要在该账号创建的数据库中存放你的应用信息，我们会不定期清理数据库数据。
>
> 测试网暂时由 3 个 Miner 组成，所以暂时最大只支持 `create 3` 创建 3 个节点组成的数据库。

## 创建数据库

```bash
cql create -config=~/.cql/testnet-conf/config.yaml \
    -db-node 1 -wait-tx-confirm
```

命令执行耗时较长，大约 30s 之后控制台会输出：

> covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872


这里表示你提交了数据库 `0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872` 的创建请求到主链，并创建数据库完成。

> 命令执行耗时较长，大致过程为：
>
> 1. 收到请求的 出块节点（Block Producer）进行 Miner 和数据库创建请求的撮合
> 2. 数据库创建请求在 其它出块节点 进行验证和确认
> 3. SQLChain 上符合条件的 Miner 收到数据库任务
> 4. SQLChain 组建 Kayak 数据库集群
> 5. 所有 Miner 准备就绪等待请求



## 访问数据库

```bash
cql console -config=~/.cql/testnet-conf/config.yaml \
    covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872
```

连接上数据库后，你可以按你操作数据库的习惯来操作 CovenantSQL 上的数据库。比如执行 `CREATE TABLE` 创建表、`SELECT` 查询数据等操作。



## SQLChain 区块浏览器

CovenantSQL 有一个特性是**其操作记录是不可变且可跟踪的**，你可以通过 [测试网区块浏览器](https://explorer.dbhub.org/) 来查询某个数据库的操作记录。

> 测试网的`区块浏览器`目前是开放权限的，使用 TestNet 的公共 Key 创建并且知道数据库 ID 的人都能看到您的数据

查询时，请在其页面右上角填入你的数据库 ID。例如：`0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872` 。你可以看到使用 TestNet 的 Key 创建的所有数据的信息：

![explorer](https://github.com/CovenantSQL/docs/raw/master/website/static/img/explorer.png)

   

> **如果想要创建自己的私有数据库，需要从头开始创建一个新的公私钥对，请参考下面的章节。**



## 创建新账号

我们的测试网支持你创建自己的的账号，并在自己的账号下创建数据库。通过以下的命令创建账号（默认生成的私钥为空密码，可以加上 `-with-password` 输入密码）：

```bash
cql generate
```

输出：

```
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

```

该命令会为你在~目录下创建一个 `.cql` 目录：

- `~/.cql/private.key`: 为你生成的私钥通过主密码加密保存在该文件中，你的账号地址需要使用该文件创建；
- `~/.cql/config.yaml`: 为你生成的配置，cql 可以通过读取该配置来访问 CovenantSQL 测试网。

同时也会生成账号地址（也叫钱包地址、CovenantSQL 地址）：
`Wallet address: dbb7d1ee90452b8ee9cf514540b8d14fe5b7a750cc0c2f3824db6c8b284ada95`

你可以用上面得到的钱包地址在这里领取测试用 PTC ： [申请 PTC](https://testnet.covenantsql.io/)。

最多 2min 后，可以使用 cql 命令行工具查询余额：

```bash
cql wallet
```

输出：

```
Particle balance is: 10000000
Wave balance is: 0
```

恭喜，你已收到我们发出的 PTC 稳定币，现在即可开始使用 CovenantSQL， 你可以参考 [Golang 使用 CovenantSQL 文档](./driver_golang) 进行开发。
