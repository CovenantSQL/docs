---
id: api-json-rpc
title: JSON RPC API
---

> JSON-RPC is a stateless, light-weight remote procedure call (RPC) protocol.

CovenantSQL provides a suite of RPC methods in [JSON-RPC 2.0](https://www.jsonrpc.org/specification) for easily accessing to CovenantSQL networks.

## Javascript API

[cql.js](https://github.com/covenantsql/cql.js) is a Javascript SDK which has encapsulated the RPC methods in order to give a much more convenient way to talk to the CovenantSQL networks. See the [Javascript API](./cql-js.md) for more.

## JSON RPC Endpoint

| Network                  | Provider      | URL                                    |
| ------------------------ | ------------- | -------------------------------------- |
| CovenantSQL Test Network | Covenant Labs | https://jsonrpc.testnet.covenantsql.io |
| CovenantSQL Main Network | Covenant Labs | Comming soon :)                        |

## JSON RPC API Reference

### bp_getProtocolVersion

Returns the current CovenantSQL protocol version.

#### Parameters

None.

#### Returns

- string - the current CovenantSQL protocol version

#### Example

Request:

```json
{
  "jsonrpc": "2.0",
  "method": "bp_getProtocolVersion",
  "params": [],
  "id": 1
}
```

Response:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0.1.0"
}
```

### bp_getRunningStatus

Returns some basic indicators describing the running status of the CovenantSQL network.

#### Parameters

None.

#### Returns

- object: an object describes the running status of the network.

#### Example

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "bp_getRunningStatus",
  "params": []
}
```

Response:

```js
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "block_height": 182414, // height of the latest block
    "count_accounts": 103, // count of the accounts ever created
    "count_databases": 912414, // count of the databases ever created
    "qps": 10241 // estimated QPS of database operations of the whole net
  }
}
```

### bp_getBlockList

Returns a list of the blocks.

#### Parameters

| Position | Name | type    | Description            | Sample |
| -------- | ---- | ------- | ---------------------- | ------ |
| 0        | from | integer | start height, included | 1      |
| 1        | to   | integer | end height, excluded   | 11     |

**Constraints:** `to - from ∈ [5, 100]`

#### Returns

- array: list of the blocks, the object in the list is a [Block](#s-block), but **without** transaction details

#### Example

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "bp_getBlockList",
  "params": [1, 11]
}
```

Response: [Block](#s-block) array

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": [
    { TODO: block object }
  ]
}
```

### bp_getBlockListByTimeRange

TODO: as a new API in the next release

### bp_getBlockByHeight

Returns information about the block specified by its height.

#### Parameters

| Position | Name   | type    | Description         | Sample |
| -------- | ------ | ------- | ------------------- | ------ |
| 0        | height | integer | height of the block | 1024   |

#### Returns

- object: block information object, it's a [Block](#s-block)

#### Example

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "bp_getBlockByHeight",
  "params": [1, true]
}
```

Response: [Block](#s-block)

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    TODO: block object
  }
}
```

### bp_getBlockByHash

Returns information about the block specified by its hash.

#### Parameters

| Position | Name | type   | Description       | Sample |
| -------- | ---- | ------ | ----------------- | ------ |
| 0        | hash | string | hash of the block | "TODO" |

#### Returns

- object: block information object, it's a [Block](#s-block)

#### Example

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "bp_getBlockByHash",
  "params": ["TODO", true]
}
```

Response: [Block](#s-block)

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    TODO: block object
  }
}
```

### bp_getTransactionList

Returns a list of the transactions. Traverse page by page by using a transaction hash as the mark for paging.

#### Parameters

| Position | Name      | type    | Description                                 | Sample     |
| -------- | --------- | ------- | ------------------------------------------- | ---------- |
| 0        | since     | string  | hash as the start point of traverse         | "TODO"     |
| 1        | direction | string  | traverse direction, "backward" or "forward" | "backward" |
| 2        | size      | integer | page size, [5, 100]                         | 20         |

```
QhcAe42Xf8cwGUf5NYGQDQ
XNZ9yipFBUV5ySBtreW1MA ↑ forward (in newer blocks)
9fXd3s5HE5fC8lOYY6uAZA
KhytGjS0xjw5CJvcJYpsNg ← since (paging mark)
2KOxrKMS4iVDKXnm6HuYiA
71VwqOMOvAsBXJRMeBruWg ↓ backward (in older blocks)
0P3k04RKHw8SEMKHxADC8A
```

#### Returns

- array: list of the transactions, the object in the list is a [Transaction](#s-transaction)

#### Example

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "bp_getTransactionList",
  "params": ["KhytGjS0xjw5CJvcJYpsNg", "forward", 10]
}
```

Response: [Transaction](#s-transaction) array

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": [
    { TODO: transaction object }
  ]
}
```

### bp_getTransactionListInBlock

Returns a list of the transactions from a block by the specified height.

| Position | Name   | type    | Description           | Sample |
| -------- | ------ | ------- | --------------------- | ------ |
| 0        | height | integer | block height          | 1024   |
| 1        | from   | integer | start index, included | 0      |
| 2        | to     | integer | end index, excluded   | 10     |

**Constraints:** `to - from ∈ [5, 100]`

#### Returns

- array: list of the transactions, the object in the list is a [Transaction](#s-transaction)

#### Example

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "bp_getTransactionListInBlock",
  "params": [1024, 0, 10]
}
```

Response: [Transaction](#s-transaction) array

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": [
    { TODO: transaction object }
  ]
}
```

### bp_getTransactionByHash

Returns information about the transaction specified by its hash.

#### Parameters

| Position | Name | type   | Description             | Sample |
| -------- | ---- | ------ | ----------------------- | ------ |
| 0        | hash | string | hash of the transaction | "TODO" |

#### Returns

- object: transaction information object, it's a [Transaction](#s-transaction)

#### Example

Request:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "bp_getTransactionByHash",
  "params": ["TODO", true]
}
```

Response: [Transaction](#s-transaction)

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    TODO: transaction object
  }
}
```

## Structure Reference

Here are some common structure definitions used in the API.

<a id="s-block"></a>

### Block

The block generated in the CovenantSQL blockchain network.

| Field       | Type    | Description                                  |
| ----------- | ------- | -------------------------------------------- |
| height      | integer | Height of the block                          |
| hash        | string  | Hash of the block                            |
| version     | integer | Version number of the block                  |
| producer    | string  | Address of the node who generated this block |
| merkle_root | string  | Hash of the merkle tree                      |
| parent      | string  | Hash of its parent block                     |
| timestamp   | string  | Create time of the block                     |
| signee      | string  | Public key of the node who signed this block |
| signature   | string  | Signature for the this block                 |
| tx_count    | integer | Count of the transactions in this block      |

Sample in JSON format:

```json
{
  "height": 12,
  "hash": "TODO",
  "version": 1,
  "producer": "4io8u9v9nydaQPXtmqibg8gJbkNFd7DdM47PLWuM7ubzBXZ4At7",
  "merkle_root": "TODO",
  "parent": "TODO",
  "timestamp": "TODO",
  "signee": "TODO",
  "signature": "TODO",
  "tx_count": 1
}
```

<a id="s-transaction"></a>

### Transaction

| Field        | Type    | Description                                                                                 |
| ------------ | ------- | ------------------------------------------------------------------------------------------- |
| block_height | integer | Height of the block this transaction belongs to                                             |
| index        | integer | Index of the transaction in the block                                                       |
| hash         | string  | Hash of the transaction data                                                                |
| block_hash   | string  | Hash of the block this transaction belongs to                                               |
| type         | integer | Type of the transaction                                                                     |
| signee       | string  | Public key of the account who signed this transaction                                       |
| address      | string  | Account address who signed this transaction                                                 |
| signature    | string  | Signature of this transaction                                                               |
| timestamp    | string  | Create time of the transaction                                                              |
| raw          | string  | Raw content of the transaction data, in JSON format                                         |
| tx           | object  | Concrete transaction object, see supported [transaction types](#transaction-types) for more |

Sample in JSON format:

```json
{
  "block_height": 1,
  "index": 0,
  "hash": "TODO",
  "block_hash": "TODO",
  "timestamp": "TODO",
  "type": 1,
  "signee": "TODO",
  "address": "TODO",
  "signature": "TODO",
  "raw": "TODO",
  "tx": {
    "field": "TODO"
  }
}
```

<a id="transaction-types"></a>**Supported Transaction Types:**

- [CreateDatabase](#s-transaction-createdatabase)

TODO: more types

<a id="s-transaction-createdatabase"></a>

### Transaction: CreateDatabase

TODO: more types
