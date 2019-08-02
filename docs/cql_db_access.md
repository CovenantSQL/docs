---
id: cql_db_access
title: Accessing Database
---

Once your database is successfully created, you can use the `console` sub-command to access it in an interactive console:

```bash
cql console 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

Output:

    INFO[0000] Geting bp address from dns: bp05.testnet.gridb.io
    INFO[0010] init config success                           path=~/.cql/config.yaml
    INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
    Connected with driver covenantsql (develop-da3af8f6-20190515152207)
    Type "help" for help.

    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>

Or access as `account2` (Should been granted access permission and transfered deposit token to the database successfully in last section):

```bash
cql console -config "account2/config.yaml" 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

Output:

    INFO[0000] Geting bp address from dns: bp05.testnet.gridb.io
    INFO[0010] init config success                           path=~/.config/cql/account2/config.yaml
    INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
    Connected with driver covenantsql (develop-da3af8f6-20190515152207)
    Type "help" for help.

    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>

Here is an example of using the interactive console:

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

## Sub-command `console` Complete Parameters

The sub-command `console` also supports running `adapter` or `explorer` servers in the background. Check [Local Servers](#local-servers) for details.

    usage: cql console [common params] [Console params] dsn

    Console runs an interactive SQL console for CovenantSQL.
    e.g.
        cql console covenantsql://4119ef997dedc585bfbcfae00ab6b87b8486fab323a8e107ea1fd4fc4f7eba5c

    There is also a -command param for SQL script, and you can add "< file.sql" at end of command for executing a SQL file.
    If those params are set, it will run SQL script and exit without staying console mode.
    e.g.
        cql console -command "create table test1(test2 int);" covenantsql://4119ef997dedc585bfbcfae00ab6b87b8486fab323a8e107ea1fd4fc4f7eba5c

    Console params:
      -adapter string
        	Address to serve a database chain adapter, e.g. :7784
      -command string
        	Run only single command (SQL or usql internal command) and exit
      -explorer string
        	Address serve a database chain explorer, e.g. :8546
      -out string
        	Record stdout to file
      -single-transaction
        	Execute as a single transaction (if non-interactive)
      -variable value
        	Set variable
