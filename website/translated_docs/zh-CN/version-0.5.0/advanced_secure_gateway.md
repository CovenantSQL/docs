---
id: advanced_secure_gateway
title: 数据库安全网关
---

### CQL SecureGateway 字段级加密/权限管理

CQL SecureGateway (CGS) 目前仅开放给部分企业用户使用，如有深入了解或者试用需求请[联系我们](mailto:info@covenantsql.io)。

#### 模块结构

![CovenantSQL.字段级加密.安全网关](https://github.com/CovenantSQL/docs/raw/master/website/static/img/CovenantSQL.SecureGateway.png)

#### 访问接口

CGS 使用的是 MySQL 5.x 的二进制协议，所有兼容 MySQL 5.x 的语言驱动都可以直接使用。

#### 权限设置

支持对 **用户/用户组** 和 **字段/字段组** 组合形式授权（字段表示为 **库.表.字段** 的三元组）

#### 示例配置

##### 权限

设置分为两个部分，分组 和 策略
分组如下

用户组

| 用户  | 用户组          |
| ----- | --------------- |
| user1 | admin,userGroup |
| user2 | admin,userGroup |
| user3 | userGroup       |

字段组

| 字段          | 字段组   |
| ------------- | -------- |
| db1.tbl1.col2 | someCols |
| db1.tbl1.col3 | someCols |
| db1.tbl1.col4 | someCols |

策略如下

| 用户/用户组 | 字段/字段组   | 权限点（写入/读取） |
| ----------- | ------------- | ------------------- |
| user1       | db1.tbl1.col1 | write               |
| user2       | db1.tbl1.col1 | read                |
| admin       | someCols      | read                |
| userGroup   | db1.tbl2.col1 | read                |
| userGroup   | db2.tbl1.*    | read                |

#### 加密设置

支持以 字段 & 加密密钥 的形式配置加密设置（字段表示为 **库.表.字段** 的三元组）
在用户对字段有权限的前提下，加密/解密才能继续进行。

#### 示例配置

##### 密钥

| 字段          | 密钥 |
| ------------- | ---- |
| db1.tbl1.col1 | key1 |
| db1.tbl1.col2 | key2 |
| db1.tbl1.col3 | key3 |
| db1.tbl2.col1 | key1 |
| db2.tbl1.col1 | key1 |

##### 效果

结合上面`权限` & `密钥`的配置，生效的访问限制如下：

| 数据库 | 表   | 字段 | 需要的密钥 | 可访问用户+权限         |
| ------ | ---- | ---- | ---------- | ----------------------- |
| db1    | tbl1 | col1 | key1       | user1 write; user2 read |
| db1    | tbl1 | col2 | key2       | user1 read; user2 read  |
| db1    | tbl1 | col3 | key3       | user1 read; user2 read  |
| db1    | tbl1 | col4 | 无         | user1 read; user2 read  |
| db1    | tbl2 | col1 | key1       | userGroup read          |
| db2    | tbl1 | *    | key1       | userGroup read          |

