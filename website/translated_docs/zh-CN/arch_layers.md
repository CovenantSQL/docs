---
id: arch_layers
title: Blockchains
---


## MainChain & SQLChain

CQL uses a layered architecture for database creation and operation. A typical data creation process can be roughly as follows:

1. Miner will automatically register with the MainChain after startup. The registration information includes: "Minimum acceptable Gas price", "System metrics", "External IP and port", etc.
2. Miner subscribes to and pays attention to information related to themselves through ChainBus;
3. The client runs `cql create '{"node":2}'` to send a signed database creation request to any BP (Block Producer) in the MainChain;
4. The BP that received the request performs a match of Miner and database creation request in the process of producing the block (see: \[MainChain Produce Block\] (#mainchain-produce-block));
5. Database creation requests and matching results are verified and confirmed at other BP nodes;
6. The Miner subscription receives the database task;
7. Miners discover and connect with each other through Kayak to form a SQLChain database cluster;
8. All miners are ready to wait for a request;
9. Users can connect to the database and execute SQL through the `cql console` command.

See the image below to view [large picture](https://cdn.jsdelivr.net/gh/CovenantSQL/docs@b7143254adb804dff0e3bc1f2f6ab11ad9cd44f5/website/static/img/2layers.svg)：

![2layers](https://cdn.jsdelivr.net/gh/CovenantSQL/docs@b7143254adb804dff0e3bc1f2f6ab11ad9cd44f5/website/static/img/2layers.svg)

## MainChain Produce Block

The complete main chain export process is complicated. Please refer to the numbers in the figure below for understanding. For the big picture, please click [here](https://cdn.jsdelivr.net/gh/CovenantSQL/docs/website/static/img/produce-block.svg)

![MainChain Produce Block](https://cdn.jsdelivr.net/gh/CovenantSQL/docs/website/static/img/produce-block.svg)