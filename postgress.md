# PSQL

### Magic words:
```
psql -U postgres
```
### Some interesting flags (to see all, use -h or --help depending on your psql version):
```
    -E: will describe the underlaying queries of the \ commands (cool for learning!)
    -l: psql will list all databases and then exit (useful if the user you connect with doesn't has a default database, like at AWS RDS)
```
### Most \d commands support additional param of __schema__.name__ and accept wildcards like *.*
```
    \q: Quit/Exit
    \c __database__: Connect to a database
    \d __table__: Show table definition including triggers
    \d+ __table__: More detailed table definition including description and physical disk size
    \l: List databases
    \dy: List events
    \df: List functions
    \di: List indexes
    \dn: List schemas
    \dt *.*: List tables from all schemas (if *.* is omitted will only show SEARCH_PATH ones)
    \dT+: List all data types
    \dv: List views
    \df+ __function__ : Show function SQL code.
    \x: Pretty-format query results instead of the not-so-useful ASCII tables
    \copy (SELECT * FROM __table_name__) TO 'file_path_and_name.csv' WITH CSV: Export a table as CSV
```
### User Related:
```
    \du: List users
    \du __username__: List a username if present.
    create role __test1__: Create a role with an existing username.
    create role __test2__ noinherit login password __passsword__;: Create a role with username and password.
    set role __test__;: Change role for current session to __test__.
    grant __test2__ to __test1__;: Allow __test1__ to set its role as __test2__.
    \ddu: display default privileges
```
Command to alter default privileges
```
ALTER DEFAULT PRIVILEGES IN SCHEMA public FOR ROLE username GRANT SELECT ON SEQUENCES TO another_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public FOR ROLE username GRANT SELECT ON TABLES TO another_user;
```
## Configuration
### Recofigure
```
psql -U postgres -c "SELECT pg_reload_conf();"
```

###    Service management commands:
```
sudo service postgresql stop
sudo service postgresql start
sudo service postgresql restart
```
###    Changing verbosity & querying Postgres log:
    1) First edit the config file, set a decent verbosity, save and restart postgres:
```
sudo vim /etc/postgresql/9.3/main/postgresql.conf

# Uncomment/Change inside:
log_min_messages = debug5
log_min_error_statement = debug5
log_min_duration_statement = -1

sudo service postgresql restart
```
    Now you will get tons of details of every statement, error, and even background tasks like VACUUMs
```
tail -f /var/log/postgresql/postgresql-9.3-main.log
```
###    How to add user who executed a PG statement to log (editing postgresql.conf):
```
log_line_prefix = '%t %u %d %a '
```
### Create command

There are many CREATE choices, like CREATE DATABASE __database_name__, CREATE TABLE __table_name__ ... Parameters differ but can be checked at the official documentation.
#### Handy queries
```
    SELECT * FROM pg_proc WHERE proname='__procedurename__': List procedure/function
```
```
    SELECT * FROM pg_views WHERE viewname='__viewname__';: List view (including the definition)
```
```
    SELECT pg_size_pretty(pg_total_relation_size('__table_name__'));: Show DB table space in use
```
```
    SELECT pg_size_pretty(pg_database_size('__database_name__'));: Show DB space in use
```
```
    show statement_timeout;: Show current user's statement timeout
```
```
    SELECT * FROM pg_indexes WHERE tablename='__table_name__' AND schemaname='__schema_name__';: Show table indexes
```

Get all indexes from all tables of a schema:
```
SELECT
   t.relname AS table_name,
   i.relname AS index_name,
   a.attname AS column_name
FROM
   pg_class t,
   pg_class i,
   pg_index ix,
   pg_attribute a,
    pg_namespace n
WHERE
   t.oid = ix.indrelid
   AND i.oid = ix.indexrelid
   AND a.attrelid = t.oid
   AND a.attnum = ANY(ix.indkey)
   AND t.relnamespace = n.oid
    AND n.nspname = 'kartones'
ORDER BY
   t.relname,
   i.relname
```
   Execution data:
        Queries being executed at a certain DB:
```
SELECT datname, application_name, pid, backend_start, query_start, state_change, state, query 
  FROM pg_stat_activity 
  WHERE datname='__database_name__';
```
   Get all queries from all dbs waiting for data (might be hung):
```
SELECT * FROM pg_stat_activity WHERE waiting='t'
```
   Currently running queries with process pid:
```
SELECT pg_stat_get_backend_pid(s.backendid) AS procpid, 
  pg_stat_get_backend_activity(s.backendid) AS current_query
FROM (SELECT pg_stat_get_backend_idset() AS backendid) AS s;
```
 Casting:
```
    CAST (column AS type) or column::type
    '__table_name__'::regclass::oid: Get oid having a table name
```
Query analysis:
```
    EXPLAIN __query__: see the query plan for the given query
    EXPLAIN ANALYZE __query__: see and execute the query plan for the given query
    ANALYZE [__table__]: collect statistics
```
Generating random data (source):
```
    INSERT INTO some_table (a_float_value) SELECT random() * 100000 FROM generate_series(1, 1000000) i;
```
### Keyboard shortcuts
```
    CTRL + R: reverse-i-search
```
### Tools

   ptop and pg_top: top for PG. Available on the APT repository from apt.postgresql.org.
   pg_activity: Command line tool for PostgreSQL server activity monitoring.
   Unix-like reverse search in psql:
```
$ echo "bind "^R" em-inc-search-prev" > $HOME/.editrc
$ source $HOME/.editrc
```
