---
id: cql_db_access
title: 访问数据库
---

完成数据库的创建后，就可以使用 `console` 子命令来对数据库进行交互式的命令行访问了：

```bash
cql console 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

输出：

    INFO[0000] Geting bp address from dns: bp05.testnet.gridb.io
    INFO[0010] init config success                           path=~/.cql/config.yaml
    INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
    Connected with driver covenantsql (develop-da3af8f6-20190515152207)
    Type "help" for help.

    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>

或者使用以授权的账号来连接 (需要完成上一节的授权和给数据库充值的操作)：

```bash
cql console -config "account2/config.yaml" 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

输出：

    INFO[0000] Geting bp address from dns: bp05.testnet.gridb.io
    INFO[0010] init config success                           path=~/.config/cql/account2/config.yaml
    INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
    Connected with driver covenantsql (develop-da3af8f6-20190515152207)
    Type "help" for help.

    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>

交互式访问示例：

    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> create table t1 (c1 int);
    CREATE TABLE
    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> insert into t1 values (1), (2), (3);
    INSERT
    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> select * from t1;
    c1
    ----
    1
    2
    3
    (3 rows)

    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> 

## 子命令 `console` 完整参数

子命令 `console` 同时也支持在后台启动 `adapter` 和 `explorer` 服务，关于这些服务的相关说明请参考 [本地服务](#本地服务) 的相关章节。

    usage: cql console [通用参数] [Console 参数] dsn

    为 CovenantSQL 运行交互式的命令行访问。
    示例：
        cql console covenantsql://4119ef997dedc585bfbcfae00ab6b87b8486fab323a8e107ea1fd4fc4f7eba5c

    另外也可以通过 -command 参数来直接运行 SQL 查询语句。或者通过文件重定向，如在命令最后加入 '< filename.sql' 来从文件读取SQL语句。
    在指定了这些参数的情况下 `console` 子命令将会直接执行命令后退出，而不会进入交互式的命令行模式。
    示例：
        cql console -command "create table test1(test2 int);" covenantsql://4119ef997dedc585bfbcfae00ab6b87b8486fab323a8e107ea1fd4fc4f7eba5c

    Console 参数:
      -adapter string
            指定数据库子链的 adapter 服务器的监听地址
      -command string
            执行单条 SQL 语句并退出
      -explorer string
            指定数据库子链的 explorer 服务器监听地址
      -out string
            指定输出文件
      -single-transaction
            在非交互模式下使用单个事务执行所有语句
      -variable value
            设置环境变量
