---
id: driver_js
title: '📦 Javascript'
---
## Use Javascript to access CovenantSQL

Front-end developers could use [covenantsql-proxy-js](https://github.com/CovenantSQL/covenantsql-proxy-js) to access CovenantSQL through CovenantSQL [Adapter](./adapter).

#### Installation

Install `node-covenantsql` using package manager `npm` or `yarn`:

```bash
npm install --save node-covenantsql
```

or

```bash
yarn add node-covenantsql
```

#### Quick start

First, [Deploy Adapter Service](./adapter).

Configure `node-covenantsql`, replace `adapter_listen_address` with adapter listen address, replace `database_id` with created database id:

```javascript
const config = {
    endpoint: '<adapter_listen_address>', // local testnet endpoint without https
    database: 'database_id', // your DB id created by `cql` tools
}
```

After successfully connected to adapter, any CRUD operation is available using typical database operations:

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