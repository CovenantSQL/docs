---
id: arch_network
title: 网络传输层
---

## DH-RPC 是什么

像 TLS 或 SSL 这样的传统密钥交换需要 CA（Certification Authority）来确保密钥交换安全运行。但在 DH-RPC 中，我使用 DHT 来做到这一点。主要思想是使用DHT进行命名和密钥交换，从整个系统中删除 CA Cert。

DH-RPC 是一个 `secp256k1-ECDH-AES` 加密的 P2P RPC 框架，用于用 golang 编写的 P2P 应用。

CovenantSQL 建立在 DH-RPC 之上，包括：

- 拜占庭容错共识协议 [Kayak](https://godoc.org/github.com/CovenantSQL/CovenantSQL/kayak)
- Consistent Secure DHT
- 数据库 API
- 机器指标信息监控 API
- 区块同步

## 特性

- 和 Golang 标准库的 [net/rpc](https://golang.org/pkg/net/rpc/) 100% 兼容
- 基于 ID 的路由和基于 Secure Enhanced DHT 构建的密钥交换。
- 使用 MessagePack 进行序列化，支持大多数类型，而无需编写 `Marshal` 和 `Unmarshal`。
- 加密选型：
    - 使用椭圆曲线 Secp256k1 进行非对称加密
    - 使用 ECDH 进行密钥交换
    - 使用 PKCS#7 作为 padding
    - 使用 AES-256-CFB 进行对称加密
    - Private key protected by master key
    - 支持匿名 Node 连接（仅对称加密）
- DHT持久层有2个实现:
    - SQLite3 based simple traditional DHT
    - [Kayak](https://godoc.org/github.com/CovenantSQL/CovenantSQL/kayak) based 2PC strong consistent DHT
- 基于 [smux](https://github.com/xtaci/smux) 的会话多路复用

## 网络栈

[DH-RPC](rpc/) := TLS - Cert + DHT

| 分层              | 实现 |
|:-------------------|:--------------:|
| RPC                |     `net/rpc`    |
| Naming             |      [**C**onsistent **S**ecure **DHT**](https://godoc.org/github.com/CovenantSQL/CovenantSQL/consistent)     |
| Pooling            |  Session Pool  |
| Multiplex          |      [smux](https://github.com/xtaci/smux)     |
| Transport Security |      [**E**nhanced **TLS**](https://github.com/CovenantSQL/research/wiki/ETLS(Enhanced-Transport-Layer-Security))      |
| Network            |       TCP or KCP for optional later      |


## 工作原理

我们知道，传统的 TLS/SSL 需要一个层级化的CA系统，类似于一个传销系统的金字塔，根证书（Root CA）给下一层CA签名做签名，最后一层 CA 给网站做签名。

这样就导致了，如果你能控制一个 CA，那么很多中间人攻击的勾当就可以悄无声息的进行了。参见：

- [Google决定在Chrome删除赛门铁克的根证书](https://security.googleblog.com/2017/09/chromes-plan-to-distrust-symantec.html)
- [Google Dropping CNNIC Root CA After Trust Breach](https://thenextweb.com/insider/2015/04/02/google-to-drop-chinas-cnnic-root-certificate-authority-after-trust-breach/)

> 人构成的组织，反而成为了最大的漏洞。


继续聊下去之前，我们必须提一下DH算法（[Diffie–Hellman key exchange](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange)）。我们不关心他的原理，简单来说，这个算法实现了这么一个功能：

```go
DH(A.Public, B.Private) == DH(B.Public, A.Private)
```

通过这个几乎可以和 RSA 比肩的伟大发明，Alice 可以仅获取 Bob 的 Public Key 并结合自己的 Private Key 来计算出一个和 Bob 用同样方式计算的相同密钥。

那么剩下的问题就在于如何防止在获取Bob的Public Key的时候被调包，也就是黑客们常说的 MITM 攻击（Man-in-the-middle attack）。

CA 在 HTTPS 中的作用主要是作为一个中介，防止 MITM。大致方式就是浏览器或操作系统把常见的CA的公钥放在预先存起来。访问使用 HTTPS 的网站的时候通过相应的根证书进行验证。

## 去中心化

在构建CovenantSQL的时候我们对这个问题进行了思考，于是抛弃了 CA 创造了 DH-RPC。

> DH-RPC = DHT + ECDH + RPC

在 DH-RPC 里我们都用 NodeID 来作为 URI（Uniform Resource Identifier），NodeID 是通过 Node 的 Public Key 上一个 256位 的随机数（`NodeNonce`）做两层不同的哈希生成的。

```go
NodeID := sha256(blake2b-512(NodePublicKey + Uint256Nonce))
```

生成的NodeID大致长这个样子：

```text
0000000004e249292693ee2eb89e1cfc4b05a211f0b0ff0ecbb9d5bc155c078f
```

把`NodeID:Addr` 和 `NodeID:PublicKey`存储在 DHT 上，为了防止针对 DHT 的各种女巫攻击 和 日食攻击，我们参考 Bitcoin 的思想，把 NodeID 前面连续的`0`的个数定义为难度，并且可以对允许存储在 DHT 上的 NodeID 难度进行一定的最低限制。

我们采用了 Bitcoin 使用的 `Elliptic Curve Secp256k1` 作为非对称加密算法。`AES-256-CBC` 作为对称加密算法。

首先，Alice 通过可信途径获取到 Bob 的 NodeID，并在 DHT 上查询出 Bob 的网络地址和公钥。此时 Alice 已经得到了 DH算法 所需的 Alice 的私钥、Bob 的公钥。

Alice 向 Bob 发起连接，在 RPC 的 TCP 连接建立完成之后，连接发起方（Alice）首先会把一个自己的 `NodeID`、`NodeNonce` 发送给对端（Bob）。Bob 收到 Alice 的`NodeID`之后通过查询 DHT 获取到 Alice 之前存储在 DHT 上的 `Alice.PublicKey` 并缓存在本地。Bob 通过 Alice 发过来的 `NodeNonce` 和 DHT 上获取的 `Alice.PublicKey` 可以验证 Alice 的公钥是否是约定的算法生成的。此时 Bob 也获取到了 DH算法 所需的 Bob 的私钥、Alice 的公钥。此时的 Alice 和 Bob 的通信就是经过高强度加密并且 P2P 的了。

流程图如下：

<img src="https://github.com/CovenantSQL/CovenantSQL/raw/develop/logo/rpc.png" width=900>

## 示例代码及使用

![](https://cdn.jsdelivr.net/gh/CovenantSQL/CovenantSQL@cc4aa933d80a5d31738081d13c7b1587ad47cffb/logo/dh-rpc.svg)


Alice Client:
```go
// Init Key Management System
route.InitKMS(PubKeyStoreFile)

// Register Node public key, addr to Tracker
reqA := &proto.PingReq{
    Node: AliceNode,
}
respA := new(proto.PingResp)
rpc.NewCaller().CallNode(Tracker.NodeID, "DHT.Ping", reqA, respA)

pc := rpc.NewPersistentCaller(BobNodeID)
respSimple := new(string)
pc.Call("Test.Talk", "Hi there", respSimple)
fmt.Printf("Response msg: %s", *respSimple)
```

Bob Server:
```go
// RPC logic
// TestService to be register to RPC server
type TestService struct {}

func (s *TestService) Talk(msg string, ret *string) error {
	fmt.Println(msg)
	resp := fmt.Sprintf("got msg %s", msg)
	*ret = resp
	return nil
}

// Init Key Management System
route.InitKMS(PubKeyStoreFile)

// Register DHT service
server, err := rpc.NewServerWithService(rpc.ServiceMap{
    "Test": &TestService{},
})

// Init RPC server with an empty master key, which is not recommend
server.InitRPCServer("0.0.0.0:2120", PrivateKeyFile, "")

// Start Node RPC server
server.Serve()
```

Tracker 相关代码参见下面的内容。


## Example

下面的代码展示了 1 DHT Tracker 和 2 节点的示例

完整代码参见这里 [here](https://github.com/CovenantSQL/CovenantSQL/tree/develop/rpc/_example)


#### Tracker 代码

```go
package main

import (
	"os"

	"github.com/CovenantSQL/CovenantSQL/conf"
	"github.com/CovenantSQL/CovenantSQL/consistent"
	"github.com/CovenantSQL/CovenantSQL/route"
	"github.com/CovenantSQL/CovenantSQL/rpc"
	"github.com/CovenantSQL/CovenantSQL/utils/log"
)

func main() {
	//log.SetLevel(log.DebugLevel)
	conf.GConf, _ = conf.LoadConfig(os.Args[1])
	log.Debugf("GConf: %#v", conf.GConf)

	// Init Key Management System
	route.InitKMS(conf.GConf.PubKeyStoreFile)

	// Creating DHT RPC with simple persistence layer
	dht, err := route.NewDHTService(conf.GConf.DHTFileName, new(consistent.KMSStorage), true)
	if err != nil {
		log.Fatalf("init dht failed: %v", err)
	}

	// Register DHT service
	server, err := rpc.NewServerWithService(rpc.ServiceMap{route.DHTRPCName: dht})
	if err != nil {
		log.Fatal(err)
	}

	// Init RPC server with an empty master key, which is not recommend
	addr := conf.GConf.ListenAddr
	masterKey := []byte("")
	server.InitRPCServer(addr, conf.GConf.PrivateKeyFile, masterKey)
	server.Serve()
}
```

#### Node 代码
```go
package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"github.com/CovenantSQL/CovenantSQL/conf"
	"github.com/CovenantSQL/CovenantSQL/proto"
	"github.com/CovenantSQL/CovenantSQL/route"
	"github.com/CovenantSQL/CovenantSQL/rpc"
	"github.com/CovenantSQL/CovenantSQL/utils/log"
)

// TestService to be register to RPC server
type TestService struct {
}

func NewTestService() *TestService {
	return &TestService{}
}

func (s *TestService) Talk(msg string, ret *string) error {
	fmt.Println(msg)
	resp := fmt.Sprintf("got %s", msg)
	*ret = resp
	return nil
}

func main() {
	//log.SetLevel(log.DebugLevel)
	conf.GConf, _ = conf.LoadConfig(os.Args[1])
	log.Debugf("GConf: %#v", conf.GConf)

	// Init Key Management System
	route.InitKMS(conf.GConf.PubKeyStoreFile)

	// Register DHT service
	server, err := rpc.NewServerWithService(rpc.ServiceMap{
		"Test": NewTestService(),
	})
	if err != nil {
		log.Fatal(err)
	}

	// Init RPC server with an empty master key, which is not recommend
	addr := conf.GConf.ListenAddr
	masterKey := []byte("")
	server.InitRPCServer(addr, conf.GConf.PrivateKeyFile, masterKey)

	// Start Node RPC server
	go server.Serve()

	// Register Node public key, addr to Tracker(BP)
	for _, n := range conf.GConf.KnownNodes {
		client := rpc.NewCaller()
		reqA := &proto.PingReq{
			Node: n,
		}
		respA := new(proto.PingResp)
		err = client.CallNode(conf.GConf.BP.NodeID, "DHT.Ping", reqA, respA)
		if err != nil {
			log.Fatal(err)
		}
		log.Debugf("respA: %v", respA)
	}

	// Read target node and connect to it
	scanner := bufio.NewScanner(os.Stdin)
	fmt.Print("Input target node ID: ")
	scanner.Scan()
	if scanner.Err() == nil {
		target := proto.NodeID(strings.TrimSpace(scanner.Text()))
		pc := rpc.NewPersistentCaller(target)
		log.Debugf("connecting to %s", scanner.Text())

		fmt.Print("Input msg: ")
		for scanner.Scan() {
			input := scanner.Text()
			log.Debugf("get input %s", input)
			repSimple := new(string)
			err = pc.Call("Test.Talk", input, repSimple)
			if err != nil {
				log.Fatal(err)
			}
			log.Infof("resp msg: %s", *repSimple)
		}
	}
}
```

启动 tracker 和 node1, node2
```bash
$ ./runTracker.sh &
$ ./runNode2.sh &
$ ./runNode1.sh
$ Input target node ID: 000005aa62048f85da4ae9698ed59c14ec0d48a88a07c15a32265634e7e64ade #node2
$ Input msg: abcdefg
```