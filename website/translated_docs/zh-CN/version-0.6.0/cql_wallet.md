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

    Enter master key(press Enter for default: ""): 

    wallet address: 43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40

这里可以看到我们用于测试的账号私钥文件对应的钱包地址是 `43602c17adcc96acf2f68964830bb6ebfbca6834961c0eca0915fcc5270e0b40`。

## 查看钱包余额

子命令 `wallet` 也可以用来查看你的钱包里的代币余额。目前 CovenantSQL 支持的代币类型为以下 5 种：

- `Particle`
- `Wave`
- `Bitcoin`
- `Ether`
- `EOS`

其中 `Particle` 和 `Wave` 为 CovenantSQL 默认使用的代币，查看默认代币余额的命令为：

```bash
cql wallet -balance all
```

输出：

    INFO[0000] Particle balance is: 10000000000000000000
    INFO[0000] Wave balance is: 10000000000000000000

也可以单独指定代币类型，如查看 `Bitcoin` 余额：

```bash
cql wallet -balance Bitcoin
```

输出：

    INFO[0000] Bitcoin balance is: 0

## 向其他账号转账

从 [TestNet](quickstart) 获得代币或 [Docker 一键部署](deployment)的网络获得代币后，可以使用 `transfer` 命令来向其他账号转账。转账操作使用 `json` 格式的转账信息作为参数，例如：

```json
{
  "addr": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6", // 收款地址
  "amount": "1000000 Particle" // 转账金额并带上单位
}
```

其中收款地址可以是一个个人钱包地址也可以是一个数据库子链地址。转账至数据库地址时将在该数据库账户上补充付款人的押金与预付款。

> 可以在这里查看 [押金与预付款](terms#押金与预付款) 的相关说明。

把以上参数传给 `transfer` 子命令来进行转账：

```bash
cql transfer '{"addr": "011f72fea9efa1a49a6663d66e514a34e45e426524c13335cf20bec1b47d10d6","amount": "1000000 Particle"}'
```

输出：

    INFO[0000] succeed in sending transaction to CovenantSQL

注意，以上输出信息只说明交易请求已经成功发送至 CovenantSQL 网络，需要等待 BP 节点执行并确认交易后才能实际生效。交易能否成功、何时成功可以通过执行 `cql wallet -balance <token_type>` 来确定，也可以在执行命令时添加 `-wait-tx-confirm` 参数来让 `cql` 命令查询到执行结果之后再退出。

## 子命令 `wallet` 完整参数

    usage: cql wallet [通用参数] [-balance type]

    查看账号钱包地址和代币余额。
    示例：
        cql wallet
        cql wallet -balance Particle
        cql wallet -balance all

    Params:
      -balance string
            获取当前账号中指定代币类型的余额

## 子命令 `transfer` 完整参数

    usage: cql transfer [通用参数] [-wait-tx-confirm] meta_json

    向目标账号地址进行转账。输入参数为 JSON 格式的转账交易数据。
    示例：
        cql transfer '{"addr": "your_account_addr", "amount": "100 Particle"}'

    由于 CovenantSQL 是区块链上的数据库，在交易生效之前你可能需要等待执行确认。
    示例：
        cql transfer -wait-tx-confirm '{"addr": "your_account_addr", "amount": "100 Particle"}'

    Params:
      -wait-tx-confirm
            等待交易执行确认（或者出现任何错误）后再退出
