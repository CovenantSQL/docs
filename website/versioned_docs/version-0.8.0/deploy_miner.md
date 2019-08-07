---
id: version-0.8.0-deploy_miner
title: Deploy custom miner
original_id: deploy_miner
---

## 部署 CovenantSQL Miner 节点

文档对应版本：
	
	covenantsql/covenantsql 84b7da393152

本教程可以为中国测试网(testnet cn)或者国外测试网(testnet w) 部署 miner 节点，注意区分网络环境。

本教程在当前目录(`$PWD`) 会产生三个目录，分别是：

	miner_config:         您自己的 miner 节点配置
	super_client_config:  测试网超级客户端配置
	client_config:        您 miner 的使用者客户端配置

各个命令都会使用上述配置之一，代表了命令的执行角色。

### 环境依赖

#### 机器配置

推荐运行服务在 AWS 的 `c5.2xlarge` 型机器或其他同等配置的机器上 (8 核, 16 GB 内存)。

另外建议单独挂载数据盘用于 DB 存储。

#### Docker

CovenantSQL 使用 docker 来简化部署，可通过 Docker 的 [官方文档](https://docs.docker.com/install/) 来进行安装。

#### Docker 镜像

使用 docker 获取 CovenantSQL 的服务镜像以提供数据存储节点服务

```shell
docker pull covenantsql/covenantsql:latest
```

### 配置服务

#### 生成 Miner 配置文件

执行以下命令在当前目录中创建一个 miner_config 目录，并生成 Miner 启动所需的配置文件 `config.yaml` 和 私钥 `private.key`

> 请将命令中的 `miner_external_ip` 和 `miner_listen_port` 替换成实际 miner 运行时对外提供服务的 ip 或域名以及端口号；需要注意的是，之后使用者的命令行客户端或 Adapter 都将使用这个地址连接 Miner，请确保这个地址在使用者的机器上可以访问（没有被云平台或其他防火墙限制访问）。可以使用 telnet 或者 nc 的形式在 Miner 启动后检查服务的可用性

```shell
mkdir -v ./miner_config

docker run -it --rm -v $(pwd)/miner_config/:/app/config/ \
  --entrypoint /app/cql covenantsql/covenantsql:latest -- \
  generate -miner "<miner_external_ip>:<miner_listen_port>" /app/config/
```

> 如果需要生成国外区测试网配置，将上述命令的 `generate` 后面增加 `-testnet w` 参数。并且注意下述第一行输出会变成 `Generating testnet w config`

命令将会生成一个 miner 的配置文件和私钥，并在命令行中输出 Miner 的节点 id、公钥 hex 和 钱包地址，例如：

```shell
Generating testnet cn config
Generated private key.
Generating nonce...
INFO cpu: 8
INFO position: 3, shift: 0x20, i: 7
INFO position: 1, shift: 0x20, i: 3
INFO position: 3, shift: 0x0, i: 6
INFO position: 2, shift: 0x0, i: 4
INFO position: 2, shift: 0x20, i: 5
INFO position: 0, shift: 0x0, i: 0
INFO position: 1, shift: 0x0, i: 2
INFO position: 0, shift: 0x20, i: 1
nonce: {{2677734 0 6632872946 0} 26 0000003e2c8d0b39711edf19ef266a44996b93f7f830149f5d01491a6b7da99d}
node id: 0000003e2c8d0b39711edf19ef266a44996b93f7f830149f5d01491a6b7da99d
Generated nonce.
Generating config file...
Generated config.

Config file:      /app/config/config.yaml
Private key file: /app/config/private.key
Public key's hex: 0338816967be3c24bd490f841de57f2c42daf024dd7f462305aab9a601c423ab8d
Wallet address: eb46e59dbc4eac17b51762f051937a0082ff7423742866e4baff6c6053719451

Any further command could costs PTC.
You can get some free PTC from:
	https://testnet.covenantsql.io/wallet/eb46e59dbc4eac17b51762f051937a0082ff7423742866e4baff6c6053719451
```

可以得到 miner 的钱包地址：`eb46e59dbc4eac17b51762f051937a0082ff7423742866e4baff6c6053719451`


#### 给 Miner 帐户充值

为了大家使用方便，我们创建了一个公共使用的超级客户端节点，拥有大量测试余额，首先需要下载这个超级客户端节点的配置：

国内测试网：

```shell
mkdir -v ./super_client_config/
curl -kL -# 'https://raw.githubusercontent.com/covenantsql/covenantsql/develop/conf/testnet/config.yaml' -o ./super_client_config/config.yaml
curl -kL -# 'https://raw.githubusercontent.com/covenantsql/covenantsql/develop/conf/testnet/private.key' -o ./super_client_config/private.key
```
国外测试网：

```shell
mkdir -v ./super_client_config/
curl -kL -# 'https://raw.githubusercontent.com/covenantsql/covenantsql/develop/conf/testnet/w/config.yaml' -o ./super_client_config/config.yaml
curl -kL -# 'https://raw.githubusercontent.com/covenantsql/covenantsql/develop/conf/testnet/w/private.key' -o ./super_client_config/private.key
```

执行以下命令将会给 miner 的钱包地址转入 `10000000000` 个 `Particle`

> 请将命令中的 `miner_wallet_address` 替换成上一步中生成的 miner 的钱包地址，例如上例中的 `eb46e59dbc4eac17b51762f051937a0082ff7423742866e4baff6c6053719451`

```shell
docker run -it --rm -v $(pwd)/super_client_config/:/app/config/ \
  --entrypoint /app/cql covenantsql/covenantsql:latest -- \
  transfer -config /app/config/config.yaml \
  -wait-tx-confirm -to-user "<miner_wallet_address>" \
  -amount 10000000000 \
  -token Particle
```

命令将会从测试网帐户中划转金额给 miner 使用，miner 后续将会使用这笔费用作为押金来提供服务，将会得到类似以下的输出：

```shell
INFO[0000] Geting bp address from dns: bp04.testnet.gridb.io
INFO[0002] Register self to blockproducer: 00000000000589366268c274fdc11ec8bdb17e668d2f619555a2e9c1a29c91d8
INFO init config success                           path=/app/config/config.yaml


INFO wait transaction confirmation                 error="<nil>" tx_hash=09001b9904194400e85018984c5428616000669e5de0efac0dc65c72f11950a2 tx_state=Confirmed
INFO succeed in sending transaction to CovenantSQL
```

查询 miner 的账户余额以确定转账成功

```shell
docker run -it --rm -v $(pwd)/miner_config/:/app/config/ \
  --entrypoint /app/cql covenantsql/covenantsql:latest -- \
  wallet -config ./config/config.yaml
```

将会得到类似以下的输出：

```shell
INFO[0000] Geting bp address from dns: bp05.testnet.gridb.io
INFO[0002] Register self to blockproducer: 0000000000293f7216362791b6b1c9772184d6976cb34310c42547735410186c
INFO init config success                           path=/app/config/config.yaml


wallet address: eb46e59dbc4eac17b51762f051937a0082ff7423742866e4baff6c6053719451
Particle balance is: 100000000
Wave balance is: 0
```

Particle balance 这行输出中可以看到转账的金额，这样 miner 就可以提供服务了。

#### 添加 Miner 可服务的用户限制

在默认启动的情况下，Miner 是面向全网用户提供服务的。如果只希望给指定的 Miner 提供服务，需要在 Miner 上设置 TargetUsers 配置，并指定需要服务的用户的钱包地址。

修改 `miner` 的配置文件 `./miner_config/config.yaml`，在 `Miner` 配置段下添加 `TargetUsers` 配置，指定一个需要服务的用户的 List，例如如下修改：

```diff
--- old.yaml	2019-05-14 00:12:33.000000000 +0800
+++ new.yaml	2019-05-14 00:12:19.000000000 +0800
@@ -1,4 +1,5 @@
 Miner:
   RootDir: './data'
   MaxReqTimeGap: '5m'
   ProvideServiceInterval: '10s'
+  TargetUsers: ['eb46e59dbc4eac17b51762f051937a0082ff7423742866e4baff6c6053719451']
```

### 启动 Miner 服务

#### 创建 Container

执行以下命令以创建 miner 的

> 请将下述命令中的 `miner_name`  替换成所需的 miner docker container 名用于管理；`data_disk_dir` 替换成用于存放 miner 数据的目录的绝对地址(推荐挂载一个盘用于提供服务)；`miner_listen_port` 替换成miner 对外提供服务的端口号

```shell
docker create --name "<miner_name>" \
  --restart always \
  -v $(pwd)/miner_config/:/app/config/ \
  -v "<data_disk_dir>:/app/config/data/" \
  -e COVENANT_ROLE=miner \
  -e COVENANT_CONF=/app/config/config.yaml \
  -e METRIC_WEB_ADDR=0.0.0.0:4665 \
  --log-driver "json-file" \
  --log-opt "max-size=1g" \
  --log-opt "max-file=3" \
  -p "<miner_listen_port>:<miner_listen_port>" \
  covenantsql/covenantsql:latest
```

#### 启动 Miner

> 同样，请将 `miner_name`  替换为实际使用的 miner container 名

```shell
docker start "<miner_name>"
```

#### 检查 Miner 状态

> 同样，请将 `miner_name`  替换为实际使用的 miner container 名

```shell
docker ps -a -f "name = <miner_name>"
docker logs --tail=10 -f "<miner_name>"
```

在单台或多台机器上重复上述步骤，启动多个实例，可以提供至多对应节点数量的 DB SideChain 服务。

#### 服务升级

执行以下命令更新镜像，然后重复 **创建 Container** 步骤 和 **启动 Miner** 步骤

```shell
 docker pull covenantsql/covenantsql:latest
```

### 使用

#### 使用者账户和配置

使用 CovenantSQL 需要创建一个 DB 使用者的账户。这个账户必须与提供服务的 Miner 节点的账号不同，与此同时一个 Miner 账户也不能同时启动多个 Miner 服务，否则将会导致 Miner 或 DB 使用者的 Transaction 执行异常，用户不能正确创建 DB 或 Miner 不能正确上报使用者的费用信息等。

##### 生成使用者账户配置

执行如下命令将在 `./client_config` 目录下生成使用者账户的私钥和配置

> 如果需要生成国外区测试网配置，将上述命令的 `generate` 后面增加 `-testnet w` 参数。并且注意第一行输出会变成 `Generating testnet w config`

```shell
mkdir -v client_config

docker run -it --rm -v $(pwd)/client_config/:/app/config/ \
  --entrypoint /app/cql covenantsql/covenantsql:latest -- \
  generate /app/config/
```

命令最后一行会显示 wallet address，注意需要将此 wallet address 加入到 miner 的 `TargetUsers` 配置中，并重启 miner。

##### 向使用者账户中充值

类似向 Miner 账户充值，请执行如下命令：

> 请将 `client_wallet_address` 替换为创建的使用者账号的钱包地址

```shell
docker run -it --rm -v $(pwd)/super_client_config/:/app/config/ \
  --entrypoint /app/cql covenantsql/covenantsql:latest -- \
  transfer -config /app/config/config.yaml \
  -wait-tx-confirm -to-user "<client_wallet_address>" \
  -amount 10000000000 \
  -token Particle
```

#### 创建 DB 和使用

由于需要在指定的 Miner 上创建 DB，需要在创建 DB 时指定提供服务的 Miner 列表

> `create` 命令接收一系列描述 DB 实例的参数，可以用 `cql help create` 查看详细参数；将 `node_count` 替换为所需的节点数量，例如 1 代表创建一个节点的 DB SideChain；`miner1_wallet_address, miner2_wallet_address ` 等替换为指定 miner 的钱包地址列表；另外需要格外注意的时，所需创建的 DB SideChain 的节点数量需要小于或等于提供的指定 miner 数量，否则 CovenantSQL 会在指定 miner 之外的公用 miner 中随机分配节点以满足用户所需节点数量要求。

```shell
docker run -it --rm -v $(pwd)/client_config/:/app/config/ \
  --entrypoint /app/cql covenantsql/covenantsql:latest -- \
  create -config /app/config/config.yaml -wait-tx-confirm \
  -db-node <node_count> -db-target-miners "<miner1_wallet_address>, <miner2_wallet_address>, ..."
```

命令执行完成后将会有类似如下的输出：

```shell
time="2019-05-07T03:41:03Z" level=info msg="Geting bp address from dns: bp04.testnet.gridb.io"
time="2019-05-07T03:41:05Z" level=info msg="Register self to blockproducer: 00000000003b2bd120a7d07f248b181fc794ba8b278f07f9a780e61eb77f6abb"
level=info msg="init config success" path=/root/.cql/config.yaml
level=info msg="create database requested"
The newly created database is: "covenantsql://163193957a22fccf165ad754ee514f13972c0eadee6455203b17b7bba76028df"
The connecting string beginning with 'covenantsql://' could be used as a dsn for `cql console`
 or any command, or be used in website like https://web.covenantsql.io
```

其中 `covenantsql://163193957a22fccf165ad754ee514f13972c0eadee6455203b17b7bba76028df` 是数据库的连接串，可以在各类 SDK 或命令行工具中使用这个连接串访问数据库服务

#### 使用命令行工具连接数据库服务

可以是用 `cql` 工具提供的命令行功能访问数据库

> 将命令行中的 `dsn` 替换为上一步生成的数据库连接串

```shell
docker run -it --rm -v $(pwd)/client_config/:/app/config/ \
  --entrypoint /app/cql covenantsql/covenantsql:latest -- \
  console -config /app/config/config.yaml "<dsn>"
```

#### 启动 Adapter

Java SDK 因为CovenantSQL 的 RPC 和网络连接协议的限制，不能直接访问 Miner 或 BlockProducer 节点，需要通过 Adapter 进行协议转换来访问。实际运行时，Java SDK/Adapter/Miner 是以如下图所示的形式交互的：

```sequence
Java SDK ->Adapter: HTTP(s) Request
Adapter->Miner: ETLS RPC Request
Miner->Adapter: ETLS RPC Response
Adapter->Java SDK: HTTP(s) with JSON Response
```

可以通过如下命令启动 Adapter：

> 请将命令中的 `adapter_name` 替换为所需的 adapter 的 docker container 名，将 `adapter_listen_port` 替换为所需暴露在物理机器上的端口号

```shell
docker run -d -v $(pwd)/client_config/:/app/config/ \
  -e COVENANT_ROLE=adapter \
  -e COVENANT_CONF=/app/config/config.yaml \
  -e COVENANTSQL_ADAPTER_ADDR=0.0.0.0:4661 \
  --name "<adapter_name>" \
  --restart always \
  --log-driver "json-file" \
  --log-opt "max-size=1g" \
  --log-opt "max-file=3" \
  -p "<adapter_listen_port>:4661" \
  covenantsql/covenantsql:latest
```

启动后如果 adapter 的 docker container 运行正常，将可以通过 `http://localhost:<adapter_listen_port>/` 访问 adapter 并获取到 adapter 的版本信息

#### 使用 Java SDK

参考 [CovenantSQL Java SDK Github](https://github.com/CovenantSQL/covenant-connector/tree/master/covenantsql-java-connector) 和 [CovenantSQL Java SDK 使用文档](https://developers.covenantsql.io/docs/en/driver_java) 通过 Adapter 访问

> 上一步启动的 Adapter 是运行在非 TLS 模式下的开发权限服务，任何访问 Adapter 的人都将以 Adapter 启动的账户（也就是 `./client_config` 中的私钥与配置）的权限访问数据库服务。
>
> 在 Java SDK 中设置配置 `ssl=false`（因为 Adapter 运行在了非 TLS 模式下提供的 http 服务），并以 `jdbc:covenantsql://<adapter_host>:<adapter_listen_port>/<database_id>` 即可访问（请将 `adapter_host` 替换为实际的运行机器的域名或 IP，将 `adapter_listen_port` 替换为上一步中的监听端口号，`database_id` 替换为创建 DB 后返回的 `dsn` 中去除 `covenantsql://` scheme 的 hex 串部分，例如：`jdbc:covenantsql://127.0.0.1:11151/163193957a22fccf165ad754ee514f13972c0eadee6455203b17b7bba76028df`）

#### 获取 Miner 节点的 metric 信息

Miner 提供了 metric 数据的导出接口，可以通过下述命令访问和导出：

> 讲命令中的 `miner_name` 替换为 启动 miner 的 container 名

```shell
miner_internal_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "<miner_name>" | head -1)
curl -s "http://${miner_internal_ip}:4665/debug/vars"
```

metric 信息对应表

| 字段名                   | 含义                                                         |
| ------------------------ | ------------------------------------------------------------ |
| service:miner:addr       | 可访问的 Miner 的外部地址和端口（配置中的 ListenAddr）       |
| service:miner:node       | Miner 的 DHT 网络节点 ID                                     |
| service:miner:wallet     | Miner 的 钱包地址                                            |
| service:miner:disk:root  | Miner 的 数据目录地址                                        |
| service:miner:disk:usage | Miner 使用的磁盘空间（KB）                                   |
| service:miner:db:count   | Miner 上正在提供服务的 ShardChain 数量                       |
| service:miner:chain      | Miner 上所有 ShardChain 统计信息，类型是一个 Map Map 的 key 是 ShardChain 的 DatabaseID |

针对每个 ShardChain 的统计信息，有如下字段

| 字段           | 含义                                        |
| -------------- | ------------------------------------------- |
| head:count     | Chain 最新 Block 的编号（第几个块）         |
| head:height    | Chain 最新 Block 的 Epoch（第几个出块周期） |
| head:hash      | Chain 最新 Block 的 Hash                    |
| head:timestamp | Chain 最新 Block 的产生时间（UTC）          |
| requests:count | 最近 5 分钟统计范围内，1m 的请求数的平均值  |

#### 查看 Miner 节点上某个 DB Chain 的块信息

CovenantSQL 提供了一个方便的 Explorer 来展示数据库子链上的块信息，可以在通过如下命令启动 Explorer：

> 其中替换 `explorer_name` 为想要运行 explorer 的 docker container 名，`explorer_listen_port` 替换为所需暴露在物理机器上的端口号

```shell
docker run -d -v $(pwd)/client_config/:/app/config/ \
  -e COVENANT_ROLE=observer \
  -e COVENANT_CONF=/app/config/config.yaml \
  -e COVENANTSQL_OBSERVER_ADDR=0.0.0.0:4661 \
  --name "<explorer_name>" \
  --restart always \
  --log-driver "json-file" \
  --log-opt "max-size=1g" \
  --log-opt "max-file=3" \
  -p "<explorer_listen_port>:4661" \
  covenantsql/covenantsql:latest
```

启动在浏览器里访问 `http://<explorer_external_address>:<explorer_listen_port>/dbs/<database_id>`

> 其中 `explorer_external_address` 替换为物理机的外网 IP，`explorer_listen_port` 替换为上一步中指定的端口， `database_id` 替换为创建 DB 后返回的 `dsn` 中去除 `covenantsql://` scheme 的 hex 串部分，例如：`http://miner_machine:11106/dbs/163193957a22fccf165ad754ee514f13972c0eadee6455203b17b7bba76028df`

稍后等待块同步，即可在页面中看到历史产生的 Block，点击 Block 可以看到 Block 上承载的历史查询过的 Query 情况（如果没有自动出现块的信息，可以尝试手动刷新）

> CovenantSQL 有严格的权限控制，需要对数据库有读权限的人才能使用 Explorer 看到这些 Query 历史和 Block 信息
