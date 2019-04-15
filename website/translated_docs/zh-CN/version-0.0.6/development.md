---
id: version-0.0.6-development
title: 使用 CovenantSQL 开发 App
original_id: development
---
## Golang 使用 CovenantSQL

### 简介

`CovenantSQL` 提供了 `Golang SDK` ，支持以 `Golang` App 以原生通讯协议的形式访问数据库实例，是当前性能最高的使用方法， `cql` 等工具也是基于 `Golang SDK` 进行开发的。

`Golang SDK` 遵守 `Golang` 标准的 `database/sql` 接口定义，能够使用常见的 `Golang ORM` 进行使用。

### 兼容性

`Golang SDK` 目前只兼容 `1.10+` 的 Golang 版本。

### 安装和使用

`Golang SDK` 的 import 地址是 `github.com/CovenantSQL/CovenantSQL/client`

可以执行 `go get` 命令进行安装

```shell
go get github.com/CovenantSQL/CovenantSQL/client
```

### API 文档

https://godoc.org/github.com/CovenantSQL/CovenantSQL/client

### 示例

```go
package main

import (
    "database/sql"
    "flag"

    "github.com/CovenantSQL/CovenantSQL/client"
    "github.com/CovenantSQL/CovenantSQL/utils/log"
)

func main() {
    log.SetLevel(log.DebugLevel)
    var config, password, dsn string

    flag.StringVar(&config, "config", "./conf/config.yaml", "config file path")
    flag.StringVar(&dsn, "dsn", "", "database url")
    flag.StringVar(&password, "password", "", "master key password for covenantsql")
    flag.Parse()

    // 使用节点配置文件初始化 Golang SDK
    err := client.Init(config, []byte(password))
    if err != nil {
        log.Fatal(err)
    }

    // 连接数据库实例
    db, err := sql.Open("covenantsql", dsn)
    if err != nil {
        log.Fatal(err)
    }

    Q := `DROP TABLE IF EXISTS cityPop;
        CREATE TABLE cityPop (
            ID INT,
            Name VARCHAR,
            CountryCode VARCHAR,
            District VARCHAR,
            Population INT
        );
        CREATE INDEX cityCountryCodeIndex ON cityPop ( CountryCode );

        DROP TABLE IF EXISTS countryGDP;
        CREATE TABLE countryGDP (
             ID integer PRIMARY KEY,
             CountryCode string NOT NULL,
             GDP integer
        );
        CREATE INDEX countryCountryCodeIndex ON countryGDP ( CountryCode );`

    // 写入数据
    _, err = db.Exec(Q)
    if err != nil {
        log.Fatal(err)
    }
    log.Printf("\nExec:\n %s\n", Q)

    Q = `INSERT INTO countryGDP VALUES
            (0, "ZWE", 99999),(1, "CHN", 3000000000000),
            (2, "PSE", 321312313),(3, "JPN", 300000000);
        INSERT INTO cityPop VALUES (707,'Shenzhen','CHN','Guangzhou',99442);
        INSERT INTO cityPop VALUES (1074,'Shenzhen','CHN','Guangzhou',353632);
        INSERT INTO cityPop VALUES (1591,'Toyama','JPN','Toyama',325790);
        INSERT INTO cityPop VALUES (1649,'Takaoka','JPN','Toyama',174380);
        INSERT INTO cityPop VALUES (1762,'Takasago','JPN','Hyogo',97632);
        INSERT INTO cityPop VALUES (1763,'Fujimi','JPN','Saitama',96972);
        INSERT INTO cityPop VALUES (1764,'Urasoe','JPN','Okinawa',96002);
        INSERT INTO cityPop VALUES (1765,'Yonezawa','JPN','Yamagata',95592);
        INSERT INTO cityPop VALUES (1766,'Konan','JPN','Aichi',95521);
        INSERT INTO cityPop VALUES (1767,'Yamatokoriyama','JPN','Nara',95165);
        INSERT INTO cityPop VALUES (1768,'Maizuru','JPN','Kyoto',94784);
        INSERT INTO cityPop VALUES (1769,'Onomichi','JPN','Hiroshima',93756);
        INSERT INTO cityPop VALUES (1770,'Higashimatsuyama','JPN','Saitama',93342);
        INSERT INTO cityPop VALUES (2707,'Xai-Xai','MOZ','Gaza',99442);
        INSERT INTO cityPop VALUES (4074,'Gaza','PSE','Gaza',353632);
        INSERT INTO cityPop VALUES (4077,'Jabaliya','PSE','North Gaza',113901);`
    _, err = db.Exec(Q)
    if err != nil {
        log.Warn(err)
    }
    log.Printf("\nExec:\n %s\n", Q)

    Q = `SELECT * FROM cityPop
        WHERE District IN ("Shenzhen", "Balkh", "Gaza", "North Gaza")
        GROUP  BY cityPop.CountryCode
        ORDER  BY Population DESC
        LIMIT  10;`

    // 查询数据
    rows, err := db.Query(Q)
    if err != nil {
        log.Fatal(err)
    }
    log.Printf("\nExec:\n %s\n", Q)
    log.Println("ID Name    CountryCode District    Population")
    var ID, GDP, Population int
    var Name, CountryCode, District string
    var GDPPerson float64

    for rows.Next() {
        err = rows.Scan(&ID, &Name, &CountryCode, &District, &Population)
        if err != nil {
            log.Fatal(err)
        }

        log.Printf("%d  %s  %s  %s  %d", ID, Name, CountryCode, District, Population)
    }
    Q = `UPDATE countryGDP SET GDP = 1234567 WHERE CountryCode LIKE "CHN";
            UPDATE cityPop SET Population = 123456 WHERE CountryCode LIKE "CHN";
            REPLACE INTO countryGDP (ID, CountryCode, GDP) VALUES (77, "AFG", 11111111);`
    _, err = db.Exec(Q)
    if err != nil {
        log.Fatal(err)
    }
    log.Printf("\nExec:\n %s\n", Q)

    Q = `SELECT cityPop.ID,  cityPop.CountryCode, cityPop.District,
        countryGDP.GDP / cityPop.Population, countryGDP.GDP, cityPop.Population
        FROM   cityPop
            LEFT JOIN countryGDP
                  ON countryGDP.CountryCode = cityPop.CountryCode
        WHERE District IN ( "Shenzhen", "Balkh", "North Gaza", "Toyama", "Yonezawa") AND countryGDP.GDP > 0
        GROUP BY cityPop.CountryCode
        ORDER BY countryGDP.GDP / cityPop.Population DESC
        LIMIT 10;`
    rows, err = db.Query(Q)
    log.Printf("\nExec:\n %s\n", Q)

    log.Println("ID CountryCode District    GDPPerson   GDP Population")
    for rows.Next() {
        err = rows.Scan(&ID, &CountryCode, &District, &GDPPerson, &GDP, &Population)
        if err != nil {
            log.Fatal(err)
        }

        log.Printf("%d  %s  %s  %f  %d  %d",
            ID, CountryCode, District, GDPPerson, GDP, Population)
    }
}
```