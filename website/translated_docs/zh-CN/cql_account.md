---
id: cql_account
title: Account Management
---

For the TestNet environment, we provide a public account for quick testing. Check the [CovenantSQL TestNet](quickstart) tutorial to find out the private key and config file of the public account. And you can also follow the next section to create an individual account with `cql` command.

## Creating New Account

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
    

## Acquiring the Public Key

The sub-command `generate` is also used to acquire the public key (in hex string format) of the private key file, e.g.:

```bash
cql generate public
```

Output：

    Enter master key(press Enter for default: ""): 
    
    INFO[0011] init config success                           path=/home/levente/.cql/private.key
    INFO[0011] use public key in config file: /home/levente/.cql/config.yaml
    Public key's hex: 02fd4089e7f4ca224f576d4baa573b3e9662153c952fce3f87f9586ffdd11baef6
    

> This functionality is usually not used in common scene.

## Sub-command `generate` Complete Parameters

Also see [Common Parameters for Sub-commands](#common-parameters-for-sub-commands). We will not mention this again in the later sub-command introductions.

    usage: cql generate [common params] config | public
    
    Generate generates private.key and config.yaml for CovenantSQL.
    e.g.
        cql generate config
    
    Params:
      <No other parameters>
    

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