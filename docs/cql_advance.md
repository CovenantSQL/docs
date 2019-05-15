---
id: cql_advance
title: Advanced Usage
---

Sub-command `rpc` calls the remote process directly in the CovenantSQL network.

## Sub-command `rpc` Complete Parameter

    usage: cql rpc [common params] [-wait-tx-confirm] [-endpoint rpc_endpoint | -bp] -name rpc_name -req rpc_request

    RPC makes a RPC request to the target endpoint.
    e.g.
        cql rpc -name 'MCC.QuerySQLChainProfile' \
                -endpoint 000000fd2c8f68d54d55d97d0ad06c6c0d91104e4e51a7247f3629cc2a0127cf \
                -req '{"DBID": "c8328272ba9377acdf1ee8e73b17f2b0f7430c798141080d0282195507eb94e7"}'

    RPC params:
      -bp
        	Call block producer node
      -endpoint string
        	RPC endpoint Node ID to do test call
      -name string
        	RPC name to do test call
      -req string
        	RPC request to do test call, in json format
      -wait-tx-confirm
        	Wait for transaction confirmation
