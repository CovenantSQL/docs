---
id: version-0.5.0-driver_java
title: Java
original_id: driver_java
---

## Use Java to access CovenantSQL

`CovenantSQL` provides `Java SDK` to access database instance through [`Adapter`](./adapter) service.

`Java SDK` is compatible with `JDBC4` specifications，and popular `ORM` like `MyBatis` is supported through JDBC interface.

### Compatibility

`Java SDK` requires `Java 1.7+`.

### Installation and quick start

Before using `Java SDK`, an adapter tool deployment is required, please see [Deploy Adapter Service](./adapter).

Now you can use `jdbc:covenantsql://<adapter_endpoint>/<database_id>` uri，replacing `adapter_endpoint` with adapter listen address，`database_id` with database id。

#### Maven

```xml
<repositories>
    <repository>
        <id>mvn-repo</id>
        <url>https://raw.github.com/CovenantSQL/covenant-connector/mvn-repo</url>
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
      url 'https://raw.github.com/CovenantSQL/covenant-connector/mvn-repo'
    }
}

dependencies {
  compile 'io.covenantsql:covenantsql-java-connector:1.0-SNAPSHOT'
}
```

### Examples

1. [JDBC Example](https://github.com/CovenantSQL/covenant-connector/blob/master/covenantsql-java-connector/example/src/main/java/io/covenantsql/connector/example/jdbc/Example.java)
2. [MyBatis Example](https://github.com/CovenantSQL/covenant-connector/blob/master/covenantsql-java-connector/example/src/main/java/io/covenantsql/connector/example/mybatis/Example.java)
3. [SpringBoot + MyBatis Project Example](https://github.com/CovenantSQL/covenantsql-mybatis-spring-boot-jpetstore)
