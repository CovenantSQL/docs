---
id: deployment
title: 🐳 Docker 一键部署
---

## 使用 CovenantSQL Docker 部署

### 安装 Docker

需要在机器上安装 docker 和 docker-compose 来一键部署 CovenantSQL

Docker：https://docs.docker.com/install/

Docker-Compose：https://docs.docker.com/compose/install/

### 下载项目

```bash
git clone https://github.com/CovenantSQL/CovenantSQL
cd CovenantSQL
```

后续的所有命令，工作目录默认都是在 clone 的 CovenantSQL 源码目录中，可以执行

```bash
export COVENANTSQL_ROOT=$PWD
```

存为环境变量

### 启动 Docker 容器

现在有两种方式启动 CovenantSQL 容器：

1. 使用 Docker Hub 上的公共镜像
2. 构建 CovenantSQL Docker 镜像

> 我们推荐普通用户使用第一种方式测试 CovenantSQL，第二种仅用于体验最新的开发中的特性。

#### 1. 使用 Docker Hub 上的公共镜像

然后直接启动：

```bash
make start
```

#### 2. 构建 CovenantSQL Docker 镜像

执行以下的命令在本地运行 CovenantSQL

```bash
make docker # 从头编译新的镜像
make start
```

### 检查运行状态

检查容器状态：

```bash
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

## 操作 CovenantSQL

### 创建数据库

使用 `cql` 命令并使用 `create` 参数提供所需的数据库节点数量创建数据库实例，例如：创建一个单节点的数据库实例

```shell
docker exec -it covenantsql_adapter /app/cql -config /app/config.yaml -create 1
```

>  修改 `create` 参数的值，可以创建运行在多节点上的实例，例如：创建两个节点的实例

```shell
docker exec -it covenantsql_adapter /app/cql -config /app/config.yaml -create 2
```

命令会返回创建的数据库实例的连接串

```shell
covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
```

### 访问数据库

使用 `cql` 命令并使用 `dsn` 参数提供数据库实例的连接串进行数据库访问

 ```shell
docker exec -it covenantsql_adapter /app/cql -config /app/config.yaml -dsn covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
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

### SQLChain Explorer

由于读数据库需要计费，并且数据库有权限限制，在启动 Explorer 前需要确保 Explorer 使用的钱包地址内有充足的 token 并且已使用管理员账户为 Explorer 地址授权读权限。（关于权限管理的详细说明请参考[数据库权限管理](cql.md#数据库权限管理)）

**注意：**在授权前不要在浏览器打开 Explorer 地址。

获得转账地址：

```bash
docker exec -it covenantsql_observer /app/cql-utils -tool addrgen -private /app/node_observer/private.key
```

输出：

```bash
Enter master key(press Enter for default: ""):

wallet address: 6304a1bcc4a8903b1bc8675fd37a588040a55ade1f1df552ef7721a823ae1c25
```

转账：

```bash
docker exec -it covenantsql_adapter /app/cql -config /app/config.yaml -transfer '{"addr":"6304a1bcc4a8903b1bc8675fd37a588040a55ade1f1df552ef7721a823ae1c25","amount":"100000000 Particle"}'
```

其中，`addr` 表示转账地址，这里为 observer 地址，observer 地址可以在。`amount` 为能使 observer 运行的最小金额 `gas_price*number_of_miner*240000`，建议尽量转些方便后续操作。

授权：

```bash
docker exec -it covenantsql_adapter /app/cql -config /app/config.yaml -update-perm '{"chain":"139f71bb7b2775baafa42bd9ed2ade6755381d4eed1e02d4847eb1491847a0ce","user":"6304a1bcc4a8903b1bc8675fd37a588040a55ade1f1df552ef7721a823ae1c25","perm":"Read"}'
```

充值：

```bash
docker exec -it covenantsql_observer /app/cql -config /app/config.yaml -transfer '{"addr":"139f71bb7b2775baafa42bd9ed2ade6755381d4eed1e02d4847eb1491847a0ce","amount":"90000000 Particle"}'
```

关于转账充值与授权的详细说明请参考[文档](cql.md)。

### 在浏览器使用 SQLChain Explorer

我们在 `127.0.0.1:11108` 端口提供了一个 SQLChain 的 Explorer 可以看到 SQL 语句在链上的情况。