---
id: cql_server
title: 本地服务
---

## 子命令 `explorer` 完整参数

    usage: cql explorer [参数]... address

    为数据库子链运行 adapter 服务器。
    示例：
        cql explorer 127.0.0.1:8546

    Params:
      -bg-log-level string
            后台服务日志级别
      -tmp-path string
            后台服务使用的临时目录，默认使用系统的默认临时文件路径

## 子命令 `mirror` 完整参数

    usage: cql mirror [参数]... dsn/dbid address

    为数据库子链运行 mirror 服务器。
    示例：
        cql mirror database_id 127.0.0.1:9389

    Params:
      -bg-log-level string
            后台服务日志级别
      -tmp-path string
            后台服务使用的临时目录，默认使用系统的默认临时文件路径

## 子命令 `adapter` 完整参数

关于 `adapter` 服务的说明请参考 [adapter](adapter)。

    usage: cql adapter [参数]... address

    为数据库子链运行 adapter 服务器。
    示例：
        cql adapter 127.0.0.1:7784

    Params:
      -bg-log-level string
            后台服务日志级别
      -mirror string
            指定镜像 adapter 服务器地址
      -tmp-path string
            后台服务使用的临时目录，默认使用系统的默认临时文件路径

