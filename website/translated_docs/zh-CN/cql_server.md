---
id: cql_server
title: Local Servers
---
## Sub-command `explorer` Complete Parameter

    usage: cql explorer [common params] [-tmp-path path] [-bg-log-level level] listen_address
    
    Explorer serves a SQLChain web explorer.
    e.g.
        cql explorer 127.0.0.1:8546
    
    Params:
      -bg-log-level string
            Background service log level
      -tmp-path string
            Background service temp file path, use os.TempDir for default
    

## Sub-command `mirror` Complete Parameter

    usage: cql mirror [common params] [-tmp-path path] [-bg-log-level level] dsn listen_address
    
    Mirror subscribes database updates and serves a read-only database mirror.
    e.g.
        cql mirror database_id 127.0.0.1:9389
    
    Params:
      -bg-log-level string
            Background service log level
      -tmp-path string
            Background service temp file path, use os.TempDir for default
    

## Sub-command `adapter` Complete Parameter

See <adapter> for details of adapter server.

    usage: cql adapter [common params] [-tmp-path path] [-bg-log-level level] [-mirror addr] listen_address
    
    Adapter serves a SQLChain adapter.
    e.g.
        cql adapter 127.0.0.1:7784
    
    Params:
      -bg-log-level string
            Background service log level
      -mirror string
            mirror server for the target adapter to query
      -tmp-path string
            Background service temp file path, use os.TempDir for default