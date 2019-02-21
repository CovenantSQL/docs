---
id: version-0.3.0-Adapter
title: 📦 CovenantSQL Adapter SDK
original_id: Adapter
---

# 通过 Adapter 使用 CovenantSQL

## 简介

`CovenantSQL` 提供了 HTTP/HTTPS Adapter，类似于云数据库， 开发者可以直接用 HTTP 的形式使用 CovenantSQL。

## 安装和使用

首先，需要确认我们有一个可用的配置和公私钥对，通常我们默认的配置和公私钥对的存储位置为 `~/.cql/` 目录。生成或获取请参考 [QuickStart#创建账号](./quickstart#创建账号)

### Docker 运行 Adapter

下面的命令将使用`~/.cql/config.yaml` 和 `~/.cql/private.key` 启动 Adapter，并把端口映射在 `0.0.0.0:11105`

```bash
export adapter_addr=0.0.0.0:11105
docker rm -f cql-adapter
docker run -itd --env COVENANT_ROLE=adapter --env COVENANT_CONF=/app/config.yaml -v ~/.cql/config.yaml:/app/config.yaml -v ~/.cql/private.key:/app/private.key --name cql-adapter -p $adapter_addr:4661 covenantsql/covenantsql:testnet
```



### 创建数据库
使用 `cql` 命令并使用 `create` 参数提供所需的数据库节点数量创建数据库实例，例如：创建一个单节点的数据库实例

```shell
docker run -it --rm -v ~/.cql/config.yaml:/app/config.yaml -v ~/.cql/private.key:/app/private.key --entrypoint /app/cql  covenantsql/covenantsql  -config /app/config.yaml -create 1
```

命令会返回创建的数据库实例的连接串（DSN）

```shell
covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
```

## 主流语言 Driver 的使用

### NodeJS

NodeJS 开发者可以通过 [node-covenantsql](https://github.com/CovenantSQL/node-covenantsql) 来与 CovenantSQL Adapter 进行交互。

#### 下载安装

可以直接通过 `npm` 或者 `yarn` 来安装 `node-covenantsql`

```bash
npm install --save node-covenantsql
```
or
```bash
yarn add node-covenantsql
```

#### 使用

在运行本地 Adapter 之后，将 Adapter 的 endpoint 填入 `node-covenantsql` 的 config 之中：

```javascript
const config = {
    endpoint: 'localhost:11105', // local testnet endpoint without https
    database: `${DB_ID}`, // your DB id created by `cql` tools
    bypassPem: true // bypass https config
}
```

这里 `bypassPem` 为 `true` 表示应用中所有对链上数据库的操作都会经过本地的 Adapter 进行代理，我们默认本地环境是可控，安全的，无需用 HTTPS 来保证这段连接的信道安全，少了证书的繁琐认证，所以成为 `bypassPem`。

接着连通之后则可进行链上数据库的增删改查：

```typescript
const cql from 'node-covenantsql'

const config = {...} // see above

cql.createConnection(config).then(async (connection: any) => {
    // read
    const data1 = await connection.query("select ? + ?", [2.1, 3.2]);
    console.log(data1);
        
    // write
    const createTableSQL = `
    CREATE TABLE IF NOT EXISTS contacts (\
    contact_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email text NOT NULL UNIQUE,
    phone text NOT NULL UNIQUE
    );
    `
    const status1 = await connection.exec(createTableSQL)
    console.log(`exec1 status:`, status1);

    const data2 = await connection.query("show tables;");
    console.log(data2);
}).catch((e: any) => console.log(e))
```
