---
id: qna
title: 🙋 常见问题解答
---

## 常见问题

- **Q:** CQL 数据库支持怎样的一致性等级，是怎样组织的？

  **A:** 参见 [一致性协议](./arch#consensus-algorithm)

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

- **Q:** CQL 数据如果是不可篡改的，如何处理数据删除的需求？

  **A:** CQL 的完整数据是存在 SQLChain 的 Miner 上的，这部分数据具有

- **Q:** CQL 是如何存储数据库的数据的？

  **A:** d

- **Q:** CQL 支持数据量的上限大致是多少？

  **A:** d

- **Q:** CQL 的数据存储如何计费、收费？

  **A:** d

  