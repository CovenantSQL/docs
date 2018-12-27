---
id: version-0.0.6-local-deployment
title: CovenantSQL 综述
original_id: local-deployment
---

# CovenantSQL 介绍

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

- **SQL接口**: 支持 SQL-92 标准，传统 App 几乎0修改即可变成 ĐApp
- **去中心化**: 基于独有的高效拜占庭容错共识算法 Kayak 实现的去中心化结构
- **不可篡改**: CovenantSQL 中的 Query 历史记录是可追溯的
- **隐私**:  如果 Bitcoin 是用户的钱包，那么 CovenantSQL 就是是用户的去中心化数据库

我们相信 [在下一个互联网时代，每个人都应该有完整的**数据权利**](https://medium.com/@covenant_labs/covenantsql-the-sql-database-on-blockchain-db027aaf1e0e)

## CovenantSQL 原理

CovenantSQL 是一个运行在 Internet 上的开放网络，主要有以下三种角色组成：

* 主链节点：
  * 通过去中心化的架构，DPoS 模式的共识机制对矿工和用户进行撮合、协调、仲裁
* 侧链矿工：
  * 所有人都可以通过运行 Covenant Miner 来提供数据库服务来赚取奖励
  * 通过 ETLS 传输层加密、应用层签名、落盘加密、端到端加密 保证用户数据隐私
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



# 安装 CovenantSQL 客户端

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

- [Go](./development-golang-client-zh.md)
- [Java](https://github.com/CovenantSQL/covenant-connector)
- [Python](https://github.com/CovenantSQL/python-driver)
- [Javascript（开发中）](https://github.com/CovenantSQL/cql.js)

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

- [Docker 一键部署 CovenantSQL 测试网](./getting-started-zh.md)

## CovenantSQL 联盟链解决方案

正在建设中，如需咨询请邮件至 webmaster@covenantsql.io。

#部署 CovenantSQL

## 使用 CovenantSQL Docker 部署

### 安装 Docker

需要在机器上安装 docker 和 docker-compose 来一键部署 CovenantSQL

Docker：https://docs.docker.com/install/

Docker-Compose：https://docs.docker.com/compose/install/

### 启动 Docker 容器

执行以下的命令在本地运行 CovenantSQL

```shell
git clone https://github.com/CovenantSQL/CovenantSQL
cd CovenantSQL
make docker
make start
```

后续的所有命令，工作目录默认都是在 clone 的 CovenantSQL 源码目录中，可以执行`export COVENANTSQL_ROOT=$PWD`存为环境变量

### 检查运行状态

```shell
docker-compose ps
```

确认所有组件都处于 `Up` 的状态

```shell
          Name                         Command               State                 Ports
------------------------------------------------------------------------------------------------------
covenantsql_adapter         ./docker-entry.sh                Up      0.0.0.0:11105->4661/tcp
covenantsql_bp_0            ./docker-entry.sh                Up      0.0.0.0:11099->4661/tcp
covenantsql_bp_1            ./docker-entry.sh                Up      0.0.0.0:11100->4661/tcp
covenantsql_bp_2            ./docker-entry.sh                Up      0.0.0.0:11101->4661/tcp
covenantsql_explorer        /bin/sh -c MAGIC_DOLLAR='$ ...   Up      0.0.0.0:11108->80/tcp
covenantsql_miner_0         ./docker-entry.sh                Up      0.0.0.0:11102->4661/tcp
covenantsql_miner_1         ./docker-entry.sh                Up      0.0.0.0:11103->4661/tcp
covenantsql_miner_2         ./docker-entry.sh                Up      0.0.0.0:11104->4661/tcp
covenantsql_mysql_adapter   ./docker-entry.sh -listen  ...   Up      4661/tcp, 0.0.0.0:11107->4664/tcp
covenantsql_observer        ./docker-entry.sh -listen  ...   Up      4661/tcp, 0.0.0.0:11106->4663/tcp
```

### SQLChain Explorer

我们在`:11108`端口提供了一个 SQLChain 的 Explorer 可以看到 SQL 语句在链上的情况

#操作 CovenantSQL

### 创建数据库

使用 `cql` 命令并使用 `create` 参数提供所需的数据库节点数量创建数据库实例，例如：创建一个单节点的数据库实例

```shell
cql -config config/config.yaml -create 1
```

>  修改 `create` 参数的值，可以创建运行在多节点上的实例，例如：创建两个节点的实例

```shell
cql -config config/config.yaml -create 2
```

命令会返回创建的数据库实例的连接串

```shell
covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
```

### 访问数据库

使用 `cql` 命令并使用 `dsn` 参数提供数据库实例的连接串进行数据库访问

 ```shell
cql -config config/config.yaml -dsn covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
 ```

会得到如下输出，并进入 `cql` 交互命令行模式

```shell
Connected with driver covenantsql (develop)
Type "help" for help.

co:0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4=>
```

`cql` 交互命令行模式的使用方法类似 `mysql` 命令，例如：创建一个名为 `test`  的表，查看数据库中的表，插入记录，查询结果

```sql
CREATE TABLE test (test TEXT);
SHOW TABLES;
INSERT INTO test VALUES("happy");
SELECT * FROM test;
```

会得到如下输出

```shell
co:0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4=> CREATE TABLE test (test TEXT);
CREATE TABLE
co:0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4=> SHOW TABLES;
 name
------
 test
(1 row)

co:0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4=> INSERT INTO test VALUES("happy");
INSERT
co:0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4=> SELECT * FROM test;
 test
-------
 happy
(1 row)

co:0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4=>
```

使用 `Ctrl + D` 快捷键或输入 `\q` 可以退出 `cql` 交互命令行

# 使用 CovenantSQL 开发 App

## Golang 使用  CovenantSQL

#### 简介

`CovenantSQL` 提供了 `Golang SDK` ，支持以 `Golang` App 以原生通讯协议的形式访问数据库实例，是当前性能最高的使用方法， `cql` 等工具也是基于 `Golang SDK` 进行开发的。

`Golang SDK` 遵守 `Golang` 标准的 `database/sql` 接口定义，能够使用常见的 `Golang ORM` 进行使用。

#### 兼容性

`Golang SDK` 目前只兼容 `1.10+` 的 Golang 版本。

#### 安装和使用

`Golang SDK` 的 import 地址是 `github.com/CovenantSQL/CovenantSQL/client`

可以执行 `go get` 命令进行安装

```shell
go get github.com/CovenantSQL/CovenantSQL/client
```

#### API 文档

https://godoc.org/github.com/CovenantSQL/CovenantSQL/client

#### 示例

```go
package main

import (
	"database/sql"
	"flag"

	"github.com/CovenantSQL/CovenantSQL/client"
	"github.com/CovenantSQL/CovenantSQL/utils/log"
)

func main() {
	log.SetLevel(log.DebugLevel)
	var config, password, dsn string

	flag.StringVar(&config, "config", "./conf/config.yaml", "config file path")
	flag.StringVar(&dsn, "dsn", "", "database url")
	flag.StringVar(&password, "password", "", "master key password for covenantsql")
	flag.Parse()

    // 使用节点配置文件初始化 Golang SDK
	err := client.Init(config, []byte(password))
	if err != nil {
		log.Fatal(err)
	}

    // 连接数据库实例
	db, err := sql.Open("covenantsql", dsn)
	if err != nil {
		log.Fatal(err)
	}

	Q := `DROP TABLE IF EXISTS cityPop;
		CREATE TABLE cityPop (
			ID INT,
			Name VARCHAR,
			CountryCode VARCHAR,
			District VARCHAR,
			Population INT
		);
		CREATE INDEX cityCountryCodeIndex ON cityPop ( CountryCode );

		DROP TABLE IF EXISTS countryGDP;
		CREATE TABLE countryGDP (
			 ID integer PRIMARY KEY,
			 CountryCode string NOT NULL,
			 GDP integer
		);
		CREATE INDEX countryCountryCodeIndex ON countryGDP ( CountryCode );`

    // 写入数据
    _, err = db.Exec(Q)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("\nExec:\n %s\n", Q)

	Q = `INSERT INTO countryGDP VALUES
			(0, "ZWE", 99999),(1, "CHN", 3000000000000),
			(2, "PSE", 321312313),(3, "JPN", 300000000);
		INSERT INTO cityPop VALUES (707,'Shenzhen','CHN','Guangzhou',99442);
		INSERT INTO cityPop VALUES (1074,'Shenzhen','CHN','Guangzhou',353632);
		INSERT INTO cityPop VALUES (1591,'Toyama','JPN','Toyama',325790);
		INSERT INTO cityPop VALUES (1649,'Takaoka','JPN','Toyama',174380);
		INSERT INTO cityPop VALUES (1762,'Takasago','JPN','Hyogo',97632);
		INSERT INTO cityPop VALUES (1763,'Fujimi','JPN','Saitama',96972);
		INSERT INTO cityPop VALUES (1764,'Urasoe','JPN','Okinawa',96002);
		INSERT INTO cityPop VALUES (1765,'Yonezawa','JPN','Yamagata',95592);
		INSERT INTO cityPop VALUES (1766,'Konan','JPN','Aichi',95521);
		INSERT INTO cityPop VALUES (1767,'Yamatokoriyama','JPN','Nara',95165);
		INSERT INTO cityPop VALUES (1768,'Maizuru','JPN','Kyoto',94784);
		INSERT INTO cityPop VALUES (1769,'Onomichi','JPN','Hiroshima',93756);
		INSERT INTO cityPop VALUES (1770,'Higashimatsuyama','JPN','Saitama',93342);
		INSERT INTO cityPop VALUES (2707,'Xai-Xai','MOZ','Gaza',99442);
		INSERT INTO cityPop VALUES (4074,'Gaza','PSE','Gaza',353632);
		INSERT INTO cityPop VALUES (4077,'Jabaliya','PSE','North Gaza',113901);`
	_, err = db.Exec(Q)
	if err != nil {
		log.Warn(err)
	}
	log.Printf("\nExec:\n %s\n", Q)

	Q = `SELECT * FROM cityPop
		WHERE District IN ("Shenzhen", "Balkh", "Gaza", "North Gaza")
		GROUP  BY cityPop.CountryCode
		ORDER  BY Population DESC
		LIMIT  10;`
    
    // 查询数据
	rows, err := db.Query(Q)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("\nExec:\n %s\n", Q)
	log.Println("ID	Name	CountryCode	District	Population")
	var ID, GDP, Population int
	var Name, CountryCode, District string
	var GDPPerson float64

	for rows.Next() {
		err = rows.Scan(&ID, &Name, &CountryCode, &District, &Population)
		if err != nil {
			log.Fatal(err)
		}

		log.Printf("%d	%s	%s	%s	%d", ID, Name, CountryCode, District, Population)
	}
	Q = `UPDATE countryGDP SET GDP = 1234567 WHERE CountryCode LIKE "CHN";
			UPDATE cityPop SET Population = 123456 WHERE CountryCode LIKE "CHN";
			REPLACE INTO countryGDP (ID, CountryCode, GDP) VALUES (77, "AFG", 11111111);`
	_, err = db.Exec(Q)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("\nExec:\n %s\n", Q)

	Q = `SELECT cityPop.ID,  cityPop.CountryCode, cityPop.District,
		countryGDP.GDP / cityPop.Population, countryGDP.GDP, cityPop.Population
		FROM   cityPop
       		LEFT JOIN countryGDP
            	  ON countryGDP.CountryCode = cityPop.CountryCode
		WHERE District IN ( "Shenzhen", "Balkh", "North Gaza", "Toyama", "Yonezawa") AND countryGDP.GDP > 0
		GROUP BY cityPop.CountryCode
		ORDER BY countryGDP.GDP / cityPop.Population DESC
		LIMIT 10;`
	rows, err = db.Query(Q)
	log.Printf("\nExec:\n %s\n", Q)

	log.Println("ID	CountryCode	District	GDPPerson	GDP	Population")
	for rows.Next() {
		err = rows.Scan(&ID, &CountryCode, &District, &GDPPerson, &GDP, &Population)
		if err != nil {
			log.Fatal(err)
		}

		log.Printf("%d	%s	%s	%f	%d	%d",
			ID, CountryCode, District, GDPPerson, GDP, Population)
	}
}
```




# CovenantSQL API



# 常见问题解答

补充