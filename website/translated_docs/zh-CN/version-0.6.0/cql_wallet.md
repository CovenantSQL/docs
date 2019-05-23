---
id: cql_wallet
title: 钱包管理
---

## 查看钱包地址

在配置好账号以后，可以通过 `wallet` 子命令来获取账号的钱包地址：

```bash
cql wallet
```

输出：

    INFO[0000] Geting bp address from dns: bp00.testnet.gridb.io
    INFO[0003] Register self to blockproducer: 00000000000589366268c274fdc11ec8bdb17e668d2f619555a2e9c1a29c91d8
    INFO init config success                           path=~/.cql/config.yaml


    wallet address: 290f7dbbff2aa0d5a5af65f4caa0bfd68663f97f9b08d0ee71e76a172349b613
    Particle balance is: 100000000
    Wave balance is: 0
    found no related database

这里可以看到我们用于测试的账号私钥文件对应的钱包地址是 `290f7dbbff2aa0d5a5af65f4caa0bfd68663f97f9b08d0ee71e76a172349b613`。
以及所有币种的余额

## 查看钱包余额

子命令 `wallet` 也可以用来查看你的钱包里的代币余额。目前 CovenantSQL 支持的代币类型为以下 5 种：

- `Particle`
- `Wave`
- `Bitcoin`
- `Ether`
- `EOS`

其中 `Particle` 和 `Wave` 为 CovenantSQL 默认使用的代币, 会在wallet命令中默认显示。

可以单独指定代币类型，如查看 `Bitcoin` 余额：

```bash
cql wallet -token Bitcoin
```

输出：

    INFO[0000] Geting bp address from dns: bp05.testnet.gridb.io
    INFO[0006] Register self to blockproducer: 0000000000293f7216362791b6b1c9772184d6976cb34310c42547735410186c
    INFO init config success                           path=~/.cql/config.yaml

    wallet address: 290f7dbbff2aa0d5a5af65f4caa0bfd68663f97f9b08d0ee71e76a172349b613
    Bitcoin balance is: 0

## 向其他账号转账

从 [TestNet](quickstart) 获得代币或 [私有部署](advanced_deployment) 的网络获得代币后，可以使用 `transfer` 命令来向其他账号转账。转账操作有3个必要的转账信息作为参数，例如：

```bash
cql transfer -to-user 011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6 -amount 1000000 -token Particle
```

其中收款地址可以是`-to-user`指定一个个人钱包地址，也可以是`-to-dsn`指定一个数据库子链地址。转账至数据库地址时将在该数据库账户上补充付款人的押金与预付款。

> 可以在这里查看 [押金与预付款](terms#押金与预付款) 的相关说明。

例如给数据库地址转账：

```bash
cql transfer -to-dsn covenantsql://0bfea233d20676bb848b66d072bb768945507bb8a3b8b22b13133cde0583e208 -amount 1000000 -token Particle
```

输出：

    INFO[0000] Geting bp address from dns: bp04.testnet.gridb.io
    INFO[0043] Register self to blockproducer: 00000000003b2bd120a7d07f248b181fc794ba8b278f07f9a780e61eb77f6abb
    INFO init config success                           path=~/.cql/config.yaml
    INFO succeed in sending transaction to CovenantSQL

注意，以上输出信息只说明交易请求已经成功发送至 CovenantSQL 网络，需要等待 BP 节点执行并确认交易后才能实际生效。交易能否成功、何时成功可以通过执行 `cql wallet -balance <token_type>` 来确定，也可以在执行命令时添加 `-wait-tx-confirm` 参数来让 `cql` 命令查询到执行结果之后再退出。

## 子命令 `wallet` 完整参数

    usage: cql wallet [通用参数] [-token type] [-dsn dsn]

    查看账号钱包地址和代币余额。
    示例：
        cql wallet

        cql wallet -token Particle

        cql wallet -dsn "covenantsql://4119ef997dedc585bfbcfae00ab6b87b8486fab323a8e107ea1fd4fc4f7eba5c"

    Wallet params:
      -token string
            获取当前账号中指定代币类型的余额
      -dsn string
        	Show specified database deposit

## 子命令 `transfer` 完整参数

    usage: cql transfer [通用参数] [-wait-tx-confirm] [-to-user wallet | -to-dsn dsn] [-amount count] [-token token_type]

    向目标账号地址进行转账。输入参数为目标、数量及类型。
    示例：
        cql transfer -to-user=43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40 -amount=100 -token=Particle

    由于 CovenantSQL 是区块链上的数据库，在交易生效之前你可能需要等待执行确认。
    示例：
        cql transfer -wait-tx-confirm -to-dsn=43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40 -amount=100 -token=Particle

    Transfer params:
      -amount uint
        	Token account to transfer.
      -to-dsn string
        	Target database dsn to transfer token.
      -to-user string
        	Target address of an user account to transfer token.
      -token string
        	Token type to transfer.
      -wait-tx-confirm
            等待交易执行确认（或者出现任何错误）后再退出
