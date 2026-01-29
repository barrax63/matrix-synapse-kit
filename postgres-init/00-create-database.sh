#!/bin/bash
set -e

# Create the synapse database with explicit collation settings
# Using template0 as recommended by Synapse documentation to ensure
# the database has the correct LC_COLLATE and LC_CTYPE settings
# Reference: https://element-hq.github.io/synapse/latest/postgres.html

# Check if database already exists
if psql -U "$POSTGRES_USER" -lqt | cut -d \| -f 1 | grep -qw "$POSTGRES_DB"; then
    echo "Database '$POSTGRES_DB' already exists"
    
    # Check if it was created with the correct template and collation
    DB_COLLATE=$(psql -U "$POSTGRES_USER" -d postgres -tAc "SELECT datcollate FROM pg_database WHERE datname='$POSTGRES_DB';")
    
    if [ "$DB_COLLATE" != "C" ]; then
        echo "WARNING: Database has incorrect collation '$DB_COLLATE' (should be 'C')"
        echo "Dropping and recreating database with correct settings..."
        psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d postgres <<-EOSQL
            DROP DATABASE $POSTGRES_DB;
EOSQL
        # Create database with template0
        psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" <<-EOSQL
            CREATE DATABASE $POSTGRES_DB
                ENCODING 'UTF8'
                LC_COLLATE 'C'
                LC_CTYPE 'C'
                TEMPLATE template0
                OWNER $POSTGRES_USER;
EOSQL
        echo "Database '$POSTGRES_DB' recreated successfully with template0 and C locale"
    else
        echo "Database collation is correct (C), skipping recreation"
    fi
else
    echo "Creating database '$POSTGRES_DB' with template0 and C locale"
    psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" <<-EOSQL
        CREATE DATABASE $POSTGRES_DB
            ENCODING 'UTF8'
            LC_COLLATE 'C'
            LC_CTYPE 'C'
            TEMPLATE template0
            OWNER $POSTGRES_USER;
EOSQL
    echo "Database '$POSTGRES_DB' created successfully"
fi
