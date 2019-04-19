---
id: cql_wallet
title: Wallet Management
---
## Wallet Address

Once the private key and config file is set, you can use sub-command `wallet` to check the wallet address of the account:

```bash
cql wallet
```

Output:

    Enter master key(press Enter for default: ""): 
    
    wallet address: 43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40
    

The wallet address of the test account here is `43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40`.

## Wallet Balances

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
    

## Transferring Tokens to Another Account

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

## Sub-command `wallet` Complete Parameters

    usage: cql wallet [parameter]...
    
    Wallet command can get CovenantSQL wallet address and the token balance of the current account
    e.g.
        cql wallet
    
        cql wallet -balance Particle
        cql wallet -balance all
    
    Params:
      -balance string
            Get a specific token's balance of the current account, e.g. Particle, Wave, and etc.
    

## Sub-command `transfer` Complete Parameters

    usage: cql transfer [parameter]... meta_json
    
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