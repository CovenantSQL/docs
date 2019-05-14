---
id: arch_layers
title: Chains
---


## 主链和 SQL 链

CQL 采用分层的架构进行数据库的创建和运行，一个典型的数据的创建过程大致可以如下过程：

1. "矿工" 启动后会自动向主链注册，注册信息包括："最低可以接受的 Gas 价格"、"系统配置信息"、"对外 IP 及端口" 等；
2. "矿工" 通过 ChainBus 订阅并关注和自己相关的信息； 
3. 客户端运行 `cql create '{"node":2}'` ，向主链的任一 "出块节点"（BP: Block Producer）发送经过签名的数据库创建请求；
4. 收到请求的 BP 在出块的过程（详见：[主链出块流程](#主链出块流程)）中进行 "矿工" 和数据库创建请求的撮合；
5. 数据库创建请求 和 撮合结果 在 其它 BP 节点进行验证和确认；
6. "矿工" 订阅收到数据库任务；
7. "矿工" 通过 SQLChain 彼此发现、连接，组建 Kayak 数据库集群；
8. 所有 "矿工" 准备就绪等待请求；
9. 用户可以通过 `cql console` 命令来连接数据库，执行 SQL。

参见下图，查看[大图](https://cdn.jsdelivr.net/gh/CovenantSQL/docs@b7143254adb804dff0e3bc1f2f6ab11ad9cd44f5/website/static/img/2layers.svg)：

![2layers](<https://cdn.jsdelivr.net/gh/CovenantSQL/docs@b7143254adb804dff0e3bc1f2f6ab11ad9cd44f5/website/static/img/2layers.svg>)


## 主链出块流程

完整的主链出块流程较为复杂，请参考下图中的编号进行理解，

为了容易理解，



![MainChain Produce Block](https://cdn.jsdelivr.net/gh/CovenantSQL/docs/website/static/img/produce-block.svg)

查看大图请点击[这里](https://cdn.jsdelivr.net/gh/CovenantSQL/docs/website/static/img/produce-block.svg)