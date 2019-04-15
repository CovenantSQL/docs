---
id: deployment
title: '🐳 Docker one-line deployment'
---
## Deploy with CovenantSQL Docker

### Install Docker

You need to install docker and docker-compose on your machine to deploy CovenantSQL.

Docker：https://docs.docker.com/install/

Docker-Compose：https://docs.docker.com/compose/install/

### Download project

```bash
git clone https://github.com/CovenantSQL/CovenantSQL
cd CovenantSQL
```

For all subsequent commands, the working directory is by default in the cloned CovenantSQL root directory, which can be saved as an environment variable:

```bash
export COVENANTSQL_ROOT=$PWD
```

### Start Docker container

There are now two ways to start the CovenantSQL container:

1. Use a public image on Docker Hub
2. Build a CovenantSQL Docker image

> We recommend that regular users test CovenantSQL in the first way, and the second is only used to experience the latest development features.

#### 1. Use a public image on Docker Hub

Then start directly:

```bash
make start
```

#### 2. Build a CovenantSQL Docker image

Run CovenantSQL locally by executing the following command

```bash
make docker # compile a new image from source files
make start
```

### Check running status

Check the container status:

```bash
docker-compose ps
```

Confirm that all components are in the `Up` state

```shell
          Name                         Command               State                 Ports
------------------------------------------------------------------------------------------------------
covenantsql_bp_0            "./docker-entry.sh"              Up        0.0.0.0:11099->4661/tcp
covenantsql_bp_1            "./docker-entry.sh"              Up        0.0.0.0:11100->4661/tcp
covenantsql_bp_2            "./docker-entry.sh"              Up        0.0.0.0:11101->4661/tcp
covenantsql_miner_0         "./docker-entry.sh"              Up        0.0.0.0:11102->4661/tcp
covenantsql_miner_1         "./docker-entry.sh"              Up        0.0.0.0:11103->4661/tcp
covenantsql_miner_2         "./docker-entry.sh"              Up        0.0.0.0:11104->4661/tcp
covenantsql_adapter         "./docker-entry.sh"              Up        0.0.0.0:11105->4661/tcp
covenantsql_mysql_adapter   "./docker-entry.sh -…"           Up        4661/tcp, 0.0.0.0:11107->4664/tcp
covenantsql_observer        "./docker-entry.sh"              Up        4661/tcp, 0.0.0.0:11108->80/tcp
covenantsql_fn_0            "./docker-entry.sh -…"           Up        4661/tcp, 0.0.0.0:11110->8546/tcp
```

## Operate CovenantSQL

### Create a database

Create a DB instance by using the `cql` command and using the `create` parameter to provide the required number of database nodes.

e.g.: creating a single-node database instance

```shell
docker exec -it covenantsql_adapter /app/cql create -config /app/config.yaml -no-password '{"node":1}'
```

> Modify the value of the `create` parameter to create an instance running on multiple nodes  
> e.g.: create an instance of two nodes

```shell
docker exec -it covenantsql_adapter /app/cql create -config /app/config.yaml -no-password '{"node":1}'
```

The command will return the connection string of the created database instance

```shell
covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
```

### Accessing the database

Use the `cql` command and use the `dsn` parameter to provide a connection string for the database instance access:

```shell
docker exec -it covenantsql_adapter /app/cql console -config /app/config.yaml -no-password -dsn covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
 ```

After that, it will get the following output, and enter the `cql` interactive command line mode

```shell
Connected with driver covenantsql (develop)
Type "help" for help.

co:0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4=>
```

The `cql` interactive command line mode is similar to the `mysql` command. For example, create a table named test, view the tables in the database, insert records, and query results etc.

```sql
CREATE TABLE test (test TEXT);
SHOW TABLES;
INSERT INTO test VALUES("happy");
SELECT * FROM test;
```

After that, it will get the following output:

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

Use the `Ctrl + D` shortcut or type `\q` to exit the `cql` interactive command line

### SQLChain Observer

The Observer role in the image uses the same private.key as in the mysql-adapter image, so the new account authorization and transfer process can be eliminated.

（For details on rights management, please refer to [Database Permission Managemen](cql.md#数据库权限管理)）

#### Use SQLChain Observer in your browser

We provide a SQLChain Observer at port `127.0.0.1:11108` to see the SQL statement on the chain.