---
id: version-0.5.0-qna
title: Q&A
original_id: qna
---

## Frequently Asked

- **Q:** What level of consistency does the CQL database support and how is the CQL database created?

  **A:** See [Consensus Algorithm](./arch#consensus-algorithm)

- **Q:** How is CQL database security done?

  **A:** Unlike traditional databases, CQL is a distributed database system that runs on the open Internet. In terms of security, CQL mainly does the following work:

  1. Key Management: CQL uses public and private key pairs generated by Bitcoin's `scep256k1` asymmetric encryption curve.

  2. Network communication: see [RPC Framework](./arch_network)。

  3. Database Permissions & Encryption:

     1. [Secure Gateway](./advanced_secure_gateway)

     2. Support of SQL encryption functions `encrypt`, `decrypt`, for example:

        ```sql
        INSERT INTO "t1" ("k", "v") VALUES (1, encrypt("data", "pass", "salt"));
        SELECT decrypt("v", "pass", "salt") FROM "t1" WHERE "k"=1;
        ```

- **Q:** If CQL data is Immutable, how do CQL deal with the need for data deletion in GDPR?

  **A:** CQL supports two development modes, one is the traditional `DB per App`, and the other is the `DB per User` which is biased towards privacy.

  The development mode of `DB per User` is very suitable for the development of applications such as "Password Manager" and "Personal Information Management". Since users manage their personal data through a CQL private key which is quite like using Bitcoin a private key to manage their own property. App developed in this model naturally does not store any user data, and technically conforms to the following Stringent requirements of laws and regulations:

  - [EU GDPR（General Data Protection Regulation）](https://gdpr-info.eu/)
  - [CCPA（California_Consumer_Privacy_Act）](https://en.wikipedia.org/wiki/California_Consumer_Privacy_Act)
  - [HIPAA（Health Insurance Portability and Accountability Act of 1996）](https://en.wikipedia.org/wiki/Health_Insurance_Portability_and_Accountability_Act)
  - [HongKong Personal Data (Privacy) Ordinance](https://www.elegislation.gov.hk/hk/cap486)

  The complete data of CQL is stored on Miner of SQLChain. The data related SQL history is completely saved on Miner. Compared to the traditional database `CRUD` (Create, Read, Update, Delete), CQL supports `CRAP` (Create, Read, Append, Privatize).

  > **Append** vs **Update**
  >
  > After the traditional database changes the data (Update), there is no history, in other words, the data can be tampered with. CQL supports the Append of data, and the result is that the history of the data is preserved.

  > **Privatize** vs **Delete**
  >
  > The traditional database deletes the data (Delete), which is irreversible and irreversible. CQL supports Privatization of data, that is, transferring the permissions of the database to an impossible public key. This allows substantial deletion of sub-chain data. Deletion of all traces on the chain for a single piece of data is currently only supported in the Enterprise Edition.

- **Q:** How does CQL store data for a database?

  **A:** Most of the operation of the user database is done on SQLChain. By default, the MainChain only saves the block hash of the SQLChain. For more details, please refer to [MainChain & SQLChain](./arch_layers#mainchain-sqlchain)。

- **Q:** What is the maximum amount of data supported by CQL?

  **A:** CQL's database data is stored on a separate SQLChain. The number of CQL databases depends on the number of Miners across the network. The upper limit of a single CQL database depends on the hardware performance. As of 2019-04-25, the largest table online of TestNet is a 2 Miner database running continuously on a AWS c5.2xlarge standard configuration with 433,211,000 rows of data and 3.2 TB of disk.

  