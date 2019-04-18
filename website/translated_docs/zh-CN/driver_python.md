---
id: driver_python
title: Python
---
## Use Python to access CovenantSQL

Developers could use [PyCovenantSQL](https://github.com/CovenantSQL/python-driver) to access CovenantSQL through [Adapter](./adapter).

### Compatibility

`Python SDK` requires `Python 3.4+`.

### Installation and quick start

Before using `Python SDK`, an adapter deployment is required, please see [Deploy Adapter Service](./adapter).

Install `PyCovenantSQL` using pip:

```shell
$ python3 -m pip install PyCovenantSQL 
```

### Example

Replace `adapter_host` with adapter listen host, `adapter_port` with adapter listen port, `dsn` with database dsn.

```python
import pycovenantsql

# Connect to the database
connection = pycovenantsql.connect(host='<adapter_host>',
                             port=<adapter_port>,
                             database='<dsn>'
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