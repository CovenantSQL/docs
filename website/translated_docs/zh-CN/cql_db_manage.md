---
id: cql_db_manage
title: Database Management
---
## Creating Database

Like `transfer`, `create` takes a `json` format main parameter. Create a database with one miner node with:

```bash
cql create '{"node": 1}'
```

Output:

    Enter master key(press Enter for default: ""): 
    
    covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872
    

Here `covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872` is the database source name (DSN) of the created database. And the `covenantsql` part is the scheme, which can be `cql` in abbreviation. The hex string after `://` is the database address, which can be used as a receiver address in `transfer` command.

The sub-command `create` sends transactions to block producers to create databases, so it has a `wait-tx-confirm` parameter too.

For a complete help message, check [Complete Parameters](#sub-command-create-complete-parameters).

## ~~Deleting Database~~

~~Not yet implemented.~~

## Granting Permission

### Access Permission

CovenantSQL database has 3 kinds of access permission:

- `Admin`
- `Write`
- `Read`
- `Void` (for none)

Among them, `Admin` is the permission that can assign permissions (`Admin`, `Write`, or `Read`) to the other accounts. `Admin` and `Write` allows the write queries (such as `CREATE`, `INSERT`, and etc.). `Admin` and `Read` allows the read queries (such as `SHOW`, `SELECT`, and etc.). If you want to allow a user to read/write the database but not allow to modify the permissions of itself or other accounts, you can assign the user permission as `Read,Write`. `Void` is a special kind of permission which means 'no permission'. Once the `Admin` sets the permission of an account as `Void`, it will no longer able to read or write the database. The account who creates the database will be granted the initial `Admin` permission by default.

Assume that you have created a database `covenantsql:\\4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5` with default account, and have generated another account under directory `account2` which has the address `011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6`. Now you can grant permissions to `accounts` to access the database, with the `json` format main parameter as following:

```json
{
   "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5", // Target database adderss to give permission
   "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", // Target wallet address to get permission
   "perm": "Read,Write" // Permission, separated by commas
}
```

Pass the parameter to `grant`:

```bash
cql grant '{"chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5", "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", "perm": "Read,Write"}'
```

Output:

    INFO[0000] succeed in sending transaction to CovenantSQL
    

Or revoke the permission:

```bash
cql grant '{"chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5", "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", "perm": "Void"}'
```

Output:

    INFO[0000] succeed in sending transaction to CovenantSQL
    

The sub-command `grant` sends transactions to block producers to request permission granting, so it has a `wait-tx-confirm` parameter too.

Since the database separately keeps billing for each user, you need to transfer tokens to the database (as user deposit and advance payment) from the new account before it can actually get access to the database. The minimum amount of deposit and advance payment can be calculated by: `gas_price*number_of_miner*120000`.

Transferring from `account2` to the database:

```bash
cql -config "account2/config.yaml" transfer '{"addr": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5","amount": "90000000 Particle"}'
```

### SQL White List

CovenantSQL supports white list setting for each of its users. By setting up SQL white list, you can further limit the access permission of a user to a given list of SQL Patterns with assignable parameters. With this feature, your database can be further secured because it avoids important data breach and accidentally updating/deleting.

Adding a white list:

```bash
cql grant '
{
    "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5",
    "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6",
    "perm": {
        "patterns": [
            "SELECT COUNT(1) FROM a",
            "SELECT * FROM a WHERE id = ? LIMIT 1"
        ],
        "role": "Read,Write"
    }
}
'
```

*SQL White List is an extension of the database permission system. It currently doesn't support incrementally updating, so you need to provide the complete permission information each time you use the `grant` sub-command*

Cleaning the white list:

```bash
cql grant '
{
    "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5",
    "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6",
    "perm": {
        "patterns": nil,
        "role": "Read,Write"
    }
}
'
 or
cql grant '
{
    "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5",
    "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6",
    "perm": "Read,Write"
}
'
```

Either setting the `pattern` field to `nil` or just resetting the user permission directly, will eliminate the white list and give back the access permission to the user.

## Sub-command `create` Complete Parameters

    usage: cql create [common params] [-wait-tx-confirm] db_meta_json
    
    Create creates a CovenantSQL database by database meta info JSON string. The meta info must include node count.
    e.g.
        cql create '{"node": 2}'
    
    A complete introduction of db_meta_json fields:
        target-miners           []string    // List of target miner addresses
        node                    int         // Target node number
        space                   int         // Minimum disk space requirement, 0 for none
        memory                  int         // Minimum memory requirement, 0 for none
        load-avg-per-cpu        float       // Minimum idle CPU requirement, 0 for none
        encrypt-key             string      // Encryption key for persistence data
        eventual-consistency    bool        // Use eventual consistency to sync among miner nodes
        consistency-level       float       // Consistency level, node*consistency_level is the node number to perform strong consistency
        isolation-level         int         // Isolation level in a single node
    
    Since CovenantSQL is built on top of blockchain, you may want to wait for the transaction confirmation before the creation takes effect.
    e.g.
        cql create -wait-tx-confirm '{"node": 2}'
    
    Params:
      -wait-tx-confirm
            Wait for transaction confirmation
    

## Sub-command `drop` Complete Parameters

    usage: cql drop [common params] [-wait-tx-confirm] dsn/dbid
    
    Drop drops a CovenantSQL database by DSN or database ID.
    e.g.
        cql drop covenantsql://the_dsn_of_your_database
    
    Since CovenantSQL is built on top of blockchain, you may want to wait for the transaction confirmation before the drop operation takes effect.
    e.g.
        cql drop -wait-tx-confirm covenantsql://4119ef997dedc585bfbcfae00ab6b87b8486fab323a8e107ea1fd4fc4f7eba5c
    
    Params:
      -wait-tx-confirm
            Wait for transaction confirmation
    

## Sub-command `grant` Complete Parameters

    usage: cql grant [common params] [-wait-tx-confirm] permission_meta_json
    
    Grant grants specific permissions for the target user.
    e.g.
        cql grant '{"chain": "your_chain_addr", "user": "user_addr", "perm": "perm_struct"}'
    
    Since CovenantSQL is built on top of blockchain, you may want to wait for the transaction confirmation before the permission takes effect.
    e.g.
        cql grant -wait-tx-confirm '{"chain":"your_chain_addr","user":"user_addr","perm":"perm_struct"}'
    
    Params:
      -wait-tx-confirm
            Wait for transaction confirmation