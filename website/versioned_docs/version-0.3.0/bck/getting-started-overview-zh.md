---
id: version-0.3.0-intro
title: 简介
original_id: intro
---

<p align="center">
    <img src="https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/develop/logo/covenantsql_horizontal.png" height="auto" width="100%">
</p>
<p align="center">
    <a href="https://goreportcard.com/report/github.com/CovenantSQL/CovenantSQL">
        <img src="https://goreportcard.com/badge/github.com/CovenantSQL/CovenantSQL?style=flat-square"
            alt="Go Report Card"></a>
    <a href="https://codecov.io/gh/CovenantSQL/CovenantSQL">
        <img src="https://codecov.io/gh/CovenantSQL/CovenantSQL/branch/develop/graph/badge.svg"
            alt="Coverage"></a>
    <a href="https://travis-ci.org/CovenantSQL/CovenantSQL">
        <img src="https://travis-ci.org/CovenantSQL/CovenantSQL.png?branch=develop"
            alt="Build Status"/></a>
    <a href="https://opensource.org/licenses/Apache-2.0">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg"
            alt="License"></a>
    <a href="https://godoc.org/github.com/CovenantSQL/CovenantSQL">
        <img src="https://img.shields.io/badge/godoc-reference-blue.svg"
            alt="GoDoc"></a>
    <a href="https://twitter.com/intent/follow?screen_name=CovenantLabs">
        <img src="https://img.shields.io/twitter/url/https/twitter.com/fold_left.svg?style=social&label=Follow%20%40CovenantLabs"
            alt="follow on Twitter"></a>
    <a href="https://gitter.im/CovenantSQL/CovenantSQL?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">
        <img src="https://badges.gitter.im/CovenantSQL/CovenantSQL.svg"
            alt="Join the chat at https://gitter.im/CovenantSQL/CovenantSQL"></a>
</p>


CovenantSQL 是一个基于区块链技术的去中心化众筹式 SQL 数据库，并具备以下特点：

- **SQL**: 支持 SQL-92 标准
- **去中心化**: 基于独有的高效共识算法 DH-RPC 和 Kayak 实现的中心化
- **隐私**: 通过加密和授权许可进行访问
- **不可篡改**: CovenantSQL 中的查询历史记录是不可变且可跟踪的

我们相信[在下一个互联网时代，每个人都应该有完整的**数据权利**](https://medium.com/@covenant_labs/covenantsql-the-sql-database-on-blockchain-db027aaf1e0e)

#### 一行代码接入区块链数据
```go
sql.Open("CovenantSQL", dbURI)
```

##

![CovenantSQL 3 Layer design](https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/develop/logo/arch.png)

- 第一层: **全局共识层**(主链，架构图中的中间环):
    - 整个网络中只有一个主链。
    - 主要负责数据库矿工与用户的合同匹配，交易结算，反作弊，子链哈希锁定等全局共识事宜。
- 第二层: **SQL 共识层**(子链，架构图中的两边环):
    - 每个数据库都有自己独立的子链。
    - 主要负责数据库各种事务的签名，交付和一致性。这里主要实现永久可追溯性的数据历史，并且在主链中执行哈希锁定。
- 第三层: **数据储存层**(支持 SQL-92 的数据库引擎):
    - 每个数据库都有自己独立的分布式引擎。
    - 主要负责：数据库存储和加密；查询处理和签名；高效索引。

