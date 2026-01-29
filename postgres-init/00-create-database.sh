#!/bin/bash
set -e

# Create the synapse database with explicit collation settings
# Using template0 as recommended by Synapse documentation to ensure
# the database has the correct LC_COLLATE and LC_CTYPE settings
# Reference: https://element-hq.github.io/synapse/latest/postgres.html

# Check if database already exists
if psql -U "$POSTGRES_USER" -lqt | cut -d \| -f 1 | grep -qw "$POSTGRES_DB"; then
    echo "Database already exists, skipping creation"
else
    echo "Creating database with template0 and C locale"
    psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" <<-EOSQL
        CREATE DATABASE $POSTGRES_DB
            ENCODING 'UTF8'
            LC_COLLATE 'C'
            LC_CTYPE 'C'
            TEMPLATE template0
            OWNER $POSTGRES_USER;
EOSQL
    echo "Database created successfully"
fi
