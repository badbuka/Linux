#### mysql all databases size in mb 

``` SELECT table_schema AS "Database", 
ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)" 
FROM information_schema.TABLES 
GROUP BY table_schema; 
```

#### mysql all databases size in gb

```SELECT table_schema AS "Database", 
ROUND(SUM(data_length + index_length) / 1024 / 1024 / 1024, 2) AS "Size (GB)" 
FROM information_schema.TABLES 
GROUP BY table_schema;
```

#### Sizes of all of the tables in a specific database/  Replace database_name with the name of the database that you want to check:

```SELECT table_name AS "Table",
ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)"
FROM information_schema.TABLES
WHERE table_schema = "database_name"
ORDER BY (data_length + index_length) DESC;
```

#### Below is the Query to find all the tables which have MyISAM Engine

```
SELECT TABLE_SCHEMA as DbName ,TABLE_NAME as TableName ,ENGINE as Engine FROM information_schema.TABLES WHERE ENGINE='MyISAM' AND TABLE_SCHEMA NOT IN('mysql','information_schema','performance_schema');
```

#### For how to convert your existing MyISAM tables to InnoDB Below is the Query that will Return ALTER Statements to convert existing MyISAM Tables to InnoDB.

```
SELECT CONCAT('ALTER TABLE `', TABLE_SCHEMA,'`.`',TABLE_NAME, '` ENGINE = InnoDB;') FROM information_schema.TABLES WHERE ENGINE='MyISAM' AND TABLE_SCHEMA NOT IN('mysql','information_schema','performance_schema');
```
