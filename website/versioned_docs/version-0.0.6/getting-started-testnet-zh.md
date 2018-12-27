---
id: version-0.0.6-testnet
title: CovenantSQL 测试网快速入门
original_id: testnet
---

[CovenantSQL](https://github.com/CovenantSQL/CovenantSQL/blob/develop/README-zh.md) 是一个基于区块链技术的去中心化众筹式 SQL 数据库，并具备以下特点：

1. **SQL**: 支持 SQL-92 标准
2. **去中心化**: 基于独有的高效共识算法 DH-RPC 和 Kayak 实现的中心化
3. **隐私**: 通过加密和授权许可进行访问
4. **不可篡改**: CovenantSQL 中的查询历史记录是不可变且可跟踪的

我们相信 [在下一个互联网时代，每个人都应该有完整的**数据权利**](https://medium.com/@covenant_labs/covenantsql-the-sql-database-on-blockchain-db027aaf1e0e)

## 0. 下载 CovenantSQL 工具

在 [github](https://github.com/CovenantSQL/CovenantSQL/releases) 下载最新的发行版

## 1. 用 `cql-utils` 生成配置文件访问测试网

```bash
$ cql-utils -tool confgen
Generating key pair...
Enter master key(press Enter for default: ""):
⏎
Private key file: conf/private.key
Public key's hex: 02296ea73240dcd69d2b3f1fb754c8debdf68c62147488abb10165428667ec8cbd
Generated key pair.
Generating nonce...
nonce: {{731613648 0 0 0} 11 001ea9c8381c4e8bb875372df9e02cd74326cbec33ef6f5d4c6829fcbf5012e9}
node id: 001ea9c8381c4e8bb875372df9e02cd74326cbec33ef6f5d4c6829fcbf5012e9
Generated nonce.
Generating config file...
Generated nonce.
```

运行完成后，`cql-utils`会在 `./conf` 目录生成一个配置文件。

## 2. 用私钥生成钱包地址

私钥可以再上一步的`./conf`目录中找到，文件名为`private.key`

```bash
$ cql-utils -tool addrgen -private ./conf/private.key
Enter master key(default: ""):
⏎
wallet address: 4jXvNvPHKNPU8Sncz5u5F5WSGcgXmzC1g8RuAXTCJzLsbF9Dsf9
```
上述`4jXvNvPHKNPU8Sncz5u5F5WSGcgXmzC1g8RuAXTCJzLsbF9Dsf9`就是钱包地址
## 3. 在水龙头(Faucet)获取Particle(PTC)

水龙头(Faucet)的地址为: [CovenantSQL 测试网 Particle(PTC) 水龙头](https://testnet.covenantsql.io/)。

完成教程之后，用`cql`命令来检查钱包地址的余额：

```bash
$ cql -config conf/config.yaml -get-balance
INFO[0000] stable coin balance is: 100                   caller="main.go:246 main.main"
INFO[0000] covenant coin balance is: 0                   caller="main.go:247 main.main"
```

当看到**"stable coin balance is: 100"**时，表明余额已经为100。

如果您需要更多的PTC作为长期测试使用，请联系[webmaster@covenantsql.io](mailto:webmaster@covenantsql.io)。

对于有合作的商业伙伴，我们将直接发给您PTC。

## 4. 使用`CLI`创建数据库

```bash
$ cql -config conf/config.yaml -create 1
INFO[0000] the newly created database is: "covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872?use_follower=false&use_leader=true"
```

第一行命令中的`1`表示申请几个矿工为你的数据库服务。`covenantsql://...` 开头的这个字符串就是创建的数据库访问地址，在SDK和CLI命令中都需要用此地址，在整个区块链中找到这个数据库。

## 5. CLI和SDK的详细文档

创建好数据库后，您可以参考以下文档和示例，以便更快的使用CovenantSQL来开发应用。

- [CLI 文档](https://github.com/CovenantSQL/CovenantSQL/tree/develop/cmd/cql/README-zh.md)
- [SDK 文档](https://github.com/CovenantSQL/CovenantSQL/tree/develop/client/README-zh.md)
- [SDK 示例](https://github.com/CovenantSQL/CovenantSQL/tree/develop/client/_example)

## 6. SQLChain 浏览器

目前，测试网的数据库时不需要权限的。意味着您可以通过数据库的DSN(数据库访问地址)，在[SQLChain 浏览器](https://explorer.dbhub.org)中拿到所有的修改历史和区块信息。

更多的测试网技术支持，请访问:

> [TestNet 发行日志](https://github.com/CovenantSQL/CovenantSQL/wiki/Release-Notes-zh)
