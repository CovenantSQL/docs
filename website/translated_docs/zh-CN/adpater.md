---
id: adapter
title: '📦 Adapter SDK'
---
# Use Adapter to access CovenantSQL

`CovenantSQL` provides an HTTP/HTTPS adapter service. Developers could access CovenantSQL like a cloud database by using HTTP Rest requests.

## How to use

First, [Install docker](https://docs.docker.com/install/).

Secondly, before using CovenantSQL, a proper configuration file and an asymmetric key-pair is required. If no configuration file is specified, CovenantSQL tries to load configuration from `~/.cql/config.yaml`. For configuration file and key-pair generation, please refer to [QuickStart#CreateAccount](./quickstart#CreateAccount)

### Start adapter using docker

Following command will use config file `~/.cql/config.yaml` and key-pair `~/.cql/private.key` to start adapter service and serving at `0.0.0.0:11105`.

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

### Create database

Create new database using `cql create` command and provide database instance requirements.

For example, create a single node database instance:

```shell
docker run -it --rm \
    -v ~/.cql/config.yaml:/app/config.yaml \
    -v ~/.cql/private.key:/app/private.key \
    --entrypoint /app/cql covenantsql/covenantsql:testnet \
    create -config /app/config.yaml -wait-tx-confirm '{"node": 1}'
```

This command would produce a database connection string (DSN) similar to following example.

```shell
covenantsql://0a255f136520a2bc6a29055a619ec4f72c2c80fa600daf73b1caa375946ea0e4
```

Use DSN to access CovenantSQL using various drivers.

## Drivers

1. [Golang](./driver_golang)
2. [Java](./driver_java)
3. [Python](./driver_python)
4. [NodeJS](./driver_js)