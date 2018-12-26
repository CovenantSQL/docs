---
id: version-0.0.6-getting-started
title: CovenantSQL 一键开箱使用
original_id: getting-started
---

## 一键部署

### 安装 Docker

需要在机器上安装 docker 和 docker-compose 来一键部署 CovenantSQL

Docker：https://docs.docker.com/install/

Docker-Compose：https://docs.docker.com/compose/install/

### 部署 CovenantSQL

执行以下的命令在本地运行 CovenantSQL

```shell
$ git clone https://github.com/CovenantSQL/CovenantSQL
$ cd CovenantSQL
$ make start
```

后续的所有命令，wd 都是在 clone 的 CovenantSQL 源码目录中

### 检查运行状态

```shell
$ docker-compose ps
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

## 使用 CovenantSQL

### 创建数据库

创建一个单节点的数据库实例，可以将 create 的参数调整为 2 或者最多至 3（当前一键部署只部署了 3 个miner 节点，只能支持最多 3 节点的实例）

```shell
$ docker cp covenantsql_bp_1:/app/cql ./
$ ./cql -config ./test/service/node_c/config.yaml -create 1
```

将会得到数据库的 dsn 串，当前示例是 `covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4`

```shell
INFO[0001] the newly created database is: "covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4"
```

### 使用 cql 命令行访问数据库

 ```shell
$ ./cql -config ./test/service/node_c/config.yaml -dsn covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
 ```

执行任何常见 SQL 命令（兼容 SQLite 语法 和 部分类似 MySQL 的 SHOW 语法）

```shell
INFO[0000] connecting to "covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4"
Connected with driver covenantsql (feature/kayakPerformance-a6e183ed-20181107003651)
Type "help" for help.

co:0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4=>
```

示例

```shell
co:0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4=> create table test (test string);
CREATE TABLE
co:0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4=> show tables;
 name
------
 test
(1 row)

co:0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4=> \q

$
```

## 使用 Java/Python Driver 操作 CovenantSQL

当前 Java/Python Driver 需要依赖  ```covenantsql_adapter``` 服务使用，使用前确保 `covenantsql_adapter` 服务运行正常

### Java JDBC Driver 使用

**需要使用 maven 编译 java-connector

```shell
$ git clone https://github.com/CovenantSQL/covenant-connector
$ cd covenant-connector/covenantsql-java-connector
$ mvn package -Dmaven.test.skip=true
```

编译后将会得到 3 个编译 jar 结果

```shell
$ ls -l target/*.jar
target/covenantsql-java-connector-1.0-SNAPSHOT-jar-with-dependencies.jar
target/covenantsql-java-connector-1.0-SNAPSHOT-shaded.jar
target/covenantsql-java-connector-1.0-SNAPSHOT.jar
```

Driver 提供了一个简单的 Example 测试

Example 源码在 `./src/main/java/io/covenantsql/connector/example/Example.java`

使用 dsn 串中的 host 部分 ```0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4``` 设置为 `COVENANTSQL_DATABASE` 这个 property 来测试 example

```shell
$ java -DCOVENANTSQL_DATABASE=0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4 -cp target/covenantsql-java-connector-1.0-SNAPSHOT-jar-with-dependencies.jar io.covenantsql.connector.example.Example
```

可以看到插入和查询的结果

```shell
[main] INFO io.covenantsql.connector.CovenantDriver - covenantsql driver registered
Build url: jdbc:covenantsql://127.0.0.1:11105/0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
Connecting to database...
Creating statement...
ID: 1, Email: Apple, Password: appleisdelicious, Time: 00:01:17
```

### Python Driver 使用

**当前支持 `python3` 下使用 Python Driver，`python2` 将会在兼容性测试后提供

Demo 依赖 `python3` 和 `pipenv`

Python3: https://www.python.org/download/releases/3.0/

Pipenv: https://github.com/pypa/pipenv

安装依赖完成后，clone demo 并安装依赖到 pipenv

```shell
$ git clone https://github.com/CovenantSQL/python-demos.git
$ cd python-demos
$ pipenv install
```

使用 dsn 串中的 host 部分 `0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4`设置为 `COVENANTSQL_DATABASE` env 变量来执行测试

`COVENANTSQL_ROOT` 环境变量为开始 clone 的 CovenantSQL 代码目录

```shell
$ pipenv shell
(python-demos-d0igWVYT) $ cd hello-covenantsql
(python-demos-d0igWVYT) $ chmod u+x main.py
(python-demos-d0igWVYT) $ COVENANTSQL_DATABASE=0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4 \
COVENANTSQL_PRIVATE_KEY=${COVENANTSQL_ROOT}/test/service/node_c/admin.test.covenantsql.io-key.pem \
COVENANTSQL_PROXY_PEM=${COVENANTSQL_ROOT}/test/service/node_c/admin.test.covenantsql.io.pem ./main.py
```

执行结果如下（因为使用了 Java JDBC Driver插入了一行数据，这里可以看到两行数据）

```shell
create table
insert sample data
affected rows: 1, lastrowid: 2
select data from the table
(1, '2018-11-07T16:01:17Z', 'Apple', 'appleisdelicious')
(2, '2018-11-07T16:10:29Z', 'Apple', 'appleisdelicious')
```

退出 pipenv

```shell
(python-demos-d0igWVYT) $ deactive
$
```

## 使用 MySQL Client（version <=5.7）操作 CovenantSQL

**当前只支持 version <=5.7 的 MySQL Client 访问，且依赖 `covenantsql_mysql_adapter` 服务使用，使用前确保 `covenantsql_mysql_adapter` 服务运行正常

```shell
$ mysql -h127.0.0.1 -P11107 -uroot -pcalvin -D0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
```

可以执行任何常见 SQL 命令进行测试

```shell
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10001
Server version: 5.7.0

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show tables;
+-----------------+
| name            |
+-----------------+
| test            |
| users           |
| sqlite_sequence |
+-----------------+
3 rows in set (0.02 sec)

mysql>
```
