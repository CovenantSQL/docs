---
id: driver_js
title: 📦 Javascript
---

## 用 Javascript 访问 CovenantSQL

前端开发者可以通过 [covenantsql-proxy-js](https://github.com/CovenantSQL/covenantsql-proxy-js) 来通过 [Adapter](./adapter) 与 CovenantSQL 进行交互。

#### 下载安装

可以直接通过 `npm` 或者 `yarn` 来安装 `covenantsql-proxy-js`

```bash
npm install --save covenantsql-proxy-js
```

或者

```bash
yarn add covenantsql-proxy-js
```

#### 使用

使用前需要 [部署 Adapter 工具](./adapter)。

在运行本地 Adapter 之后，将 Adapter 的 endpoint 和 需要连接的数据库的 Database ID 填入 `covenantsql-proxy-js` 的 config 之中：

```javascript
const config = {
    endpoint: 'localhost:11105', // local testnet endpoint without https
    database: `${DSN}`, // your DB id created by `cql` tools
}
```

接着连通之后则可进行链上数据库的增删改查：

```typescript
const cql from 'covenantsql-proxy-js'

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
