---
id: version-0.5.0-cql
title: 🖥️ CQL 命令行工具
original_id: cql
---

## 简介

本文将介绍如何使用 `cql` 进行查询、转账和数据库权限管理。在使用 `cql` 前请先确认已接入 [CovenantSQL TestNet](quickstart) 或者在本地使用 [Docker 一键部署](development)的网络。

### 配置文件
`cql`命令依赖配置文件`config.yaml`和私钥文件`private.key`。这两个文件如果使用`cql generate config`命令生成，会默认放在`~/.cql/`目录下。在此目录下时，`cql`所有子命令的`-config`参数均可以省略不填写。

### Master key
`private.key`文件在生成时需要输入密码，`cql`命令会自动请求输入master key (密码)。
如果想在脚本中使用，可以在子命令后面增加`-password your_master_key`，空密码时用`-no-password`参数。

## 查询余额

查询余额有两个命令：`cql balance` 和 `cql balance -token <token_type>`。其中不加`-token`参数将返回用户账户中 `Particle` 与 `Wave` 的数量，`-token <token_type>` 将返回用户账户中特定 `token_type` 的 token 数量。目前系统支持的 `token_type` 有：

- `Particle`
- `Wave`
- `Bitcoin`
- `Ether`
- `EOS`

查看默认余额：

```bash
./cql balance -config conf/config.yaml
```

输出：

```
INFO[0000] Particle balance is: 10000000000000000000
INFO[0000] Wave balance is: 10000000000000000000
```

查看 Particle 余额：

```bash
./cql balance -config conf/config.yaml -token Particle
```

输出：

```
INFO[0000] Particle balance is: 10000000000000000000
```

查看 Bitcoin 余额：

```bash
./cql balance -config conf/config.yaml -token Bitcoin
```

输出：

```
INFO[0000] Bitcoin balance is: 0
```

## 转账

转账操作使用 `cql transfer` 并以 `json` 格式的转账信息为参数。

```json
{
   "addr":"011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", // 收款地址
   "amount":"1000000 Particle" // 转账金额并带上单位
}
```

其中收款地址可以是一个个人钱包地址也可以是一个数据库子链地址。转账至数据库地址时将在该数据库账户上补充付款人的押金与预付款。

转账 Particle：

```bash
./cql transfer -config conf/config.yaml '{"addr":"011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6","amount":"1000000 Particle"}'
```

输出：

```
INFO[0000] succeed in sending transaction to CovenantSQL
```

转账 Wave：

```bash
./cql transfer -config conf/config.yaml '{"addr":"011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6","amount":"1000000 Wave"}'
```

```
INFO[0000] succeed in sending transaction to CovenantSQL
```

查看余额： 

```bash
./cql balance -config conf/config.yaml
```

输出：

```
INFO[0000] Particle balance is: 9999999999999000000
INFO[0000] Wave balance is: 9999999999999000000
```

注意，`succeed in sending transaction to CovenantSQL` 只说明交易已成功发送至主网，交易能否成功、何时成功需要通过 `cql balance` 或者 `cql balance -token <token_type>` 确定。

## 数据库权限管理

#### 访问权限

CovenantSQL 数据库有三类库级别权限：

- `Admin`
- `Write`
- `Read`
- `Void`

其中，`Admin` 可以赋予其他钱包地址数据库的权限（`Admin`、`Write` 或 `Read`）；`Admin` 和 `Write` 可以对数据库进行写操作（`CREATE`, `INSERT` 等）；`Admin` 和 `Read` 可以对数据库进行读操作（`SHOW`, `SELECT` 等）；如果需要设置用户有读写权限但是不能修改其他用户或自己的权限，可以将权限设置为 `Read,Write`；`Void` 是一个特殊的权限，当 `Admin` 想取消某个地址的权限时可以将该地址的权限设置为 `Void`，这样该地址将无法继续读写数据库。创建数据库的地址的权限默认为 `Admin`。若 `Admin` 需要赋予他人权限请使用 `cql grant` 并以 `json` 格式的权限信息为参数：

```json
{
   "chain":"4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5", // 需要进行权限变更的数据库地址
   "user":"011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", // 需要赋予权限的钱包地址
   "perm":"Write" // 权限内容
}
```

增加写权限：

```bash
./cql grant -config conf/config.yaml '{"chain":"4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5","user":"011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6","perm":"Write"}'
```

输出：

```
INFO[0000] succeed in sending transaction to CovenantSQL
```

吊销权限：

```bash
./cql grant -config conf/config.yaml '{"chain":"4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5","user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6","perm":"Void"}'
```

输出：

```
INFO[0000] succeed in sending transaction to CovenantSQL
```

注意，`succeed in sending transaction to CovenantSQL` 只说明交易已成功发送至主网，交易成功与否请通过查询数据库确认。

为数据库添加新的账户权限后账户需补充押金与预付款才能进行正常查询。押金与预付款最小值的计算公式：`gas_price*number_of_miner*120000`。

使用新账户给数据库充值：

```bash
./cql transfer -config new_user_config/config.yaml '{"addr":"4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5","amount":"90000000 Particle"}'
```

#### SQL 白名单

CovenantSQL 还支持给用户设置可执行的 SQL 白名单，可以限定用户以指定的 SQL Pattern 和可配的 Query 参数来访问数据库。在指定语句白名单的功能支持下，可以提高数据库的安全性，避免被单语句拖库或执行不正确的删除货更新操作。

增加白名单：

```shell
./cql -config conf/config.yaml -update-perm '
{
    "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5",
    "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6",
    "perm": {
        "patterns": [
            "SELECT COUNT(1) FROM a",
            "SELECT * FROM a WHERE id = ? LIMIT 1"
        ],
        "role": "Read"
    }
}
'
```

*白名单功能是基于数据库权限的一个扩展，且当前不支持增量的白名单更新，在设置白名单时需要写明所有授权该用户使用的语句，以及该用户对数据库的访问权限*

设置完成后，用户将只能执行 `SELECT COUNT(1) FROM a` 或 `SELECT * FROM a WHERE id = ? LIMIT 1` 的语句（语句内容严格匹配，使用 `select COUNT(1) FROM a` 或 `SELECT COUNT(1) FROM        a` 也不可以）；其中 第二条语句支持用户提供一个参数，以支持查询不同记录的目的。最终可以实现限定用户访问 `表 a`，并一次只能查询 `表 a` 中的一条数据或查询 `表 a`的 总数据量。

去掉白名单限制：

```shell
./cql -config conf/config.yaml -update-perm '
{
    "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5",
    "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6",
    "perm": {
        "patterns": nil,
        "role": "Read"
    }
}
'
# or
./cql -config conf/config.yaml -update-perm '
{
    "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5",
    "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6",
    "perm": "Read"
}
'
```

将 `pattern` 设置为 `nil` 或直接设置用户权限，都可以将用户的白名单限制去掉，设置回可以查询所有内容的读权限。

