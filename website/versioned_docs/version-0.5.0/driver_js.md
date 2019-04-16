---
id: version-0.5.0-driver_js
title: 📦 Javascript
original_id: driver_js
---

## 用 NodeJS 使用 CovenantSQL

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

使用前需要 [部署 Adapter 工具](./adapter)

在运行本地 Adapter 之后，将 Adapter 的 endpoint 填入 `node-covenantsql` 的 config 之中：

```javascript
const config = {
    endpoint: 'localhost:11105', // local testnet endpoint without https
    database: `${DSN}`, // your DB id created by `cql` tools
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
