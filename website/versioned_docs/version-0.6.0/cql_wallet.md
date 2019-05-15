---
id: version-0.6.0-cql_wallet
title: Wallet Management
original_id: cql_wallet
---

## Wallet Address

Once the private key and config file is set, you can use sub-command `wallet` to check the wallet address of the account:

```bash
cql wallet
```

Output:

    INFO[0000] Geting bp address from dns: bp00.testnet.gridb.io
    INFO[0003] Register self to blockproducer: 00000000000589366268c274fdc11ec8bdb17e668d2f619555a2e9c1a29c91d8
    INFO init config success                           path=~/.cql/config.yaml


    wallet address: 290f7dbbff2aa0d5a5af65f4caa0bfd68663f97f9b08d0ee71e76a172349b613
    Particle balance is: 100000000
    Wave balance is: 0
    found no related database

The wallet address of the test account here is `290f7dbbff2aa0d5a5af65f4caa0bfd68663f97f9b08d0ee71e76a172349b613`.
And balances are also shown.

## Wallet Balances

CovenantSQL currently supports 5 types of tokens:

- `Particle`
- `Wave`
- `Bitcoin`
- `Ether`
- `EOS`

Among them, `Particle` and `Wave` are the token types used by CovenantSQL.
You can also check the balance of a specified type of token, e.g., checking the balance of `Bitcoin`:

```bash
cql wallet -token Bitcoin
```

Output:

    INFO[0000] Geting bp address from dns: bp05.testnet.gridb.io
    INFO[0006] Register self to blockproducer: 0000000000293f7216362791b6b1c9772184d6976cb34310c42547735410186c
    INFO init config success                           path=~/.cql/config.yaml

    wallet address: 290f7dbbff2aa0d5a5af65f4caa0bfd68663f97f9b08d0ee71e76a172349b613
    Bitcoin balance is: 0

## Transferring Tokens to Another Account

Once you get tokens from [TestNet](quickstart) or [Docker Environment](deployment), you can use the `transfer` sub-command to transfer tokens to another account. The command takes 3 main parameters, e.g.:

```bash
cql transfer -to-user 011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6 -amount 1000000 -type Particle
```

`-to-user` is set for other user's wallet address, `-amount` param is for token count, and `-type` is for token type

## Transferring Tokens to a database

If you want to transfer token to a database address, replace `-to-user` to `-to-dsn`, and set a CovenantSQL dsn string. e.g.

```bash
cql transfer -to-dsn covenantsql://0bfea233d20676bb848b66d072bb768945507bb8a3b8b22b13133cde0583e208 -amount 1000000 -type Particle
```

While transferring to a database, the tokens will be used as the deposit and advance payment of that database for the sender.

> Check more detailed knowledge about [Deposit and Advance Payment](terms#deposit-and-advance-payment).

Output:

    INFO[0000] Geting bp address from dns: bp04.testnet.gridb.io
    INFO[0043] Register self to blockproducer: 00000000003b2bd120a7d07f248b181fc794ba8b278f07f9a780e61eb77f6abb
    INFO init config success                           path=~/.cql/config.yaml
    INFO succeed in sending transaction to CovenantSQL

Note that the above output message indicates that the transfer request is successfully sent to CovenantSQL network, but it will take a while before the block producers actually execute and confirm the transaction to take effect. You can use the `cql wallet -token <token_type>` command again to check if the request takes effect, or add `-wait-tx-confirm` parameter to make `cql` wait for transaction confirmation before exit.

## Sub-command `wallet` Complete Parameters

    usage: cql wallet [common params] [-token type] [-dsn dsn]

    Wallet gets the CovenantSQL wallet address and the token balances of the current account.
    e.g.
        cql wallet

        cql wallet -token Particle

        cql wallet -dsn "covenantsql://4119ef997dedc585bfbcfae00ab6b87b8486fab323a8e107ea1fd4fc4f7eba5c"

    Wallet params:
      -dsn string
        	Show specified database deposit
      -token string
        	Get specific token's balance of current account, e.g. Particle, Wave, All

## Sub-command `transfer` Complete Parameters

    usage: cql transfer [common params] [-wait-tx-confirm] [-to-user wallet | -to-dsn dsn] [-amount count] [-type token_type]

    Transfer transfers your token to the target account or database.
    The command arguments are target wallet address(or dsn), amount of token, and token type.
    e.g.
        cql transfer -to-user=43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40 -amount=100 -type=Particle

    Since CovenantSQL is built on top of blockchains, you may want to wait for the transaction
    confirmation before the transfer takes effect.
    e.g.
        cql transfer -wait-tx-confirm -to-dsn=43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40 -amount=100 -type=Particle

    Transfer params:
      -amount uint
        	Token account to transfer.
      -to-dsn string
        	Target database dsn to transfer token.
      -to-user string
        	Target address of an user account to transfer token.
      -type string
        	Token type to transfer.
      -wait-tx-confirm
        	Wait for transaction confirmation
