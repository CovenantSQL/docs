---
id: version-0.6.0-cql_account
title: Account Management
original_id: cql_account
---

For the TestNet environment, we provide a public account for quick testing. Check the [CovenantSQL TestNet](quickstart) tutorial to find out the private key and config file of the public account. And you can also follow the next section to create an individual account with `cql` command.

## Creating New Account

The sub-command `generate` generates a private key file and a config file connecting to the TestNet in the specified directory, e.g.:

```bash
cql generate
```

> Currently, the generated config file is pointed to the TestNet, we will provide options to generated config for Docker Environment later.

For a complete help message, check [Complete Parameters](#sub-command-generate-complete-parameters).

Output:

    Generating private key...
    Please enter password for new private key
    Generated private key.
    Generating nonce...
    INFO cpu: 4
    INFO position: 2, shift: 0x0, i: 2
    INFO position: 0, shift: 0x0, i: 0
    INFO position: 3, shift: 0x0, i: 3
    INFO position: 1, shift: 0x0, i: 1
    nonce: {{973366 0 586194564 0} 26 0000002c32aa3ee39e4f461a5f5e7fda50859f597464d81c9618d443c476835b}
    node id: 0000002c32aa3ee39e4f461a5f5e7fda50859f597464d81c9618d443c476835b
    Generated nonce.
    Generating config file...
    Generated config.

    Config file:      ~/.cql/config.yaml
    Private key file: ~/.cql/private.key
    Public key's hex: 03f195dfe6237691e724bcf54359d76ef388b0996a3de94a7e782dac69192c96f0

    Wallet address: dbb7d1ee90452b8ee9cf514540b8d14fe5b7a750cc0c2f3824db6c8b284ada95

    Any further command could costs PTC.
    You can get some free PTC from:
    	https://testnet.covenantsql.io/wallet/dbb7d1ee90452b8ee9cf514540b8d14fe5b7a750cc0c2f3824db6c8b284ada95

### Public Key

Generate command also print public key (in hex string format) of the private key file, e.g.:

Output：

    Public key's hex: 03f195dfe6237691e724bcf54359d76ef388b0996a3de94a7e782dac69192c96f0

> This info is usually not used in common scene.

### Wallet address

Generate command shows wallet address (in hex string format) and will store in `config.yaml` file, e.g.:

Output：

    Wallet address: dbb7d1ee90452b8ee9cf514540b8d14fe5b7a750cc0c2f3824db6c8b284ada95

    Any further command could costs PTC.
    You can get some free PTC from:
    	https://testnet.covenantsql.io/wallet/dbb7d1ee90452b8ee9cf514540b8d14fe5b7a750cc0c2f3824db6c8b284ada95

After get a wallet address, you may need to request PTC as above.

## Sub-command `generate` Complete Parameters

Also see [Common Parameters for Sub-commands](#common-parameters-for-sub-commands). We will not mention this again in the later sub-command introductions.

    usage: cql generate [common params] [-source template_file] [-miner] [-private existing_private_key] [dest_path]

    Generate generates private.key and config.yaml for CovenantSQL.
    You can input a passphrase for local encrypt your private key file by set -with-password
    e.g.
        cql generate

    or input a passphrase by

        cql generate -with-password

    Generate params:
      -miner string
        	Generate miner config with specified miner address
      -private string
        	Generate config using an existing private key
      -source string
        	Generate config using the specified config template

## Mine a Node ID

The sub-command `idminer` is used to mine another Node ID of a private key (specified by a config file), (also check [Node ID](terms#node-id) for details). e.g.:

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

> This functionality is usually not used in common scene.

## Sub-command `idminer` Complete Parameters

    usage: cql idminer [common params] [-difficulty number] [-loop [true]]

    IDMiner calculates legal node id and it's nonce. Default parameters are difficulty of 24 and no endless loop.
    e.g.
        cql idminer -difficulty 24

    If you want to mine a good id, use:
        cql idminer -config ~/.cql/config.yaml -loop -difficulty 24

    Params:
      -difficulty int
            the difficulty for a miner to mine nodes and generating a nonce (default 24)
      -loop
            mining endless loop
