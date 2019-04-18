---
id: deployment
title: Docker Deploy
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
          Name                         Command               State                        Ports
---------------------------------------------------------------------------------------------------------------------
covenantsql_adapter         ./docker-entry.sh                Up      0.0.0.0:11105->4661/tcp
covenantsql_bp_0            ./docker-entry.sh                Up      0.0.0.0:11099->4661/tcp, 0.0.0.0:12099->4665/tcp
covenantsql_bp_1            ./docker-entry.sh                Up      0.0.0.0:11100->4661/tcp, 0.0.0.0:12100->4665/tcp
covenantsql_bp_2            ./docker-entry.sh                Up      0.0.0.0:11101->4661/tcp, 0.0.0.0:12101->4665/tcp
covenantsql_fn_0            ./docker-entry.sh -wsapi :8546   Up      4661/tcp, 0.0.0.0:11110->8546/tcp
covenantsql_miner_0         ./docker-entry.sh                Up      0.0.0.0:11102->4661/tcp, 0.0.0.0:12102->4665/tcp
covenantsql_miner_1         ./docker-entry.sh                Up      0.0.0.0:11103->4661/tcp, 0.0.0.0:12103->4665/tcp
covenantsql_miner_2         ./docker-entry.sh                Up      0.0.0.0:11104->4661/tcp, 0.0.0.0:12104->4665/tcp
covenantsql_mysql_adapter   ./docker-entry.sh -listen  ...   Up      4661/tcp, 0.0.0.0:11107->4664/tcp
covenantsql_observer        ./docker-entry.sh                Up      4661/tcp, 0.0.0.0:11108->80/tcp
```

## 操作 CovenantSQL

### 创建数据库

使用 `cql` 命令并使用 `create` 参数提供所需的数据库节点数量创建数据库实例，例如：创建一个单节点的数据库实例

```shell
docker exec -it covenantsql_adapter /app/cql create -config /app/node_adapter/config.yaml -no-password '{"node":1}'
```

>  修改 `create` 参数的值，可以创建运行在多节点上的实例，例如：创建两个节点的实例

```shell
docker exec -it covenantsql_adapter /app/cql create -config /app/node_adapter/config.yaml -no-password '{"node":2}'
```

命令会返回创建的数据库实例的连接串

```shell
covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5
```

### 访问数据库

使用 `cql` 命令并使用 `dsn` 参数提供数据库实例的连接串进行数据库访问

 ```shell
docker exec -it covenantsql_adapter /app/cql console -config /app/node_adapter/config.yaml -no-password -dsn covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5
 ```

会得到如下输出，并进入 `cql` 交互命令行模式

```shell
Connected with driver covenantsql (develop-34ae741a-20190415135520)
Type "help" for help.

co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>
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
co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> CREATE TABLE test (test TEXT);
CREATE TABLE
co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> SHOW TABLES;
 name
------
 test
(1 row)

co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> INSERT INTO test VALUES("happy");
INSERT
co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> SELECT * FROM test;
 test
-------
 happy
(1 row)

co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>
```

使用 `Ctrl + D` 快捷键或输入 `\q` 可以退出 `cql` 交互命令行

### SQLChain Observer

镜像中的 Observer 角色使用了和 mysql-adapter 镜像中相同的 private.key ，故可以免去新账户授权和转账的过程制。

（关于权限管理的详细说明请参考[数据库权限管理](cql.md#数据库权限管理)）

#### 在浏览器使用 SQLChain Observer

我们在 `127.0.0.1:11108` 端口提供了一个 SQLChain 的 Observer 可以看到 SQL 语句在链上的情况。
