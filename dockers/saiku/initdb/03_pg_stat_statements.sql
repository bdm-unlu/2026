CREATE EXTENSION IF NOT EXISTS pg_stat_statements SCHEMA public;

COMMENT ON EXTENSION pg_stat_statements IS
    'Para ver el SQL que el motor OLAP genera a partir de cada MDX';
