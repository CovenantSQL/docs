---
id: usecase_traditional_app
title: Traditional App
---

## Privacy data

If you are a developper of password management tools just like [1Password](https://1password.com/) or [LastPass](https://www.lastpass.com/). You can use CQL as the database to take benefits:

1. Serverless: no need to deploy a server to store your user's password for sync which is the hot potato.
2. Security: CQL handles all the encryption work. Decentralized data storage gives more confidence to your users.
3. Regulation: CQL naturally comply with [GDPR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation).

## IoT storage

CQL miners are deployed globally, IoT node can write to nearest CQL miner directly.

1. Cheaper: Without passing all the traffic through a gateway, you can save a large bandwidth fee. And, CQL is a shared economic database which makes storage cheaper.
2. Faster: CQL consensus protocol is designed for Internet where network latency is unavoidable.

## Open data service

For example, you are the most detailed Bitcoin OHLC data maintainer. You can directly expose an online SQL interface to your customers to meet a wide range of query needs.

1. CQL can limit specific SQL query statements to meet the needs while also balancing data security;
2. CQL can record SQL query records on the blockchain, which is very convenient for customers to check their bills for long-tail customers and billing, like [this](https://explorer.dbhub.org/dbs/7a51191ae06afa22595b3904dc558d41057a279393b22650a95a3fc610e1e2df/requests/f466f7bf89d4dd1ece7849ef3cbe5c619c2e6e793c65b31966dbe4c7db0bb072)
3. For customers with high performance requirements, Slave nodes can be deployed at the customer to meet the needs of customers with low latency queries while enabling almost real-time data updates.

## Secure storage

Thanks to the CQL data history is immutable, CQL can be used as a storage for sensitive operational logs to prevent hacking and erasure access logs.