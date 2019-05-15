---
id: cql_advance
title: 高级使用
---

子命令 `rpc` 直接在 CovenantSQL 网络上进行 RPC 调用。

## 子命令 `rpc` 完整参数

    usage: cql rpc [通用参数] [-wait-tx-confirm] [-endpoint rpc_endpoint | -bp] -name rpc_name -req rpc_request

    向目标服务器发送 RPC 请求。
    示例：
        cql rpc -name 'MCC.QuerySQLChainProfile' \
                -endpoint 000000fd2c8f68d54d55d97d0ad06c6c0d91104e4e51a7247f3629cc2a0127cf \
                -req '{"DBID": "c8328272ba9377acdf1ee8e73b17f2b0f7430c798141080d0282195507eb94e7"}'

    Params:
      -bp
        	Call block producer node
      -endpoint string
            目标 RPC Node ID
      -name string
            目标 RPC 服务.方法名
      -req string
            RPC 请求数据，JSON 格式
      -wait-tx-confirm
            等待交易执行确认（或者出现任何错误）后再退出
