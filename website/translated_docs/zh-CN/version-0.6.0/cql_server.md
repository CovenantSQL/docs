---
id: version-0.6.0-cql_server
title: Local Servers
original_id: cql_server
---

## Sub-command `explorer` Complete Parameter

    usage: cql explorer [common params] [-tmp-path path] [-bg-log-level level] listen_address
    
    Explorer serves a SQLChain web explorer.
    e.g.
        cql explorer 127.0.0.1:8546
    
    Explorer params:
      -bg-log-level string
            Background service log level: trace debug info warning error fatal panic (default "info")
      -tmp-path string
            Background service temp file path, use "dirname $(mktemp -u)" to check it out
    

## Sub-command `mirror` Complete Parameter

    usage: cql mirror [common params] [-tmp-path path] [-bg-log-level level] dsn listen_address
    
    Mirror subscribes database updates and serves a read-only database mirror.
    e.g.
        cql mirror dsn 127.0.0.1:9389
    
    Mirror params:
      -bg-log-level string
            Background service log level: trace debug info warning error fatal panic (default "info")
      -tmp-path string
            Background service temp file path, use "dirname $(mktemp -u)" to check it out
    

## Sub-command `adapter` Complete Parameter

See <adapter> for details of adapter server.

    usage: cql adapter [common params] [-tmp-path path] [-bg-log-level level] [-mirror addr] listen_address
    
    Adapter serves a SQLChain adapter.
    e.g.
        cql adapter 127.0.0.1:7784
    
    Adapter params:
      -bg-log-level string
            Background service log level: trace debug info warning error fatal panic (default "info")
      -mirror string
            Mirror server for adapter to query
      -tmp-path string
            Background service temp file path, use "dirname $(mktemp -u)" to check it out