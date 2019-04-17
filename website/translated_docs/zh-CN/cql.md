---
id: cql
title: '🖥️ CQL 命令行工具集'
---
## 简介

CovenantSQL 为终端用户提供 `cql` 命令行工具集，用于对用户账号、钱包以及名下的数据库进行便捷的管理和访问操作。~~工具下载地址见 [release](https://github.com/CovenantSQL/CovenantSQL/releases) 页面。请将 `cql` 二进制解压到自己系统 PATH 路径里以方便调用。~~（补充：使用包管理工具安装 `cql`）。

### 账号私钥和配置文件

运行 `cql` 依赖私钥文件 `private.key` 和配置文件 `config.yaml`，其中：

- `private.key`：生成用户账户时所分配的私钥，请务必妥善保管好这个私钥
- `config.yaml`：主要用于配置 `cql` 命令要连接的 CovenantSQL 网络（如 TestNet 或用户使用 [Docker 一键部署](deployment)的网络）

出于安全方面的考虑，私钥文件通常需要使用主密码进行加密。主密码在创建账号时由用户输入，之后由用户自行记忆或保管，而不会保存到配置文件中。当需要使用到私钥的时候，`cql` 命令会要求用户输入主密码以解开私钥文件。

### 子命令通用参数

以下列出子命令中使用到的通用参数：

```bash
  -bypass-signature
        禁用签名和验签，仅用于开发者测试
  -config string
        指定配置文件路径，默认值为 "~/.cql/config.yaml"
  -no-password
        使用空白主密码加密私钥
  -password string
        私钥主密码（不安全，仅用于调试或安全环境下的脚本模式）
```

注意，因为私钥文件的路径是在配置文件中设定的，默认值为相对路径 `./private.key`，即配置文件的同一目录下，所以我们通常把私钥和配置文件放置到同一目录下，而不设置单独的参数来指定私钥文件。

## 账号管理

对于 TestNet 环境，我们提供了一个公用的测试账号私钥及配置文件用于快速接入测试，详情请参见 [CovenantSQL TestNet](quickstart) 快速上手教程。另外你也可以选择参照如下教程在本地创建新账号。

### 创建新账号

子命令 `generate` 在指定目录生成私钥及指向 TestNet 的配置文件，示例：

```bash
cql generate config
```

> 目前默认生成的配置文件指向测试网，还需要提供生成指向 Docker 一键部署网络的配置方法。

指定目录的参数详见[完整参数说明](#子命令-generate-完整参数)。

输出：

```bash
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
```

### 获取私钥文件的公钥

子命令 `generate` 也可以用来获取已经存在的私钥文件对应的公钥十六进制串。示例：

```bash
cql generate public
```

输出：

```bash
Enter master key(press Enter for default: ""): 

INFO[0011] init config success                           path=/home/levente/.cql/private.key
INFO[0011] use public key in config file: /home/levente/.cql/config.yaml
Public key's hex: 02fd4089e7f4ca224f576d4baa573b3e9662153c952fce3f87f9586ffdd11baef6
```

> 这一功能实际使用过程中暂时不会用到

### 子命令 `generate` 完整参数

通用参数部分参考 [子命令通用参数](#子命令通用参数)，以下介绍其他子命令时不再另外说明。

特殊地，在使用 `cql generate config` 命令生成新账号配置时，`-config`、`-no-password` 和 `-password` 等参数实际作用于将要生成的新私钥和配置文件，而不是要读取的文件。

```bash
usage: cql generate [参数]... config | public

生成新私钥及配置文件，或获取指定配置的私钥文件对应的公钥。

Params:
  没有额外参数
```

### 计算 Node ID

子命令 `idminer` 用于计算指定配置文件（对应的私钥）的 Node ID（Node ID 的相关知识请参考[链接](terms#Node-ID)）。示例：

```bash
cql idminer
```

输出：

```bash
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
```

> 这一功能实际使用过程中暂时不会用到

### 子命令 `idminer` 完整参数

```bash
usage: cql idminer [-config file] [-difficulty number] [-loop false]

为指定配置的私钥文件计算新的 Node ID。

Params:
  -difficulty int
        生成 Node ID 的难度要求，默认值为 24
  -loop
        循环计算以取得更高难度的 Node ID
```

## 钱包管理

### 查看钱包地址

在配置好账号以后，可以通过 `wallet` 子命令来获取账号的钱包地址：

```bash
cql wallet
```

输出：

```bash
Enter master key(press Enter for default: ""): 

wallet address: 43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40
```

这里可以看到我们用于测试的账号私钥文件对应的钱包地址是 `43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40`。

### 查看钱包余额

获得钱包地址之后，就可以使用 `wallet` 子命令来查看你的钱包余额了。目前 CovenantSQL 支持的代币类型为以下 5 种：

- `Particle`
- `Wave`
- `Bitcoin`
- `Ether`
- `EOS`

其中 `Particle` 和 `Wave` 为 CovenantSQL 默认使用的代币，查看默认代币余额的命令为：

```bash
cql wallet -balance all
```

输出：

```bash
INFO[0000] Particle balance is: 10000000000000000000
INFO[0000] Wave balance is: 10000000000000000000
```

也可以单独指定代币类型，如查看 `Bitcoin` 余额：

```bash
cql wallet -balance Bitcoin
```

输出：

```bash
INFO[0000] Bitcoin balance is: 0
```

### 向其他账号转账

从 [TestNet](quickstart) 获得代币或 [Docker 一键部署](deployment)的网络获得代币后，可以使用 `transfer` 命令来向其他账号转账。转账操作使用 `json` 格式的转账信息作为参数，例如：

```json
{
  "addr": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", // 收款地址
  "amount": "1000000 Particle" // 转账金额并带上单位
}
```

其中收款地址可以是一个个人钱包地址也可以是一个数据库子链地址。转账至数据库地址时将在该数据库账户上补充付款人的押金与预付款。

把以上参数传给 `transfer` 子命令来进行转账：

```bash
cql transfer '{"addr": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6","amount": "1000000 Particle"}'
```

输出：

```bash
INFO[0000] succeed in sending transaction to CovenantSQL
```

注意，以上输出信息只说明交易请求已经成功发送至 CovenantSQL 网络，需要等待 BP 节点执行并确认交易后才能实际生效。交易能否成功、何时成功可以通过执行 `cql wallet -balance <token_type>` 来确定，也可以在执行命令时添加 `-wait-tx-confirm` 参数来让 `cql` 命令查询到执行结果之后再退出。

### 子命令 `wallet` 完整参数

```bash
usage: cql wallet [-config file] [-balance token_type]

查看账号钱包地址和代币余额。
示例：
    cql wallet
    cql wallet -balance Particle
    cql wallet -balance all

Params:
  -balance string
        获取当前账号中指定代币类型的余额
```

### 子命令 `transfer` 完整参数

```bash
usage: cql transfer [-config file] [-wait-tx-confirm] meta_json

向目标账号地址进行转账。输入参数为 JSON 格式的转账交易数据。
示例：
    cql transfer '{"addr": "your_account_addr", "amount": "100 Particle"}'

由于 CovenantSQL 是区块链上的数据库，在交易生效之前你可能需要等待执行确认。
示例：
    cql transfer -wait-tx-confirm '{"addr": "your_account_addr", "amount": "100 Particle"}'

Params:
  -wait-tx-confirm
        等待交易执行确认（或者出现任何错误）后再退出
```

## 数据库管理

### 创建数据库

创建数据库与 `transfer` 子命令类似使用 `json` 格式的输入参数，创建由一个节点组成的数据库：

```bash
cql create '{"node": 1}'
```

输出：

```bash
Enter master key(press Enter for default: ""):

covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872
```

注意这里生成的 `covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872` 即为数据库的连接字符串（dsn），其中 `covenantsql` 为数据库协议字段，一般也可以缩写为 `cql`；`//` 后的十六进制串为数据库地址，可以在 `transfer` 子命令中作为收款地址使用。

子命令 `grant` 通过向 BP 发起交易实现，所以也支持 `wait-tx-confirm` 参数。

关于子命令 `create` 输入参数的完整说明，请参见[完整参数](#子命令-create-完整参数)。

### ~~删除数据库~~

~~未实现。~~

### 数据库权限管理

#### 访问权限

CovenantSQL 数据库有三类库级别权限：

- `Admin`
- `Write`
- `Read`
- `Void`

其中，`Admin` 可以赋予其他钱包地址数据库的权限（`Admin`、`Write` 或 `Read`）；`Admin` 和 `Write` 可以对数据库进行写操作（`CREATE`, `INSERT` 等）；`Admin` 和 `Read` 可以对数据库进行读操作（`SHOW`, `SELECT` 等）；如果需要设置用户有读写权限但是不能修改其他用户或自己的权限，可以将权限设置为 `Read,Write`；`Void` 是一个特殊的权限，当 `Admin` 想取消某个地址的权限时可以将该地址的权限设置为 `Void`，这样该地址将无法继续读写数据库。创建数据库的地址的权限默认为 `Admin`。

假设我们用默认账号创建好了数据库 `covenantsql:\\4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5`，在目录 `account2` 下创建好新账号配置，账号地址为 `011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6`，现在用默认账号给新账号授权已经创建好的数据库的访问权限，同样使用 `json` 格式的授权信息为参数：

```json
{
   "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5", // 需要进行权限变更的数据库地址
   "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", // 需要赋予权限的钱包地址
   "perm": "Read,Write" // 权限内容，多个权限用英文逗号隔开
}
```

把以上参数传给 `grant` 子命令来增加读写权限：

```bash
cql grant '{"chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5", "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", "perm": "Read,Write"}'
```

输出：

```bash
INFO[0000] succeed in sending transaction to CovenantSQL
```

吊销权限：

```bash
cql grant '{"chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5", "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", "perm": "Void"}'
```

输出：

```bash
INFO[0000] succeed in sending transaction to CovenantSQL
```

子命令 `grant` 通过向 BP 发起交易实现，所以也支持 `wait-tx-confirm` 参数。

由于目前每个数据库实例分别为每个用户独立计费，所以为数据库添加新的账户权限后，需要以新账户身份向该数据库转押金与预付款才能进行正常查询。押金与预付款最小值的计算公式：`gas_price*number_of_miner*120000`。

使用新账户给数据库充值：

```bash
cql -config "account2/config.yaml" transfer '{"addr": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5","amount": "90000000 Particle"}'
```

#### SQL 白名单

CovenantSQL 还支持给用户设置可执行的 SQL 白名单，可以限定用户以指定的 SQL Pattern 和可配的 Query 参数来访问数据库。在指定语句白名单的功能支持下，可以提高数据库的安全性，避免被单语句拖库或执行不正确的删除或更新操作。

增加白名单：

```bash
cql grant '
{
    "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5",
    "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6",
    "perm": {
        "patterns": [
            "SELECT COUNT(1) FROM a",
            "SELECT * FROM a WHERE id = ? LIMIT 1"
        ],
        "role": "Read,Write"
    }
}
'
```

*白名单功能是基于数据库权限的一个扩展，且当前不支持增量的白名单更新，在设置白名单时需要写明所有授权该用户使用的语句，以及该用户对数据库的访问权限*

设置完成后，用户将只能执行 `SELECT COUNT(1) FROM a` 或 `SELECT * FROM a WHERE id = ? LIMIT 1` 的语句（语句内容严格匹配，使用 `select COUNT(1) FROM a` 或 `SELECT COUNT(1) FROM        a` 也不可以）；其中 第二条语句支持用户提供一个参数，以支持查询不同记录的目的。最终可以实现限定用户访问 `表 a`，并一次只能查询 `表 a` 中的一条数据或查询 `表 a` 的总数据量。

去掉白名单限制：

```bash
cql grant '
{
    "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5",
    "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6",
    "perm": {
        "patterns": nil,
        "role": "Read,Write"
    }
}
'
# or
cql grant '
{
    "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5",
    "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6",
    "perm": "Read,Write"
}
'
```

将 `pattern` 设置为 `nil` 或直接设置用户权限，都可以将用户的白名单限制去掉，设置回可以查询所有内容的读权限。

### 子命令 `create` 完整参数

```bash
usage: cql create [-config file] [-wait-tx-confirm] db_meta_json

为当前账号创建数据库实例，输入参数为 JSON 格式的创建交易数据，其中节点数 node 为必带字段。
示例：
    cql create '{"node": 2}'

完整的 db_meta_json 字段解释如下：
    targetminers           []string // 目标节点的账号地址
    node                   int      // 目标节点数
    space                  int      // 需要的硬盘空间，0 为任意
    memory                 int      // 需要的内存空间，0 为任意
    loadavgpercpu          float    // 需要的 CPU 资源占用，0 为任意
    encryptionkey          string   // 落盘加密密钥
    useeventualconsistency bool     // 各个数据库节点之间是否使用最终一致性同步
    consistencylevel       float    // 一致性级别，通过 node*consistencylevel 得到强同步的节点数
    isolationlevel         int      // 单个节点上的隔离级别，默认级别为线性级别

由于 CovenantSQL 是区块链上的数据库，在真正访问数据库之前你可能需要等待创建请求的执行确认以及在数据库节点上的实际创建。
示例：
    cql create -wait-tx-confirm '{"node": 2}'

Params:
  -wait-tx-confirm
        等待交易执行确认（或者出现任何错误）后再退出
```

### 子命令 `drop` 完整参数

```bash
usage: cql drop [-config file] [-wait-tx-confirm] dsn/dbid

通过数据库的连接字符串或账号地址来删除数据库。
示例：
    cql drop the_dsn_of_your_database

由于 CovenantSQL 是区块链上的数据库，在删除操作生效之前你可能需要等待删除请求的执行确认以及在数据库节点上的实际执行。
示例：
    cql drop -wait-tx-confirm the_dsn_of_your_database

Params:
  -wait-tx-confirm
        等待交易执行确认（或者出现任何错误）后再退出
```

### 子命令 `grant` 完整参数

```bash
usage: cql grant [-config file] [-wait-tx-confirm] permission_meta_json

为指定账号进行数据库权限授权。
示例：
    cql grant '{"chain": "your_chain_addr", "user": "user_addr", "perm": "perm_struct"}'

由于 CovenantSQL 是区块链上的数据库，在授权操作生效之前你可能需要等待授权请求的执行确认以及在数据库节点上的实际更新。
示例
    cql grant -wait-tx-confirm '{"chain": "your_chain_addr", "user": "user_addr", "perm": "perm_struct"}'

Params:
  -wait-tx-confirm
        等待交易执行确认（或者出现任何错误）后再退出
```

## 访问数据库

完成数据库的创建后，就可以使用 `console` 子命令来对数据库进行交互式的命令行访问了：

```bash
cql console -dsn 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

输出

```bash
Enter master key(press Enter for default: ""): 

INFO[0010] init config success                           path=/home/levente/.cql/config.yaml
INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
Connected with driver covenantsql (develop-34ae741a-20190416184528)
Type "help" for help.

co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>
```

或者使用以授权的账号来连接：

```bash
cql console -config "account2/config.yaml" -dsn 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

输出

```bash
Enter master key(press Enter for default: ""): 

INFO[0010] init config success                           path=/home/levente/.config/cql/account2/config.yaml
INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
Connected with driver covenantsql (develop-34ae741a-20190416184528)
Type "help" for help.

co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>
```

交互式访问示例：

```bash
co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> create table t1 (c1 int);
CREATE TABLE
co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> insert into t1 values (1), (2), (3);
INSERT
co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> select * from t1;
c1
----
1
2
3
(3 rows)

co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> 
```

### 子命令 `console` 完整参数

子命令 `console` 同时也支持在后台启动 `adapter` 和 `explorer` 服务，关于这些服务的相关说明请参考 [本地服务](#本地服务) 的相关章节。

```bash
usage: cql console [-config file] [-dsn dsn_string] [-command sqlcommand] [-file filename] [-out outputfile] [-no-rc true/false] [-single-transaction] [-variable variables] [-explorer explorer_addr] [-adapter adapter_addr]

为 CovenantSQL 运行交互式的命令行访问。
示例：
    cql console -dsn the_dsn_of_your_database

另外也可以通过 -command 参数来直接运行 SQL 查询语句或通过 -file 参数来从文件读取查询语句。
在指定了这些参数的情况下 `console` 子命令将会直接执行命令后退出，而不会进入交互式的命令行模式。
示例：
    cql console -dsn the_dsn_of_your_database -command "create table test1(test2 int);"

Params:
  -adapter string
        指定数据库子链的 adapter 服务器的监听地址
  -command string
        执行单条 SQL 语句并退出
  -dsn string
        数据库连接字符串
  -explorer string
        指定数据库子链的 explorer 服务器监听地址
  -file string
        执行 SQL 脚本中的语句并退出
  -no-rc
        启动时不加载 .rc 初始脚本
  -out string
        指定输出文件
  -single-transaction
        在非交互模式下使用单个事务执行所有语句
  -variable value
        设置环境变量
```

## 本地服务

### 子命令 `explorer` 完整参数

```bash
usage: cql explorer [-config file] [-tmp-path path] [-bg-log-level level] address

为数据库子链运行 adapter 服务器。
示例：
    cql explorer 127.0.0.1:8546

Params:
  -bg-log-level string
        后台服务日志级别
  -tmp-path string
        后台服务使用的临时目录，默认使用系统的默认临时文件路径
```

### 子命令 `mirror` 完整参数

```bash
usage: cql mirror [-config file] [-tmp-path path] [-bg-log-level level] dsn/dbid address

为数据库子链运行 mirror 服务器。
示例：
    cql mirror database_id 127.0.0.1:9389

Params:
  -bg-log-level string
        后台服务日志级别
  -tmp-path string
        后台服务使用的临时目录，默认使用系统的默认临时文件路径
```

### 子命令 `adapter` 完整参数

关于 `adapter` 服务的说明请参考 <adapter>。

```bash
usage: cql adapter [-config file] [-tmp-path path] [-bg-log-level level] [-mirror addr] address

为数据库子链运行 adapter 服务器。
示例：
    cql adapter 127.0.0.1:7784

Params:
  -bg-log-level string
        后台服务日志级别
  -mirror string
        指定镜像 adapter 服务器地址
  -tmp-path string
        后台服务使用的临时目录，默认使用系统的默认临时文件路径
```

## 高级使用

子命令 `rpc` 直接在 CovenantSQL 网络上进行 RPC 调用。

### 子命令 `rpc` 完整参数

```bash
usage: cql rpc [-config file] [-wait-tx-confirm] -name rpc_name -endpoint rpc_endpoint -req rpc_request

向目标服务器发送 RPC 请求。
示例：
    cql rpc -name 'MCC.QuerySQLChainProfile' \
            -endpoint 000000fd2c8f68d54d55d97d0ad06c6c0d91104e4e51a7247f3629cc2a0127cf \
            -req '{"DBID": "c8328272ba9377acdf1ee8e73b17f2b0f7430c798141080d0282195507eb94e7"}'

Params:
  -endpoint string
        目标 RPC Node ID
  -name string
        目标 RPC 服务.方法名
  -req string
        RPC 请求数据，JSON 格式
  -wait-tx-confirm
        等待交易执行确认（或者出现任何错误）后再退出
```