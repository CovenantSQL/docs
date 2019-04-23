---
id: version-0.5.0-arch_secure_gateway
title: Secure Gateway
original_id: arch_secure_gateway
---

## SecureGateway

CQL SecureGateway (CGS) is currently only available to enterprise users. If you have in-depth understanding or trial requirements, please [contact us](mailto:info@covenantsql.io).

### Architecture

![CovenantSQL.SecureGateway](https://github.com/CovenantSQL/docs/raw/master/website/static/img/CovenantSQL.SecureGateway.png)

### API

CGS uses the binary protocol of MySQL 5.x, and all language drivers compatible with MySQL 5.x can be used directly.

### ACL Config

Support for **User/User Group** and **Column/Column Group** combination authorization (columns are represented as **database.table.column** triples)

#### ACL Example

The settings are divided into two parts, `Group` and `Strategy`, as follows:

User Group

| User  | Group          |
| ----- | --------------- |
| user1 | admin,userGroup |
| user2 | admin,userGroup |
| user3 | userGroup       |

Column Group

| Column        |  Group   |
| ------------- | -------- |
| db1.tbl1.col2 | someCols |
| db1.tbl1.col3 | someCols |
| db1.tbl1.col4 | someCols |

Strategy

| User/Group | Column/Group   | Permission（Write/Read） |
| ----------- | ------------- | ------------------- |
| user1       | db1.tbl1.col1 | write               |
| user2       | db1.tbl1.col1 | read                |
| admin       | someCols      | read                |
| userGroup   | db1.tbl2.col1 | read                |
| userGroup   | db2.tbl1.*    | read                |

### Encryption Config

Support for configuring encryption settings in the form of fields & encryption keys (fields are represented as **database.table.field** triples)
Encryption/decryption is valid only if the user has permission to the field.
#### Example 

Keys

| Column        | Key |
| ------------- | ---- |
| db1.tbl1.col1 | key1 |
| db1.tbl1.col2 | key2 |
| db1.tbl1.col3 | key3 |
| db1.tbl2.col1 | key1 |
| db2.tbl1.col1 | key1 |

In conjunction with the configuration of `ACL` & `Keys` above, the access restrictions that are in effect are as follows:

Result

| database | table   | column | key | user permissions         |
| ------ | ---- | ---- | ---------- | ----------------------- |
| db1    | tbl1 | col1 | key1       | user1 write; user2 read |
| db1    | tbl1 | col2 | key2       | user1 read; user2 read  |
| db1    | tbl1 | col3 | key3       | user1 read; user2 read  |
| db1    | tbl1 | col4 |            | user1 read; user2 read  |
| db1    | tbl2 | col1 | key1       | userGroup read          |
| db2    | tbl1 | *    | key1       | userGroup read          |

