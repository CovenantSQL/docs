---
id: version-0.5.0-cql_server
title: Local Servers
original_id: cql_server
---
## Sub-command `explorer` Complete Parameter

    usage: cql explorer [parameter]... address
    
    Explorer command serves a SQLChain web explorer.
    e.g.
        cql explorer 127.0.0.1:8546
    
    Params:
      -bg-log-level string
            Background service log level
      -tmp-path string
            Background service temp file path, use os.TempDir for default
    

## Sub-command `mirror` Complete Parameter

    usage: cql mirror [parameter]... dsn/dbid address
    
    Mirror command subscribes database updates and serves a read-only database mirror.
    e.g.
        cql mirror database_id 127.0.0.1:9389
    
    Params:
      -bg-log-level string
            Background service log level
      -tmp-path string
            Background service temp file path, use os.TempDir for default
    

## Sub-command `adapter` Complete Parameter

See <adapter> for details of adapter server.

    usage: cql adapter [parameter]... address
    
    Adapter command serves a SQLChain adapter
    e.g.
        cql adapter 127.0.0.1:7784
    
    Params:
      -bg-log-level string
            Background service log level
      -mirror string
            mirror server for the target adapter to query
      -tmp-path string
            Background service temp file path, use os.TempDir for default