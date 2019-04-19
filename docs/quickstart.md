---
id: quickstart
title: Quick Start
---


## CovenantSQL Client

### Install

Please choose the installation method according to the operating system platform you use:

#### MacOS

- 🍺 Homebrew users can just run:

```bash
brew install cql
```

- non-Homebrew users can run:

```bash
sudo bash -c 'curl -L "https://bintray.com/covenantsql/bin/download_file?file_path=CovenantSQL-v0.5.0.osx-amd64.tar.gz" | \
 tar xzv -C /usr/local/bin/ --strip-components=1'
```

#### Linux

Just run：

```bash
sudo bash -c 'curl -L "https://bintray.com/covenantsql/bin/download_file?file_path=CovenantSQL-v0.5.0.linux-amd64.tar.gz" | \
tar xzv -C /usr/local/bin/ --strip-components=1'
```

After the installation is complete, you can execute the following command to check whether the installation is successful.

```bash
cql version
```

If you have any errors on the MacOS or Linux, you can try the following to fix it:

```bash
sudo chmod a+x /usr/local/bin/cql*         # Fix Permission
sudo ln -s /usr/local/bin/cql* /usr/bin/   # Fix if /usr/local/bin not in $PATH
```

If the problem persists please check out our GitHub page [Submit issue](https://github.com/CovenantSQL/CovenantSQL/issues/new?assignees=&labels=bug&template=bug_report.md&title=%5BBUG%5D)。

### Utils

| Tool     | Introduction                                                         |
| ---------- | ------------------------------------------------------------ |
| cql        | CovenantSQL client, `cql console` The command is similar to the `mysql` command and is used to manage the CQL databases, [More](./cql_intro) |
| cql-fuse   | CovenantSQL's FUSE client, which can mount a CovenantSQL database as a file system |
| cql-minerd | CovenantSQL miner client, used to run the database to earn rewards, will open later |
| cqld       | CovenantSQL main chain node, mainly run by CovenantLabs and partners in DPoS mode |

> Windows platform we will release later, if there is a need please [Submit Issue](https://github.com/CovenantSQL/CovenantSQL/issues/new?assignees=&labels=&template=feature_request.md&title=) 讨论。

### TestNet

At present, we have released the test network v0.5.0 for everyone to verify and experience the principle. You can choose to quickly perform access testing using the "public account".

The configuration file and private key of the "public account":[config.yaml](https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/develop/conf/testnet/config.yaml)、[private.key](https://raw.githubusercontent.com/CovenantSQL/CovenantSQL/develop/conf/testnet/private.key) (empty password)，or just run：

```bash
mkdir -p ~/.cql/testnet-conf
curl -L https://git.io/fhFZe --output ~/.cql/testnet-conf/config.yaml
curl -L https://git.io/fhFZv --output ~/.cql/testnet-conf/private.key
chmod 600 ~/.cql/testnet-conf/private.key
```

**TestNet Notes**：

> The "public account" is public and only for testing. Please do not store your application information in the database created by the "public account". We will clean the database data from time to time.
>
> The test network is temporarily composed of 3 Miners, so temporarily only supports `create 3` to create a database of 3 nodes.

## Create a database

```bash
cql create -config=~/.cql/testnet-conf/config.yaml -no-password \ 
-wait-tx-confirm '{"node":1}'
```

The command execution takes a little long time, and the console outputs after about 30 seconds:

> covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872

​	

This means that you submitted the database `0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872` creation request to the main chain and created the database to complete.

> Command execution takes some time, and the general process is:
>
> 1. The "Block Producer" that received the request performs a match of Miner and database creation requests.
> 2. Database creation request is verified and confirmed at other "Block Producer" nodes
> 3. Eligible Miner on SQLChain receives database task
> 4. SQLChain Miners builds a database cluster with Kayak
> 5. All Miners are ready to wait for a database request



## Access the database

```bash
cql console -config=~/.cql/testnet-conf/config.yaml -no-password \ 
-dsn covenantsql://0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872
```

After connecting to the database, you can manipulate the database on CovenantSQL according to your habit of operating the database. For example, execute `CREATE TABLE` to create a table, `SELECT` query data, and so on.


## SQLChain Explorer

One feature of CovenantSQL is that its query records are **immutable and traceable**, you can query the operation of a database through [Test Web Block Browser] (https://explorer.dbhub.org/) recording.

> The TestNet's SQLChain Explorer is currently open-access, and anyone who knows the database ID can manipulate your data using TestNet's public key.

Please fill in your database ID in the upper right corner of the page. For example: `0a10b74439f2376d828c9a70fd538dac4b69e0f4065424feebc0f5dbc8b34872`. You can see information about all the data created using TestNet's Key:

![explorer](https://github.com/CovenantSQL/docs/raw/master/website/static/img/explorer.png)

   

> **If you want to create your own private database, you need to create a new public-private key pair from scratch, please refer to the following section.**



## Create your own account

Our test network allows you to create your own account and create a database under your own account. Create an account with the following command (you will be asked to set the master password, you can add `-no-password` to leave blank)：

```bash
cql generate -no-password config
```

Output：

```
INFO[0000] cql build: cql HEAD-48fff30-20190328075135 linux amd64 go1.11.6 
"/home/work/.cql" already exists. 
Do you want to delete it? (y or n, press Enter for default n):
y
Generating key pair...
Private key file: /home/work/.cql/private.key
Public key's hex: 024123d10696cf54fbf2b1e2b507ec4d1cbf2b4e87095774ad5fd6376cdae88e87
Generated key pair.
Generating nonce...
INFO[0001] cpu: 2                                       
INFO[0001] position: 2, shift: 0x0, i: 1                
INFO[0001] position: 0, shift: 0x0, i: 0                
nonce: {{2556203225 0 0 0} 24 000000829171cb94b765b4d51f2601aaf2c0f5270827ed97ddbecf0075437dad}
node id: 000000829171cb94b765b4d51f2601aaf2c0f5270827ed97ddbecf0075437dad
Generated nonce.
Generating config file...
Generated config.
```

This command will create a `.cql` directory for you in your `$HOME` directory:

- `~/.cql/private.key`: The generated private key is stored in the file by the master password encryption, and your account address needs to be created using this file;
- `~/.cql/config.yaml`: The generated configuration, cql can access the CovenantSQL TestNet with it.

Let's continue to generate the account address (also called the wallet address, CovenantSQL address):

```bash
cql wallet -no-password
```

Output：

```
wallet address: bc3cba461500f49c2adf6e6e98c1b3513063227063512f0dd6a5160c01de5e3c
```

You can get the test PTC here with the wallet address obtained above: [Request PTC] (https://testnet.covenantsql.io/).

After up to 2 minutes, you can use the cql command line tool to check the balance:

```bash
cql wallet -no-password -balance all
```

output：

```
Particle balance is: 10000000
Wave balance is: 0
```

Congratulations, you have received our PTC stable currency, and you can start using CovenantSQL now. You can refer to [Golang uses CovenantSQL documentation](./driver_golang) for development.
