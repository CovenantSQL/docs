---
id: version-0.5.0-cql_db_access
title: Accessing Database
original_id: cql_db_access
---

Once your database is successfully created, you can use the `console` sub-command to access it in an interactive console:

```bash
cql console -dsn 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

Output:

    Enter master key(press Enter for default: ""): 

    INFO[0010] init config success                           path=/home/levente/.cql/config.yaml
    INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
    Connected with driver covenantsql (develop-34ae741a-20190416184528)
    Type "help" for help.

    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>

Or access as `account2` if it has successfully been granted access permission:

```bash
cql console -config "account2/config.yaml" -dsn 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

Output:

    Enter master key(press Enter for default: ""): 

    INFO[0010] init config success                           path=/home/levente/.config/cql/account2/config.yaml
    INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
    Connected with driver covenantsql (develop-34ae741a-20190416184528)
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

    usage: cql console [parameter]...

    Console command can run a interactive SQL console for CovenantSQL
    e.g.
        cql console -dsn covenantsql://the_dsn_of_your_database

    There is also a -command param for SQL script, and a -file param for reading SQL in a file.
    If those params are set, it will run SQL script and exit without staying console mode.
    e.g.
        cql console -dsn covenantsql://the_dsn_of_your_database -command "create table test1(test2 int);"

    Params:
      -adapter string
            Address to serve a database chain adapter, e.g.:7784
      -command string
            Run only single command (SQL or usql internal command) and exit
      -dsn string
            Database url
      -explorer string
            Address to serve a database chain explorer, e.g.:8546
      -file string
            Execute commands from file and exit
      -no-rc
            Do not read startup file
      -out string
            Record stdout to file
      -single-transaction
            Execute as a single transaction (if non-interactive)
      -variable value
            Set variable

