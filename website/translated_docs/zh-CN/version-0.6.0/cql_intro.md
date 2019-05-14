---
id: cql_intro
title: 简介
---

CovenantSQL 为终端用户提供 `cql` 命令行工具集，用于对用户账号、钱包以及名下的数据库进行便捷的管理和访问操作。完整的工具包安装教程请参考 [CovenantSQL 工具包安装](quickstart#工具包安装)。

### 账号私钥和配置文件

运行 `cql` 依赖私钥文件 `private.key` 和配置文件 `config.yaml`，其中：

- `private.key`：生成用户账户时所分配的私钥，请务必妥善保管好这个私钥
- `config.yaml`：主要用于配置 `cql` 命令要连接的 CovenantSQL 网络（如 [TestNet](quickstart) 或用户使用 [Docker 一键部署](deployment)的网络）

出于安全方面的考虑，私钥文件通常需要使用主密码进行加密。主密码在创建账号时由用户输入，之后由用户自行记忆或保管，而不会保存到配置文件中。当需要使用到私钥的时候，`cql` 命令会要求用户输入主密码以解开私钥文件。

### 子命令通用参数

以下列出子命令中使用到的通用参数：

    -bypass-signature
          禁用签名和验签，仅用于开发者测试
    -config string
          指定配置文件路径，默认值为 "~/.cql/config.yaml"
    -no-password
          使用空白主密码加密私钥
    -password string
          私钥主密码（不安全，仅用于调试或安全环境下的脚本模式）

注意，因为私钥文件的路径是在配置文件中设定的，默认值为相对路径 `./private.key`，即配置文件的同一目录下，所以我们通常把私钥和配置文件放置到同一目录下，而不设置单独的参数来指定私钥文件。
