---
id: version-0.6.0-cql_intro
title: Overview
original_id: cql_intro
---

CovenantSQL provides a `cql` command line toolset for terminal users to access and manage user accounts, wallet balances, and databases. Check the complete toolset installation tutorial at [CovenantSQL Toolset installation](quickstart#工具包安装).

## Private Key and Config File

The `cql` command needs to rely on a private key file `private.key` and a config file `config.yaml`:

- `private.key`：a private key file which is generated while creating an account, be sure to keep it safe
- `config.yaml`：mainly used to config the CovenantSQL network for `cql` command to connect (e.g., the [TestNet](quickstart) or the [Private Deploy](advanced_deployment))

For security, the private key file is usually encrypted with a master key. A master key is individually chosen by the user while creating an account and is memorized or kept somewhere by the user -- note that the config file will not keep the master key. When the private key is required by the `cql` command, it will ask the user to input the master key to decrypt the private key file.

## Command Format

The `cql` command has more than a dozen subcommands, each one follows the same command format. e.g:

    cql sub-command [common parameters] [subcommand parameters] arguments

The content of `arguments` may be empty, but it must be placed at the end of the command when it is not empty.

## Common Parameters for Sub-commands

The following parameters are commonly used by `cql` sub-commands:

    -config string
          Config file for covenantsql (Usually no need to set, default is enough.) (default "~/.cql/config.yaml")
    -with-password
          Use passphrase for private.key
    -password string
          Master key for covenantsql (NOT SAFE, for debugging or script mode only)
    -help
    	  Show help message

Note that the private key file path is specified in the config file, and its default value is `./private.key`, indicating that it's located in the same directory of the config. So usually we put the private key file together with config, instead of using an individual parameter to specify the private key file.
