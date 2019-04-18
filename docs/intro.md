---
id: intro
title: CovenantSQL Intro
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


CovenantSQL 是应用区块链技术构建的去中心化 SQL 云数据库，

结合了区块链、共享经济、分布式数据库的优势，保障了用户隐私及对数据的所有权。

CovenantSQL 具备以下特点：

- **SQL接口**: 支持 SQL-92 标准，传统 App 几乎0修改即可数据上链
- **去中心化**: 基于独有的高效拜占庭容错共识算法 Kayak 实现的去中心化结构
- **不可篡改**: CovenantSQL 中的 Query 历史记录是可追溯的
- **隐私**: 如果 Bitcoin 是人们的私人钱包，那么 CovenantSQL 就是是人们的去中心化的私密数据库

我们相信 [在下一个互联网时代，每个人都应该有完整的**数据权利**](https://medium.com/@covenant_labs/covenantsql-the-sql-database-on-blockchain-db027aaf1e0e)

## CovenantSQL 原理

CovenantSQL 是一个运行在 Internet 上的开放网络，主要有以下三种角色组成：

* 主链节点：
  * 通过去中心化的架构，DPoS 模式的共识机制对矿工和用户进行撮合、协调、仲裁
* 侧链矿工：
  * 所有人都可以通过运行 Covenant Miner 来提供数据库服务来赚取奖励
  * 通过 ETLS 传输层加密、应用层签名、落盘加密、端到端加密来保证用户数据隐私
* 数据库用户：
  * 用户通过一个私钥就可以创建指定数量节点的分布式数据库，存储自己的结构化数据
  * 数据矿工的分布和地址仅对数据库用户可见，防止用户数据被嗅探
  * 通过 **去中心化的高可用的架构** 和 **Miner 押金机制**，用户的数据可以在成本和可靠性、可用性上达到平衡可控


![CovenantSQL 3 Layer design](https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/develop/logo/arch.png)

- 第一层：**全局共识层**（主链，架构图中的中间环）:
  - 整个网络中只有一个主链。
  - 主要负责数据库矿工与用户的合同匹配，交易结算，反作弊，子链哈希锁定等全局共识事宜。
- 第二层：**SQL 共识层**（子链，架构图中的两边环）:
  - 每个数据库都有自己独立的子链。
  - 主要负责数据库各种事务的签名，交付和一致性。这里主要实现永久可追溯性的数据历史，并且在主链中执行哈希锁定。
- 第三层：**数据储存层**（支持 SQL-92 的数据库引擎）:
  - 每个数据库都有自己独立的分布式引擎。
  - 主要负责：数据库存储和加密；查询处理和签名；高效索引。
