-- PGTune parameters
-- DB Version: 16
-- OS Type: linux
-- DB Type: oltp
-- Total Memory (RAM): 4 GB
-- CPUs num: 2
-- Data Storage: ssd

-- Note: The synapse database is automatically created by the postgres image
-- using the POSTGRES_DB environment variable. The docker-compose.yml 
-- POSTGRES_INITDB_ARGS ensures the entire cluster uses LC_COLLATE=C and LC_CTYPE=C.
-- This script runs after database creation to set performance parameters.

ALTER SYSTEM SET
 max_connections = '300';
ALTER SYSTEM SET
 shared_buffers = '1GB';
ALTER SYSTEM SET
 effective_cache_size = '3GB';
ALTER SYSTEM SET
 maintenance_work_mem = '256MB';
ALTER SYSTEM SET
 checkpoint_completion_target = '0.9';
ALTER SYSTEM SET
 wal_buffers = '16MB';
ALTER SYSTEM SET
 default_statistics_target = '100';
ALTER SYSTEM SET
 random_page_cost = '1.1';
ALTER SYSTEM SET
 effective_io_concurrency = '200';
ALTER SYSTEM SET
 work_mem = '3404kB';
ALTER SYSTEM SET
 huge_pages = 'off';
ALTER SYSTEM SET
 min_wal_size = '2GB';
ALTER SYSTEM SET
 max_wal_size = '8GB';
