---
id: intro
title: CovenantSQL 介绍
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
    <a href="https://formulae.brew.sh/formula/cql">
        <img src="https://img.shields.io/homebrew/v/cql.svg?color=blue&label=brew%20install%20cql"
            alt="homebrew"></a>
</p>


CovenantSQL(CQL) 是一个运行在公网上的 SQL 数据库，并具有 GDPR 合规与去中心化等特点。


- **ServerLess 支持**: 为小程序、浏览器插件提供免部署维护，自动同步、高可用的数据库服务
- **SQL 接口**: 支持 SQL-92 标准
- **去中心化**: 基于共识算法 DH-RPC & Kayak 实现的去中心化
- **不可篡改**: CQL 中的 Query 历史是不可篡改且可追溯的
- **隐私**: 使用列级 ACL 和 SQL 白名单模式授予权限
- **权限**：列级别的权限限制，可以设定 SQL 白名单

我们坚信 [在下一个互联网时代，每个人都应该有完整的**数据权利**](https://medium.com/@covenant_labs/covenantsql-the-sql-database-on-blockchain-db027aaf1e0e)

**一行代码让数据上链**

```go
sql.Open("cql", dbURI)
```

## CQL 是什么?

- [Amazon QLDB](https://aws.amazon.com/qldb/)的开源版
- 如果 [filecoin](https://filecoin.io/) + [IPFS](https://ipfs.io/) 是去中心化的文件系统, 那么 CQL 就是去中心化的数据库