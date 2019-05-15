---
id: version-0.6.0-cql_db_manage
title: Database Management
original_id: cql_db_manage
---

## Creating Database

Like `transfer`, `create` takes several parameters. e.g. Create a database with one miner node:

```bash
cql create -db-node 1
```

Output:

    INFO[0000] Geting bp address from dns: bp00.testnet.gridb.io
    INFO[0048] Register self to blockproducer: 00000000000589366268c274fdc11ec8bdb17e668d2f619555a2e9c1a29c91d8
    INFO init config success                           path=~/.cql/config.yaml
    INFO create database requested                    
    
    The newly created database is: "covenantsql://962bbb3a8028a203e99121d23173a38fa24a670d52c8775a9d987d007a767ce4"
    The connecting string beginning with 'covenantsql://' could be used as a dsn for `cql console`
     or any command, or be used in website like https://web.covenantsql.io
    

Here `covenantsql://962bbb3a8028a203e99121d23173a38fa24a670d52c8775a9d987d007a767ce4` is the database source name (DSN) of the created database. And the `covenantsql` part is the scheme, which can be `cql` in abbreviation. The hex string after `://` is the database address, which can be used as a receiver address in `transfer` command.

The sub-command `create` sends transactions to block producers to create databases, so it has a `wait-tx-confirm` parameter too.

For a complete help message, check [Complete Parameters](#sub-command-create-complete-parameters).

## Billing

CovenantSQL uses Gas for billing just like the [Ethereum Gas](https://www.ethos.io/what-is-ethereum-gas/). The gas unit (a.k.a., the `Gas-Price`) in stable token `Particle` is specified while creating the database, and its corresponding field is `-db-gas-price`. If not specified in the parameter, it will be set as 1 by default. Another billing-related field is `-db-advance-payment`, which will be used as deposit and query expending. The default advance payment is 20,000,000. Creating a database with specified `Gas-Price` and `Advance-Payment`:

```bash
cql create -db-node 2 -db-gas-price 5 -db-advance-payment 500000000
```

Thus we created a new database with `Gas-Price` 5 and `Advance-Payment` 500,000,000. Note that when the CovenantSQL network is short of miner resources, setting a higher `Gas-Price` will help your creation request to be accepted earlier, but it will cost you more tokens of course.

> At present, we only accept the CovenantSQL stable token Particle for database billing. More token types will be supported soon.

And the billing is processed as following:

- For a Read request, the result `rows_count` is counted as the `Gas` cost
- For a Write request, the result `affected_rows` is counted as the `Gas` cost
- The SQLChain miner does periodic billing, sums up, and reports the `Gas` cost to the main chain, and the main chain verifies and deducts `Gas` * `Gas Price` tokens from the user accounts

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

Assume that you have created a database `covenantsql:\\4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5` with default account, and have generated another account under directory `account2` which has the address `011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6`. Now you can grant permissions to `accounts` to access the database, with parameters as following:

```bash
`-to-dsn`  Target database adderss to give permission
`-to-user` Target wallet address to get permission
`-perm`    Permission, separated by commas
```

Pass the parameter to `grant`:

```bash
cql grant -to-dsn covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5 \
          -to-user 011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6 \
          -perm "Read,Write"
```

Output:

    INFO[0000] Geting bp address from dns: bp04.testnet.gridb.io
    INFO[0003] Self register to blockproducer: 00000000003b2bd120a7d07f248b181fc794ba8b278f07f9a780e61eb77f6abb
    INFO init config success                           path=~/.cql/config.yaml
    INFO succeed in grant permission on target database
    

Or revoke the permission:

```bash
cql grant -to-dsn covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5 \
          -to-user 011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6 \
          -perm "Void"
```

Output:

    INFO[0000] Geting bp address from dns: bp04.testnet.gridb.io
    INFO[0003] Self register to blockproducer: 00000000003b2bd120a7d07f248b181fc794ba8b278f07f9a780e61eb77f6abb
    INFO init config success                           path=~/.cql/config.yaml
    INFO succeed in grant permission on target database
    

The sub-command `grant` sends transactions to block producers to request permission granting, so it has a `wait-tx-confirm` parameter too.

Since the database separately keeps billing for each user, you need to transfer tokens to the database (as user deposit and advance payment) from the new account before it can actually get access to the database. The minimum amount of deposit and advance payment can be calculated by: `gas_price*number_of_miner*120000`.

Transferring from `account2` to the database:

```bash
cql transfer -config "account2/config.yaml" \
             -to-dsn covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5 \
             -amount 90000000 \
             -token Particle
```

### SQL White List

CovenantSQL supports white list setting for each of its users. By setting up SQL white list, you can further limit the access permission of a user to a given list of SQL Patterns with assignable parameters. With this feature, your database can be further secured because it avoids important data breach and accidentally updating/deleting.

Adding a white list:

```bash
cql grant -to-dsn covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5 \
          -to-user 011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6 \
          -perm '
{
    "patterns": [
        "SELECT COUNT(1) FROM a",
        "SELECT * FROM a WHERE id = ? LIMIT 1"
    ],
    "role": "Read,Write"
}
'
```

*SQL White List is an extension of the database permission system. It currently doesn't support incrementally updating, so you need to provide the complete permission information each time you use the `grant` sub-command*

Cleaning the white list:

```bash
<br />cql grant -to-dsn covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5 \
          -to-user 011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6 \
          -perm '
{
   "patterns": nil,
   "role": "Read,Write"
}
'

 or

cql grant -to-dsn covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5 \
          -to-user 011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6 \
          -perm "Read,Write"
```

Either setting the `pattern` field to `nil` or just resetting the user permission directly, will eliminate the white list and give back the access permission to the user.

## Sub-command `create` Complete Parameters

    usage: cql create [common params] [-wait-tx-confirm] [db_meta_params]
    
    Create command creates a CovenantSQL database by database meta params. The meta info must include
    node count.
    e.g.
        cql create -db-node 2
    
    Since CovenantSQL is built on top of blockchains, you may want to wait for the transaction
    confirmation before the creation takes effect.
    e.g.
        cql create -wait-tx-confirm -db-node 2
    
    DB meta params:
      -db-advance-payment uint
            Customized advance payment
      -db-consistency-level float
            Consistency level, node*consistency_level is the node count to perform strong consistency
      -db-encrypt-key string
            Encryption key for persistence data
      -db-eventual-consistency
            Use eventual consistency to sync among miner nodes
      -db-gas-price uint
            Customized gas price
      -db-isolation-level int
            Isolation level in a single node
      -db-load-avg-per-cpu float
            Minimum idle CPU requirement, 0 for none
      -db-memory uint
            Minimum memory requirement, 0 for none
      -db-node uint
            Target node count
      -db-space uint
            Minimum disk space requirement, 0 for none
      -db-target-miners value
            List of target miner addresses(separated by ',')
      -wait-tx-confirm
            Wait for transaction confirmation
    

## Sub-command `drop` Complete Parameters

    usage: cql drop [common params] [-wait-tx-confirm] dsn
    
    Drop drops a CovenantSQL database by DSN or database ID.
    e.g.
        cql drop covenantsql://4119ef997dedc585bfbcfae00ab6b87b8486fab323a8e107ea1fd4fc4f7eba5c
    
    Since CovenantSQL is built on top of blockchains, you may want to wait for the transaction
    confirmation before the drop operation takes effect.
    e.g.
        cql drop -wait-tx-confirm covenantsql://4119ef997dedc585bfbcfae00ab6b87b8486fab323a8e107ea1fd4fc4f7eba5c
    
    Drop params:
      -wait-tx-confirm
            Wait for transaction confirmation
    

## Sub-command `grant` Complete Parameters

    usage: cql grant [common params] [-wait-tx-confirm] [-to-user wallet] [-to-dsn dsn] [-perm perm_struct]
    
    Grant grants specific permissions for the target user on target dsn.
    e.g.
        cql grant -to-user=43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40 -to-dsn="covenantsql://xxxx" -perm perm_struct
    
    Since CovenantSQL is built on top of blockchains, you may want to wait for the transaction
    confirmation before the permission takes effect.
    e.g.
        cql grant -wait-tx-confirm -to-user=43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40 -to-dsn="covenantsql://xxxx" -perm perm_struct
    
    Grant params:
      -perm string
            Permission type struct for grant.
      -to-dsn string
            Target database dsn to grant permission.
      -to-user string
            Target address of an user account to grant permission.
      -wait-tx-confirm
            Wait for transaction confirmation