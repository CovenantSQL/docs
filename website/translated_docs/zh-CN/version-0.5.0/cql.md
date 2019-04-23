---
id: version-0.5.0-cql
title: Client
original_id: cql
---

## Intro

CovenantSQL provides a `cql` command line toolset for terminal users to access and manage user accounts, wallet balances, and databases. Check the complete toolset installation tutorial at \[CovenantSQL Toolset installation\](quickstart#工具包安装).

### Private Key and Config File

The `cql` command needs to rely on a private key file `private.key` and a config file `config.yaml`:

- `private.key`：a private key file which is generated while creating an account, be sure to keep it safe
- `config.yaml`：mainly used to config the CovenantSQL network for `cql` command to connect (e.g., the [TestNet](quickstart) or the [Docker Environment by One Click](deployment))

For security, the private key file is usually encrypted with a master key. A master key is individually chosen by the user while creating an account and is memorized or kept somewhere by the user -- note that the config file will not keep the master key. When the private key is required by the `cql` command, it will ask the user to input the master key to decrypt the private key file.

### Common Parameters for Sub-commands

The following parameters are commonly used by `cql` sub-commands:

    -bypass-signature
          Disable signature signing and verifying, for testing only
    -config string
          Config file for covenantsql (Usually no need to set, default is enough.) (default "~/.cql/config.yaml")
    -no-password
          Use an empty master key
    -password string
          Master key for covenantsql (NOT SAFE, for debugging or script mode only)
    

Note that the private key file path is specified in the config file, and its default value is `./private.key`, indicating that it's located in the same directory of the config. So usually we put the private key file together with config, instead of using an individual parameter to specify the private key file.

## Account Management

For the TestNet environment, we provide a public account for quick testing. Check the [CovenantSQL TestNet](quickstart) tutorial to find out the private key and config file of the public account. And you can also follow the next section to create an individual account with `cql` command.

### Creating New Account

The sub-command `generate` generates a private key file and a config file connecting to the TestNet in the specified directory, e.g.:

```bash
cql generate config
```

> Currently, the generated config file is pointed to the TestNet, we will provide options to generated config for Docker Environment later.

For a complete help message, check [Complete Parameters](#sub-command-generate-complete-parameters).

Output:

    Generating key pair...
    Enter master key(press Enter for default: ""): 
    
    Private key file: ~/.cql/private.key
    Public key's hex: 027af3584b8b4736d6ba1e78ace5f0fdefe561f08749c5cac39d23668c3030fe39
    Generated key pair.
    Generating nonce...
    INFO[0075] cpu: 4
    INFO[0075] position: 3, shift: 0x0, i: 3
    INFO[0075] position: 1, shift: 0x0, i: 1
    INFO[0075] position: 0, shift: 0x0, i: 0
    INFO[0075] position: 2, shift: 0x0, i: 2
    nonce: {{1056388 0 0 1424219234} 25 000000737633a77a39fc5e0a1855ca2c441486fef049ac4069e93dde6e58bb01}
    node id: 000000737633a77a39fc5e0a1855ca2c441486fef049ac4069e93dde6e58bb01
    Generated nonce.
    Generating config file...
    Generated nonce.
    

### Acquiring the Public Key

The sub-command `generate` is also used to acquire the public key (in hex string format) of the private key file, e.g.:

```bash
cql generate public
```

Output：

    Enter master key(press Enter for default: ""): 
    
    INFO[0011] init config success                           path=/home/levente/.cql/private.key
    INFO[0011] use public key in config file: /home/levente/.cql/config.yaml
    Public key's hex: 02fd4089e7f4ca224f576d4baa573b3e9662153c952fce3f87f9586ffdd11baef6
    

> This functionality is usually not used in common scene

### Sub-command `generate` Complete Parameters

Also see [Common Parameters for Sub-commands](#common-parameters-for-sub-commands). We will not mention this in the further sub-command introductions.

    usage: cql generate [parameters]... config | public
    
    Generate command can generate private.key and config.yaml for CovenantSQL.
    e.g.
        cql generate config
    
    Params:
      <No other parameters>
    

### Mine a Node ID

The sub-command `idminer` is used to mine another Node ID of a private key (specified by a config file), (also check [Node ID](terms#Node-ID) for details). e.g.:

```bash
cql idminer
```

Output:

    INFO[0000] cql build: cql develop-34ae741a-20190415161544 linux amd64 go1.11.5
    Enter master key(press Enter for default: ""):
    
    INFO[0008] init config success                           path=/home/levente/.cql/config.yaml
    INFO[0008] use public key in config file: /home/levente/.cql/config.yaml
    INFO[0008] cpu: 8
    INFO[0008] position: 3, shift: 0x20, i: 7
    INFO[0008] position: 0, shift: 0x0, i: 0
    INFO[0008] position: 3, shift: 0x0, i: 6
    INFO[0008] position: 1, shift: 0x0, i: 2
    INFO[0008] position: 2, shift: 0x0, i: 4
    INFO[0008] position: 1, shift: 0x20, i: 3
    INFO[0008] position: 2, shift: 0x20, i: 5
    INFO[0008] position: 0, shift: 0x20, i: 1
    nonce: {{1251426 4506240821 0 0} 25 00000041bc2b3de3bcb96328d0004c684628a908f0233eb31fe9998ef0c6288e}
    node id: 00000041bc2b3de3bcb96328d0004c684628a908f0233eb31fe9998ef0c6288e
    

> This functionality is usually not used in common scene

### Sub-command `idminer` Complete Parameters

    usage: cql idminer [parameter]...
    
    IDMiner command can calculate legal node id and it's nonce. Default 24 difficulty and no endless loop.
    e.g.
        cql idminer -difficulty 24
    
    If you want to mine a good id, use:
        cql idminer -config ~/.cql/config.yaml -loop -difficulty 24
    
    Params:
      -difficulty int
            the difficulty for a miner to mine nodes and generating a nonce (default 24)
      -loop
            mining endless loop
    

## Wallet Management

### Wallet Address

Once the private key and config file is set, we can use sub-command `wallet` to check the wallet address of the account:

```bash
cql wallet
```

Output:

    Enter master key(press Enter for default: ""): 
    
    wallet address: 43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40
    

The wallet address of the test account here is `43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40`.

### Wallet Balances

We can also use sub-command `wallet` to check the balances in the wallet. CovenantSQL currently supports 5 types of tokens:

- `Particle`
- `Wave`
- `Bitcoin`
- `Ether`
- `EOS`

Among them, `Particle` and `Wave` are the token types used by CovenantSQL. To check the token balances, use:

```bash
cql wallet -balance all
```

Output:

    INFO[0000] Particle balance is: 10000000000000000000
    INFO[0000] Wave balance is: 10000000000000000000
    

You can also check the balance of a specified type of token, e.g., checking the balance of `Bitcoin`:

```bash
cql wallet -balance Bitcoin
```

Output:

    INFO[0000] Bitcoin balance is: 0
    

### Transferring Tokens to Another Account

Once you get tokens from [TestNet](quickstart) or [Docker Environment by One-Click](deployment), you can use the `transfer` sub-command to transfer tokens to another account. The command takes a `json` format meta info as its main parameter, e.g.:

```json
{
  "addr": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", // Receiver wallet address
  "amount": "1000000 Particle" // Transfer amount with token type
}
```

Note that the receiver wallet address could be a user account address or a database address -- we treat the database as a special kind of account. While transferring to a database, the tokens will be used as the deposit and advance payment of that database for the sender.

> Check more detailed knowledge about [Deposit and Advance Payment](terms#deposit-and-advance-payment).

Pass the parameter to `transfer`:

```bash
cql transfer '{"addr": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6","amount": "1000000 Particle"}'
```

Output:

    INFO[0000] succeed in sending transaction to CovenantSQL
    

Note that the above output message indicates that the transfer request is successfully sent to CovenantSQL network, but it will take a while before the block producers actually execute and confirm the transaction to take effect. You can use the `cql wallet -balance <token_type>` command again to check if the request takes effect, or add `-wait-tx-confirm` parameter to make `cql` wait for transaction confirmation before exit.

### Sub-command `wallet` Complete Parameters

    usage: cql wallet [-config file] [-balance token_name]
    
    Wallet command can get CovenantSQL wallet address and the token balance of the current account
    e.g.
        cql wallet
    
        cql wallet -balance Particle
        cql wallet -balance all
    
    Params:
      -balance string
            Get a specific token's balance of the current account, e.g. Particle, Wave, and etc.
    

### Sub-command `transfer` Complete Parameters

    usage: cql transfer [-config file] [-wait-tx-confirm] meta_json
    
    Transfer command can transfer your token to the target account.
    The command argument is JSON meta info of a token transaction.
    e.g.
        cql transfer '{"addr":"your_account_addr","amount":"100 Particle"}'
    
    Since CovenantSQL is based on blockchain, you may want to wait for the transaction confirmation.
    e.g.
        cql transfer -wait-tx-confirm '{"addr":"your_account_addr","amount":"100 Particle"}'
    
    Params:
      -wait-tx-confirm
            Wait for transaction confirmation
    

## Database Management

### Creating Database

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

### ~~Deleting Database~~

~~Not yet implemented.~~

### Granting Permission

#### Access Permission

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

#### SQL White List

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
# or
cql grant '
{
    "chain": "4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5",
    "user": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6",
    "perm": "Read,Write"
}
'
```

Either setting the `pattern` field to `nil` or just resetting the user permission directly, will eliminate the white list and give back the access permission to the user.

### Sub-command `create` Complete Parameters

    usage: cql create [parameters]... db_meta_json
    
    Create CovenantSQL database by database meta info JSON string, meta info must include node count.
    e.g.
        cql create '{"node":2}'
    
    A complete introduction of db_meta_json fields：
        targetminers           []string // List of target miner addresses
        node                   int      // Target node number
        space                  int      // Minimum disk space requirement, 0 for none
        memory                 int      // Minimum memory requirement, 0 for none
        loadavgpercpu          float    // Minimum idle CPU requirement, 0 for none
        encryptionkey          string   // Encryption key for persistence data
        useeventualconsistency bool     // Use eventual consistency to sync among miner nodes
        consistencylevel       float    // Consistency level, node*consistencylevel is the node number to perform strong consistency
        isolationlevel         int      // Isolation level in a single node
    
    Since CovenantSQL is blockchain database, you may want get confirm of creation.
    e.g.
        cql create -wait-tx-confirm '{"node": 2}'
    
    Params:
      -wait-tx-confirm
            Wait for transaction confirmation
    

### Sub-command `drop` Complete Parameters

    usage: cql drop [parameter]... dsn/dbid
    
    Drop command can drop a database by DSN or database id
    e.g.
        cql drop covenantsql://the_dsn_of_your_database
    
    Since CovenantSQL is blockchain database, you may want get confirm of drop operation.
    e.g.
        cql drop -wait-tx-confirm covenantsql://the_dsn_of_your_database
    
    Params:
      -wait-tx-confirm
            Wait for transaction confirmation
    

### Sub-command `grant` Complete Parameters

    usage: cql grant [parameter]... permission_meta_json
    
    Grant command can give a user some specific permissions on your database
    e.g.
        cql grant '{"chain": "your_chain_addr", "user": "user_addr", "perm": "perm_struct"}'
    
    Since CovenantSQL is blockchain database, you may want get confirm of permission update.
    e.g.
        cql grant -wait-tx-confirm '{"chain":"your_chain_addr","user":"user_addr","perm":"perm_struct"}'
    
    Params:
      -wait-tx-confirm
            Wait for transaction confirmation
    

## Accessing Database

Once your database is successfully created, you can use the `console` sub-command to access it in an interactive console:

```bash
cql console -dsn 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

Output:

    Enter master key(press Enter for default: ""): 
    
    INFO[0010] init config success                           path=/home/levente/.cql/config.yaml
    INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
    Connected with driver covenantsql (develop-34ae741a-20190416184528)
    Type "help" for help.
    
    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>
    

Or access as `account2` if it has successfully been granted access permission:

```bash
cql console -config "account2/config.yaml" -dsn 'covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5'
```

Output:

    Enter master key(press Enter for default: ""): 
    
    INFO[0010] init config success                           path=/home/levente/.config/cql/account2/config.yaml
    INFO[0010] connecting to "covenantsql://4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5" 
    Connected with driver covenantsql (develop-34ae741a-20190416184528)
    Type "help" for help.
    
    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=>
    

Here is an example of using the interactive console:

    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> create table t1 (c1 int);
    CREATE TABLE
    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> insert into t1 values (1), (2), (3);
    INSERT
    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> select * from t1;
    c1
    ----
    1
    2
    3
    (3 rows)
    
    co:4bc27a06ae52a7b8b1747f3808dda786ddd188627bafe8e34a332626e7232ba5=> 
    

### Sub-command `console` Complete Parameters

The sub-command `console` also supports running `adapter` or `explorer` servers in the background. Check [Local Servers](#local-servers) for details.

    usage: cql console [parameter]...
    
    Console command can run a interactive SQL console for CovenantSQL
    e.g.
        cql console -dsn covenantsql://the_dsn_of_your_database
    
    There is also a -command param for SQL script, and a -file param for reading SQL in a file.
    If those params are set, it will run SQL script and exit without staying console mode.
    e.g.
        cql console -dsn covenantsql://the_dsn_of_your_database -command "create table test1(test2 int);"
    
    Params:
      -adapter string
            Address to serve a database chain adapter, e.g.:7784
      -command string
            Run only single command (SQL or usql internal command) and exit
      -dsn string
            Database url
      -explorer string
            Address to serve a database chain explorer, e.g.:8546
      -file string
            Execute commands from file and exit
      -no-rc
            Do not read startup file
      -out string
            Record stdout to file
      -single-transaction
            Execute as a single transaction (if non-interactive)
      -variable value
            Set variable
    

## Local Servers

### Sub-command `explorer` Complete Parameter

    usage: cql explorer [parameter]... address
    
    Explorer command serves a SQLChain web explorer.
    e.g.
        cql explorer 127.0.0.1:8546
    
    Params:
      -bg-log-level string
            Background service log level
      -tmp-path string
            Background service temp file path, use os.TempDir for default
    

### Sub-command `mirror` Complete Parameter

    usage: cql mirror [parameter]... dsn/dbid address
    
    Mirror command subscribes database updates and serves a read-only database mirror.
    e.g.
        cql mirror database_id 127.0.0.1:9389
    
    Params:
      -bg-log-level string
            Background service log level
      -tmp-path string
            Background service temp file path, use os.TempDir for default
    

### Sub-command `adapter` Complete Parameter

See <adapter> for details of adapter server.

    usage: cql adapter [parameter]... address
    
    Adapter command serves a SQLChain adapter
    e.g.
        cql adapter 127.0.0.1:7784
    
    Params:
      -bg-log-level string
            Background service log level
      -mirror string
            mirror server for the target adapter to query
      -tmp-path string
            Background service temp file path, use os.TempDir for default
    

## Advance Usage

Sub-command `rpc` calls the remote process directly in the CovenantSQL network.

### Sub-command `rpc` Complete Parameter

    usage: cql rpc [parameter]...
    
    Rpc command make a RPC request to the target server
    e.g.
        cql rpc -name 'MCC.QuerySQLChainProfile' \
                -endpoint 000000fd2c8f68d54d55d97d0ad06c6c0d91104e4e51a7247f3629cc2a0127cf \
                -req '{"DBID": "c8328272ba9377acdf1ee8e73b17f2b0f7430c798141080d0282195507eb94e7"}'
    
    Params:
      -endpoint string
            RPC endpoint to do a test call
      -name string
            RPC name to do a test call
      -req string
            RPC request to do a test call, in json format
      -wait-tx-confirm
            Wait for transaction confirmation