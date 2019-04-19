---
id: version-0.5.0-arch
title: Architecture
original_id: arch
---
## 3 Layers Arch

![CovenantSQL 3 Layer design](https://github.com/CovenantSQL/CovenantSQL/raw/ed2878359345cd86e4221f14cd59e4654361b64e/logo/arch.png)

- Layer 1: **Global Consensus Layer** (the main chain, the middle ring in the architecture diagram): 
    - There will only be one main chain throughout the network.
    - Mainly responsible for database Miner and the user’s contract matching, transaction settlement, anti-cheating, shard chain lock hash and other global consensus matters.
- Layer 2: **SQL Consensus Layer** (shard chain, rings on both sides): 
    - Each database will have its own separate shard chain.
    - Mainly responsible for: the signature, delivery and consistency of the various Transactions of the database. The data history of the permanent traceability is mainly implemented here, and the hash lock is performed in the main chain.
- Layer 3: **Datastore Layer** (database engine with SQL-92 support): 
    - Each Database has its own independent distributed engine.
    - Mainly responsible for: database storage & encryption, query processing & signature, efficient indexing.

## Consensus Algorithm

CQL supports 2 kinds of consensus algorithm:

1. DPoS (Delegated Proof-of-Stake) is applied in `Eventually consistency mode` database and also `Layer 1 (Global Consensus Layer)` in BlockProducer. CQL miners pack all SQL queries and its signatures by the client into blocks thus form a blockchain. We named the algorithm [`Xenomint`](https://github.com/CovenantSQL/CovenantSQL/tree/develop/xenomint). 
2. BFT-Raft (Byzantine Fault-Toleranted Raft)<sup><a href="#bft-raft">bft-raft</a></sup> is applied in `Strong consistency mode` database. We named our implementation [`Kayak`](https://github.com/CovenantSQL/CovenantSQL/tree/develop/kayak). The CQL miner leader does a `Two-Phase Commit` with `Kayak` to support `Transaction`.<sup><a href="#transaction">transaction</a></sup>

CQL database consistency mode and node count can be selected in database creation with command `cql create '{"UseEventualConsistency": true, "Node": 3}'`

## Comparison

|                              | Ethereum          | Hyperledger Fabric     | Amazon QLDB | CovenantSQL                                                          |
| ---------------------------- | ----------------- | ---------------------- | ----------- | -------------------------------------------------------------------- |
| **Dev language**             | Solidity, ewasm   | Chaincode (Go, NodeJS) | ?           | Python, Golang, Java, PHP, NodeJS, MatLab                            |
| **Dev Pattern**              | Smart Contract    | Chaincode              | SQL         | SQL                                                                  |
| **Open Source**              | Y                 | Y                      | N           | Y                                                                    |
| **Nodes for HA**             | 3                 | 15                     | ?           | 3                                                                    |
| **Column Level ACL**         | N                 | Y                      | ?           | Y                                                                    |
| **Data Format**              | File              | Key-value              | Document    | File<sup><a href="#fuse">fuse</a></sup>, Key-value, Structured       |
| **Storage Encryption**       | N                 | API                    | Y           | Y                                                                    |
| **Data Desensitization**     | N                 | N                      | N           | Y                                                                    |
| **Multi-tenant**             | DIY               | DIY                    | N           | Y                                                                    |
| **Throughput (1s delay)**    | 15~10 tx/s        | 3500 tx/s              | ?           | 11065 tx/s (Eventually Consistency)  
1866 tx/s (Strong Consistency) |
| **Consistency Delay**        | 2~6 min           | < 1 s                  | ?           | < 10 ms                                                              |
| **Secure for Open Internet** | Y                 | N                      | Only in AWS | Y                                                                    |
| **Consensus**                | PoW + PoS(Casper) | CFT                    | ?           | DPoS (Eventually Consistency)  
BFT-Raft (Strong Consistency)        |

### FootNotes

- <a name="bft-raft">BFT-Raft</a>: A CQL leader offline needs CQL Block Producer to decide whether to wait for leader online for data integrity or promote a follower node for availability. This part is still under construction and any advice is welcome.

- <a name="transaction">Transaction</a>: Talking about `ACID`, CQL has full "Consistency, Isolation, Durability" and a limited `Atomicity` support. That is even under strong consistency mode, CQL transaction is only supported on the leader node. If you want to do "read `v`, `v++`, write `v` back" parallelly and atomically, then the only way is "read `v` from the leader, `v++`, write `v` back to leader"

- <a name="fuse">FUSE</a>: CQL has a [simple FUSE](https://github.com/CovenantSQL/CovenantSQL/tree/develop/cmd/cql-fuse) support adopted from CockroachDB. The performance is not very ideal and still has some issues. But it can pass fio test like:
    
    ```bash
    fio --debug=io --loops=1 --size=8m --filename=../mnt/fiotest.tmp --stonewall --direct=1 --name=Seqread --bs=128k --rw=read --name=Seqwrite --bs=128k --rw=write --name=4krandread --bs=4k --rw=randread --name=4krandwrite --bs=4k --rw=randwrite
    ```