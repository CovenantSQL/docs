---
id: qna
title: 常见问题解答
---

## 常见问题

- **Q:** CQL 数据库支持怎样的一致性等级，以及 CQL 数据库是怎样创建的？

  **A:** 参见 [一致性协议](./arch#共识算法)

- **Q:** CQL 的数据库安全是如何做的？

  **A:** 不同于传统的数据库，CQL 是运行在开放互联网上的分布式数据库系统。安全方面主要做了如下的工作：

  1. 密钥体系：CQL 使用 Bitcoin 的 `scep256k1` 曲线的非对称加密算法产生的公私钥对。

  2. 网络通信：参见 [网络安全](./arch_network)。

  3. 数据库权限 & 加密：

     1. [数据库安全网关](./advanced_secure_gateway)。
     2. 支持 SQL 加密函数 `encrypt`, `decrypt`，例如：

         ```sql
         INSERT INTO "t1" ("k", "v") VALUES (1, encrypt("data", "pass", "salt"));
         SELECT decrypt("v", "pass", "salt") FROM "t1" WHERE "k"=1;
         ```

- **Q:** CQL 数据如果是不可篡改的，如何处理类似 GDPR 里数据删除的需求？

  **A:** CQL 支持两种开发模式，一种是传统的 `DB per App`（一个 App 一个数据库），另外一种是偏向隐私保护的 `DB per User`（一个用户一个数据库）。

  `DB per User` 的开发模式非常适用于类似 "密码管理器"，"个人信息管理" 等应用的开发。由于用户是通过类似比特币用一个私钥管理自己财产的方式，通过一个 CQL 私钥管理自己的个人数据，所以这种模式开发的 App 天然具有不存储任何用户数据，从技术上天然符合包括以下法律法规的严苛要求：

  - [欧盟 GDPR（General Data Protection Regulation）](https://gdpr-info.eu/)
  - [美国加州 CCPA（California_Consumer_Privacy_Act）](https://en.wikipedia.org/wiki/California_Consumer_Privacy_Act)
  - [HIPAA（Health Insurance Portability and Accountability Act of 1996）](https://en.wikipedia.org/wiki/Health_Insurance_Portability_and_Accountability_Act)
  - [香港 Personal Data (Privacy) Ordinance](https://www.elegislation.gov.hk/hk/cap486)

  CQL 的完整数据是存在 SQLChain 的 Miner 上的，这部分数据相关的 SQL 历史是完整保存在 Miner 上的。相对于传统数据库的 `CRUD` （Create、Read、Update、Delete），CQL 支持的是 `CRAP` （Create、Read、Append、Privatize）。

  > **Append** vs **Update**
  >
  > 传统数据库对数据进行更改（Update）后是没有历史记录存在的，换句话说数据是可被篡改的。CQL 支持的是对数据进行追加（Append），其结果是数据的历史记录是得以保全。

  > **Privatize** vs **Delete**
  >
  > 传统数据库对数据进行删除（Delete）也属于对数据不可追溯、不可逆的篡改。CQL 支持的是对数据进行私有化（Privatize），也就是把数据库的权限转给一个不可能的公钥。这样就可以实现对子链数据的实质性删除。针对单条数据的链上所有痕迹抹除目前仅在企业版提供支持。

- **Q:** CQL 是如何存储数据库的数据的？

  **A:** 用户数据库的绝大部分操作是在 SQLChain 上完成的。默认情况下，主链仅会保存子链的区块哈希。更多细节请参考[主链和 SQL 链](./arch_layers#主链和-sql-链)。

- **Q:** CQL 支持数据量的上限大致是多少？

  **A:** CQL 的数据库数据是存储在一个个独立的 SQLChain 上的。CQL 的数据库的数量取决于全网的 "矿工" 数量。单个 CQL 数据库的上限取决于硬件配置，截止 2019-04-25 线上最大的表是在 AWS c5.2xlarge 标准配置的主机上持续运行的由 2 Miner 组成的一个数据库，数据行数为 433,211,000，占用磁盘 3.2 TB。

  