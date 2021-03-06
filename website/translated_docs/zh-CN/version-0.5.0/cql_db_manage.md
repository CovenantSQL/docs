---
id: cql_db_manage
title: 数据库管理
---

## 创建数据库

创建数据库与 `transfer` 子命令类似使用 `json` 格式的输入参数，创建由一个节点组成的数据库：

```bash
cql create '{"node": 1}'
```

输出：

    Enter master key(press Enter for default: ""): 

    covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872

注意这里生成的 `covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872` 即为数据库的连接字符串（dsn），其中 `covenantsql` 为数据库协议字段，一般也可以缩写为 `cql`；`://` 后的十六进制串为数据库地址，可以在 `transfer` 子命令中作为收款地址使用。

子命令 `create` 通过向 BP 发起交易实现，所以也支持 `wait-tx-confirm` 参数。

关于子命令 `create` 输入参数的完整说明，请参见[完整参数](#子命令-create-完整参数)。

## 计费规则

CovenantSQL 数据库采用与[以太坊](https://www.ethos.io/what-is-ethereum-gas/)类似的 `Gas` 计费方式，`Gas` 与稳定代币 `Particle` 的换算单位（即 `Gas Price`）在创建时指定，对应的字段为 `gas-price`。如果未指定，则默认设置为 1。另一个与计费相关的字段是预付款 `advance-payment`，用于进行押金抵扣及后续查询计费，默认值为 20,000,000。例如：

```bash
cql create '{"node": 2, "gas-price": 5, "advance-payment": 500000000}'
```

则可以创建 `gas-price` 为 5，预付款为 500,000,000 的数据库。在矿机资源紧缺时，设置更高的 `gas-price` 有助于创建请求被更快地被响应，但是也会消耗更多的代币。

> 目前暂时还只支持使用 CovenantSQL 的稳定代币 Particle 来进行计费，未来将会陆续支持其他币种。

进行数据库查询时具体扣费逻辑如下：

- 对于读查询，消耗的 `Gas` 为返回的行数 `rows_count`
- 对于写查询，消耗的 `Gas` 为结果中的 `affected_rows`
- SQLChain 根据配置进行周期性结算上报总 `Gas` 消耗到主链，主链验证成功后从预付款中扣除 `Gas` * `Gas Price` 的代币

## ~~删除数据库~~

~~未实现。~~

## 数据库权限管理

### 访问权限

CovenantSQL 数据库有三类库级别权限：

- `Admin`
- `Write`
- `Read`
- `Void` (没有访问权限)

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

    INFO[0000] succeed in sending transaction to CovenantSQL

吊销权限：

```bash
cql grant '{"chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5", "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", "perm": "Void"}'
```

输出：

    INFO[0000] succeed in sending transaction to CovenantSQL

子命令 `grant` 通过向 BP 发起交易实现，所以也支持 `wait-tx-confirm` 参数。

由于目前每个数据库实例分别为每个用户独立计费，所以为数据库添加新的账户权限后，需要以新账户身份向该数据库转押金与预付款才能进行正常查询。押金与预付款最小值的计算公式：`gas_price*number_of_miner*120000`。

使用新账户给数据库充值：

```bash
cql -config "account2/config.yaml" transfer '{"addr": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5","amount": "90000000 Particle"}'
```

### SQL 白名单

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
 or
cql grant '
{
    "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5",
    "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6",
    "perm": "Read,Write"
}
'
```

将 `pattern` 设置为 `nil` 或直接设置用户权限，都可以将用户的白名单限制去掉，设置回可以查询所有内容的读权限。

## 子命令 `create` 完整参数

    usage: cql create [通用参数] [-wait-tx-confirm] db_meta_json

    为当前账号创建数据库实例，输入参数为 JSON 格式的创建交易数据，其中节点数 node 为必带字段。
    示例：
        cql create '{"node": 2}'

    完整的 db_meta_json 字段解释如下：
        target-miners           []string    // 目标节点的账号地址
        node                    int         // 目标节点数
        space                   int         // 需要的硬盘空间，0 为任意
        memory                  int         // 需要的内存空间，0 为任意
        load-avg-per-cpu        float       // 需要的 CPU 资源占用，0 为任意
        encrypt-key             string      // 落盘加密密钥
        eventual-consistency    bool        // 各个数据库节点之间是否使用最终一致性同步
        consistency-level       float       // 一致性级别，通过 node*consistency_level 得到强同步的节点数
        isolation-level         int         // 单个节点上的隔离级别，默认级别为线性级别
        gas-price               int         // 创建数据库使用 Gas 单价，默认为 1 Particle
        advance-payment         int         // 创建数据库分配的预付款，会从创建者账户上扣除，默认为 20,000,000 Particles

    由于 CovenantSQL 是区块链上的数据库，在真正访问数据库之前你可能需要等待创建请求的执行确认以及在数据库节点上的实际创建。
    示例：
        cql create -wait-tx-confirm '{"node": 2}'

    Params:
      -wait-tx-confirm
            等待交易执行确认（或者出现任何错误）后再退出

## 子命令 `drop` 完整参数

    usage: cql drop [通用参数] [-wait-tx-confirm] dsn/dbid

    通过数据库的连接字符串或账号地址来删除数据库。
    示例：
        cql drop covenantsql://4119ef997dedc585bfbcfae00ab6b87b8486fab323a8e107ea1fd4fc4f7eba5c

    由于 CovenantSQL 是区块链上的数据库，在删除操作生效之前你可能需要等待删除请求的执行确认以及在数据库节点上的实际执行。
    示例：
        cql drop -wait-tx-confirm covenantsql://4119ef997dedc585bfbcfae00ab6b87b8486fab323a8e107ea1fd4fc4f7eba5c

    Params:
      -wait-tx-confirm
            等待交易执行确认（或者出现任何错误）后再退出

## 子命令 `grant` 完整参数

    usage: cql grant [通用参数] [-wait-tx-confirm] permission_meta_json

    为指定账号进行数据库权限授权。
    示例：
        cql grant '{"chain": "your_chain_addr", "user": "user_addr", "perm": "perm_struct"}'

    由于 CovenantSQL 是区块链上的数据库，在授权操作生效之前你可能需要等待授权请求的执行确认以及在数据库节点上的实际更新。
    示例：
        cql grant -wait-tx-confirm '{"chain": "your_chain_addr", "user": "user_addr", "perm": "perm_struct"}'

    Params:
      -wait-tx-confirm
            等待交易执行确认（或者出现任何错误）后再退出
