---
id: cql_db_access
title: 访问数据库
---

完成数据库的创建后，就可以使用 `console` 子命令来对数据库进行交互式的命令行访问了：

```bash
cql console -dsn 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

输出：

    Enter master key(press Enter for default: ""): 

    INFO[0010] init config success                           path=/home/levente/.cql/config.yaml
    INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
    Connected with driver covenantsql (develop-34ae741a-20190416184528)
    Type "help" for help.

    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>

或者使用以授权的账号来连接：

```bash
cql console -config "account2/config.yaml" -dsn 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

输出：

    Enter master key(press Enter for default: ""): 

    INFO[0010] init config success                           path=/home/levente/.config/cql/account2/config.yaml
    INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
    Connected with driver covenantsql (develop-34ae741a-20190416184528)
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

    usage: cql console [参数]...

    为 CovenantSQL 运行交互式的命令行访问。
    示例：
        cql console -dsn the_dsn_of_your_database

    另外也可以通过 -command 参数来直接运行 SQL 查询语句或通过 -file 参数来从文件读取查询语句。
    在指定了这些参数的情况下 `console` 子命令将会直接执行命令后退出，而不会进入交互式的命令行模式。
    示例：
        cql console -dsn the_dsn_of_your_database -command "create table test1(test2 int);"

    Params:
      -adapter string
            指定数据库子链的 adapter 服务器的监听地址
      -command string
            执行单条 SQL 语句并退出
      -dsn string
            数据库连接字符串
      -explorer string
            指定数据库子链的 explorer 服务器监听地址
      -file string
            执行 SQL 脚本中的语句并退出
      -no-rc
            启动时不加载 .rc 初始脚本
      -out string
            指定输出文件
      -single-transaction
            在非交互模式下使用单个事务执行所有语句
      -variable value
            设置环境变量

