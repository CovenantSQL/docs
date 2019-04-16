---
id: version-0.5.0-driver_python
title: 📦 Python
original_id: driver_python
---

## 用 Python 使用 CovenantSQL

开发者可以通过 [PyCovenantSQL](https://github.com/CovenantSQL/python-driver) 来使用 CovenantSQL。

### 兼容性

`Python SDK` 目前只兼容 `python 3.4+`

### 安装和使用

使用 `Python SDK` 需要 [部署 Adapter 工具](./adapter)。

使用 pip 安装 PyCovenantSQL

```shell
$ python3 -m pip install PyCovenantSQL 
```

### 示例

将 `adapter_host` 替换为 adapter 地址，`adapter_port` 替换为 adapter 的端口，adapter


```python
import pycovenantsql

# Connect to the database
connection = pycovenantsql.connect(host='<adapter_host>',
                             port=<adapter_port>,
                             database='<database_id>'
                             )

try:
    with connection.cursor() as cursor:
        # Create a new record
        sql = "INSERT INTO `users` (`email`, `password`) VALUES (%s, %s)"
        cursor.execute(sql, ('webmaster@python.org', 'very-secret'))

    # connection is autocommit. No need to commit in any case.
    # connection.commit()

    with connection.cursor() as cursor:
        # Read a single record
        sql = "SELECT `id`, `password` FROM `users` WHERE `email`=%s"
        cursor.execute(sql, ('webmaster@python.org',))
        result = cursor.fetchone()
        print(result)
finally:
    connection.close()
```