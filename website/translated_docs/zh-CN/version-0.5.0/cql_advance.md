---
id: version-0.5.0-cql_advance
title: Advanced Usage
original_id: cql_advance
---
Sub-command `rpc` calls the remote process directly in the CovenantSQL network.

## Sub-command `rpc` Complete Parameter

    usage: cql rpc [parameter]...
    
    Rpc command make a RPC request to the target server
    e.g.
        cql rpc -name 'MCC.QuerySQLChainProfile' \
                -endpoint 000000fd2c8f68d54d55d97d0ad06c6c0d91104e4e51a7247f3629cc2a0127cf \
                -req '{"DBID": "c8328272ba9377acdf1ee8e73b17f2b0f7430c798141080d0282195507eb94e7"}'
    
    Params:
      -endpoint string
            RPC endpoint to do a test call
      -name string
            RPC name to do a test call
      -req string
            RPC request to do a test call, in json format
      -wait-tx-confirm
            Wait for transaction confirmation