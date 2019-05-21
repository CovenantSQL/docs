---
id: driver_java
title: 📦 Java
---

## 用 Java 访问 CovenantSQL

`CovenantSQL` 提供了 `Java SDK`，可通过 `Adapter` 工具转换协议访问数据库实例。

`Java SDK` 遵守 `Java` 标准的 `JDBC4` 接口定义，能够使用常见的 `ORM` 例如 `MyBatis` 进行使用。

### 兼容性

`Java SDK` 目前只兼容 `Java 1.7+` 的 `JDK` 版本。

### 安装和使用

使用 `Java SDK` 需要 [部署 Adapter 工具](./adapter)。

然后通过 `jdbc:covenantsql://<adapter_endpoint>/<database_id>` URI，将其中的 `adapter_endpoint` 替换为 adapter 的地址，`database_id` 替换为数据库的 DSN 串中的数据库 ID 访问数据库实例。

#### Maven

```xml
<repositories>
    <repository>
        <id>mvn-repo</id>
        <url>https://raw.github.com/CovenantSQL/cql-java-driver/mvn-repo</url>
        <releases>
            <enabled>true</enabled>
        </releases>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
    </repository>
</repositories>
```

```xml
<dependencies>
    <dependency>
        <groupId>io.covenantsql</groupId>
        <artifactId>covenantsql-java-connector</artifactId>
        <version>1.0-SNAPSHOT</version>
    </dependency>
</dependencies>
```

#### Gradle

```gradle
repositories {
    maven {
      url 'https://raw.github.com/CovenantSQL/cql-java-driver/mvn-repo'
    }
}

dependencies {
  compile 'io.covenantsql:covenantsql-java-connector:1.0-SNAPSHOT'
}
```

### 示例

1. [JDBC示例](https://github.com/CovenantSQL/cql-java-driver/blob/master/example/src/main/java/io/covenantsql/connector/example/jdbc/Example.java)
2. [MyBatis示例](https://github.com/CovenantSQL/cql-java-driver/blob/master/example/src/main/java/io/covenantsql/connector/example/mybatis/Example.java)
3. [大型项目示例](https://github.com/CovenantSQL/covenantsql-mybatis-spring-boot-jpetstore)
