---
id: usecase_traditional_app
title: Traditional App
---

## 数据隐私

如果你是一个使用密码管理工具的开发者，比如 [1Password](https://1password.com/) or [LastPass](https://www.lastpass.com/). 你可以使用 CQL 作为数据库并有以下优点：

1. 无服务器: 不需要部署服务器来存储用户密码，以进行同步，这是一个烫手山芋。
2. 安全: CQL 可以保证所有的加密工作，去中心化的数据存储给予用户更多信心。
3. 合规: CQL 天然符合 [GDPR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation) 标准。

## 物联网存储

CQL 矿工全球化部署，IoT 节点可以写入最近的矿工。 

1. 实惠: 不需要通过网关传输流量，你可以节省大量的带宽费用。同时，SQL 具有共享经济的特性，以此让存储更实惠。
2. 更快: CQL 共识协议是基于互联网而设计，网络延迟不可避免。


## 开放数据服务

例如，你是一个非常在意细节的比特币 OHLC 数据维护者，你可以直接放一个 SQL 接口给你的用户以满足各种查询需求。

1. CQL 在平衡数据安全性的同时，可以限制特定的 SQL 查询语句以满足需求。
2. CQL 将 SQL 操作，增删查改等记录在区块链上，方便用户检查账单比如 [这个](https://explorer.dbhub.org/dbs/7a51191ae06afa22595b3904dc558d41057a279393b22650a95a3fc610e1e2df/requests/f466f7bf89d4dd1ece7849ef3cbe5c619c2e6e793c65b31966dbe4c7db0bb072)
3. 对于那些对高性能有要求的客户，可以在用户那里部署 `Slave` 节点，以满足低延迟查询的需求，同时实现几乎实时的数据更新。

## 安全存储

由于 CQL 数据历史是不可篡改的，CQL 可以用来存储敏感的操作日志，以防止黑客攻击和删除访问日志。
