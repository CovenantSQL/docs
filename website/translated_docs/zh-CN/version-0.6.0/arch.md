---
id: arch
title: Architecture
---


## 3 层架构


![CovenantSQL 3 Layer design](https://github.com/CovenantSQL/CovenantSQL/raw/ed2878359345cd86e4221f14cd59e4654361b64e/logo/arch.png)

- 第一层: **全局共识层**(主链，架构图中的中间环):
    - 整个网络中只有一个主链。
    - 主要负责数据库矿工与用户的合同匹配，交易结算，反作弊，子链哈希锁定等全局共识事宜。
- 第二层: **SQL 共识层**(子链，架构图中的两边环):
    - 每个数据库都有自己独立的子链。
    - 主要负责数据库各种事务的签名，交付和一致性。这里主要实现永久可追溯性的数据历史，并且在主链中执行哈希锁定。
- 第三层: **数据储存层**(支持 SQL-92 的数据库引擎):
    - 每个数据库都有自己独立的分布式引擎。
    - 主要负责：数据库存储和加密；查询处理和签名；高效索引。


## 共识算法

CQL 支持两种共识算法：

1. DPoS (委任权益证明) 应用在数据库的 `最终一致性` 和 Block Producer 所在的 `第一层 (全局共识层)` ，CQL 的矿工在客户端将所有SQL查询及其签名打包成块，从而形成整个区块链，我们把这个算法命名为 [`Xenomint`](https://github.com/CovenantSQL/CovenantSQL/tree/develop/xenomint)
2. BFT-Raft (拜占庭容错算法)<sup>[bft-raft](#bft-raft)</sup> 应用于数据库的 `强一致性`。我们把这个实现命名为 [`Kayak`](https://github.com/CovenantSQL/CovenantSQL/tree/develop/kayak).  矿工 leader 会基于 `Kayak` 做 `两阶段提交` 来支持 `Transaction`.<sup>[transaction](#transaction)</sup>

可以用命令行  `cql create '{"UseEventualConsistency": true, "Node": 3}'` 来创建 `最终一致性` CQL 数据库


## 项目对比

|                              | 以太坊            | Hyperledger Fabric     | AWS QLDB | CovenantSQL                                                  |
| ---------------------------- | ----------------- | ---------------------- | ----------- | ------------------------------------------------------------ |
| **开发语言**                  | Solidity, ewasm   | Chaincode (Go, NodeJS) | ?           | Python, Golang, Java, PHP, NodeJS, MatLab                    |
| **开发模式**                  | Smart   Contract  | Chaincode              | SQL         | SQL                                                          |
| **是否开源**                  | Y                 | Y                      | N           | Y                                                            |
| **高可用节点**                | 3                 | 15                     | ?           | 3                                                            |
| **列级别 ACL**                | N                 | Y                      | ?           | Y                                                            |
| **数据格式**                  | File              | Key-value              | Document    | File<sup>[fuse](#fuse)</sup>, Key-value, Structured     |
| **存储加密**                  | N                 | API                    | Y           | Y                                                            |
| **数据脱敏**                  | N                 | N                      | N           | Y                                                            |
| **多租户**                  | DIY               | DIY                    | N           | Y                                                            |
| **吞吐量（1秒延迟）**          | 15~10 tx/s        | 3500 tx/s              | ?           | 11065 tx/s (Eventually Consistency)<br/>1866 tx/s (Strong Consistency) |
| **一致性延迟**                | 2~6 min           | < 1 s                  | ?           | < 10 ms                                                      |
| **开放网络上的安全性**         | Y                 | N                      | Only in AWS | Y                                                            |
| **共识机制**                  | PoW + PoS(Casper) | CFT                    | ?           | DPoS (Eventually Consistency)<br/>BFT-Raft (Strong Consistency) |

### 注释：
- <a name="bft-raft">BFT-Raft</a>: 在一个 CQL leader 离线的情况下，有两种可能的选择：等待 leader 上线，以保证数据的完整性，或者提拔 follwers 以保证服务可用性；目前是需要一定的人工介入来进行策略选择，这部分仍在迭代中，欢迎任何建议。

- <a name="transaction">事务 (Transaction)</a>: 说到 `ACID`，CQL 具有完整的 "一致性，隔离性，持久化" 和特定的 `Atomicity` 支持。即使在强一致性的模式下，CQL 事务只支持在 leader 节点上执行。如果你想要并发执行事务："读取 `v`, `v++`, 写回 `v` ", 仅有的办法是："从 leader 读取 `v` , `v++`, 从 leader 写回 `v`"

- <a name="fuse">FUSE</a>: CQL 有一个从 CockroachDB 移植过来的 [FUSE 客户端](https://github.com/CovenantSQL/CovenantSQL/tree/develop/cmd/cql-fuse)，目前性能不是很理想，仍然存在一些小问题。但它可以通过如下的 fio 测试：

  ```bash
  fio --debug=io --loops=1 --size=8m --filename=../mnt/fiotest.tmp --stonewall --direct=1 --name=Seqread --bs=128k --rw=read --name=Seqwrite --bs=128k --rw=write --name=4krandread --bs=4k --rw=randread --name=4krandwrite --bs=4k --rw=randwrite
  ```
