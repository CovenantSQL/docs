---
id: cql
title: 🖥️ CQL 命令行工具
---

## 简介

本文将介绍如何使用 `cql` 进行查询、转账和数据库权限管理。在使用 `cql` 前请先确认已接入 [CovenantSQL TestNet](quickstart) 或者在本地使用 [Docker 一键部署](development)的网络。

## 查询余额

查询余额有两个命令：`cql -get-balance` 和 `cql -token-balance <token_type>`。其中 `-get-balance` 将返回用户账户中 `Particle` 与 `Wave` 的数量，`-token-balance <token_type>` 将返回用户账户中特定 `token_type` 的 token 数量。目前系统支持的 `token_type` 有：

- `Particle`
- `Wave`
- `Bitcoin`
- `Ether`
- `EOS`

查看默认余额：

```bash
./cql -config conf/config.yaml -get-balance
```

输出：

```
INFO[0000] Particle balance is: 10000000000000000000
INFO[0000] Wave balance is: 10000000000000000000
```

查看 Particle 余额：

```bash
./cql -config conf/config.yaml -token-balance Particle
```

输出：

```
INFO[0000] Particle balance is: 10000000000000000000
```

查看 Bitcoin 余额：

```bash
./cql -config conf/config.yaml -token-balance Bitcoin
```

输出：

```
INFO[0000] Bitcoin balance is: 0
```

## 转账

转账操作使用 `cql -transfer` 并以 `json` 格式的转账信息为参数。

```json
{
   "addr":"011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", // 收款地址
   "amount":"1000000 Particle" // 转账金额并带上单位
}
```

其中收款地址可以是一个个人钱包地址也可以是一个数据库子链地址。转账至数据库地址时将在该数据库账户上补充付款人的押金与预付款。

转账 Particle：

```bash
./cql -config conf/config.yaml -transfer '{"addr":"011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6","amount":"1000000 Particle"}'
```

输出：

```
INFO[0000] succeed in sending transaction to CovenantSQL
```

转账 Wave：

```bash
./cql -config conf/config.yaml -transfer '{"addr":"011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6","amount":"1000000 Wave"}'
```

```
INFO[0000] succeed in sending transaction to CovenantSQL
```

查看余额： 

```bash
./cql -config conf/config.yaml -get-balance
```

输出：

```
INFO[0000] Particle balance is: 9999999999999000000
INFO[0000] Wave balance is: 9999999999999000000
```

注意，`succeed in sending transaction to CovenantSQL` 只说明交易已成功发送至主网，交易能否成功、何时成功需要通过 `-get-balance` 或者 `-token-balance <token_type>` 确定。

## 数据库权限管理

CovenantSQL 数据库有三类库级别权限：

- `Admin`
- `Write`
- `Read`
- `Void`

其中，`Admin` 可以赋予其他钱包地址数据库的权限（`Admin`、`Write` 或 `Read`）；`Admin` 和 `Write` 可以对数据库进行写操作（`CREATE`, `INSERT` 等）；`Admin`, `Write` 和 `Read` 可以对数据库进行读操作（`SHOW`, `SELECT` 等）；`Void` 是一个特殊的权限，当 `Admin` 想取消某个地址的权限时可以将该地址的权限设置为 `Void`，这样该地址将无法继续读写数据库。创建数据库的地址的权限默认为 `Admin`。若 `Admin` 需要赋予他人权限请使用 `cql -update-perm` 并以 `json` 格式的权限信息为参数：

```json
{
   "chain":"4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5", // 需要进行权限变更的数据库地址
   "user":"011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", // 需要赋予权限的钱包地址
   "perm":"Write" // 权限内容
}
```

增加写权限：

```bash
./cql -config conf/config.yaml -update-perm '{"chain":"4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5","user":"011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6","perm":"Write"}'
```

输出：

```
INFO[0000] succeed in sending transaction to CovenantSQL
```

吊销权限：

```bash
./cql -config conf/config.yaml -update-perm '{"chain":"4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5","user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6","perm":"Void"}'
```

输出：

```
INFO[0000] succeed in sending transaction to CovenantSQL
```

注意，`succeed in sending transaction to CovenantSQL` 只说明交易已成功发送至主网，交易成功与否请通过查询数据库确认。

为数据库添加新的账户权限后账户需补充押金与预付款才能进行正常查询。押金计算方法：`gas_price*number_of_miner*60000`。
