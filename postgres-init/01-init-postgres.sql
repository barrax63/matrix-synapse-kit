-- PGTune parameters
-- DB Version: 16
-- OS Type: linux
-- DB Type: oltp
-- Total Memory (RAM): 4 GB
-- CPUs num: 2
-- Data Storage: ssd

-- Create the synapse database with explicit collation settings
-- Using template0 as recommended by Synapse documentation to ensure
-- the database has the correct LC_COLLATE and LC_CTYPE settings
-- Reference: https://element-hq.github.io/synapse/latest/postgres.html
CREATE DATABASE synapse
    ENCODING 'UTF8'
    LC_COLLATE 'C'
    LC_CTYPE 'C'
    TEMPLATE template0
    OWNER synapse;

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
