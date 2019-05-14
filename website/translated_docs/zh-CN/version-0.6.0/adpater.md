---
id: adapter
title: 📦 Adapter SDK
---

# 通过 Adapter 使用 CovenantSQL

`CovenantSQL` 提供了 HTTP/HTTPS Adapter，类似于云数据库， 开发者可以直接用 HTTP 的形式使用 CovenantSQL。

## 安装和使用

首先，[安装 Docker](https://docs.docker.com/install/)。

然后，需要确认我们有一个可用的配置和公私钥对，通常我们默认的配置和公私钥对的存储位置为 `~/.cql/` 目录。生成或获取请参考 [QuickStart#创建账号](./quickstart#创建账号)

### Docker 运行 Adapter

下面的命令将使用`~/.cql/config.yaml` 和 `~/.cql/private.key` 启动 Adapter，并把端口映射在 `0.0.0.0:11105`

```bash
export adapter_addr=0.0.0.0:11105
docker rm -f cql-adapter
docker run -itd \
	--env COVENANT_ROLE=adapter --env COVENANT_CONF=/app/config.yaml \
	-v ~/.cql/config.yaml:/app/config.yaml \
	-v ~/.cql/private.key:/app/private.key \
	--name cql-adapter -p $adapter_addr:4661 \
	covenantsql/covenantsql:testnet 0.0.0.0:4661
```

### 创建数据库

使用 `cql` 命令并使用 `create` 参数提供所需的数据库节点数量创建数据库实例，例如：创建一个单节点的数据库实例

```bash
docker run -it --rm \
	-v ~/.cql/config.yaml:/app/config.yaml \
	-v ~/.cql/private.key:/app/private.key \
	--entrypoint /app/cql covenantsql/covenantsql:testnet \
	create -config /app/config.yaml -wait-tx-confirm '{"node": 1}'
```

命令会返回创建的数据库实例的连接串（DSN）

```bash
covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
```

## 主流语言 Driver 的使用

1. [Golang](./driver_golang) 
2. [Java](./driver_java)
3. [Python](./driver_python)
4. [NodeJS](./driver_js)