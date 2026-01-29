# Tips & tricks

### Accessing PostgreSQL Database

The PostgreSQL database is only accessible from within the Docker network for security. To access it:

```bash
# Connect to the database from the host
docker exec -it matrix-postgres-1 psql -U synapse -d synapse

# Or use a database client connecting to localhost:5432 (if you expose the port)
```

### Creating Users

```bash
# Interactive user registration
docker exec -it matrix-synapse-1 register_new_matrix_user -c /data/homeserver.yaml http://localhost:8008

# Non-interactive (scripted)
docker exec -it matrix-synapse-1 register_new_matrix_user -u username -p password -a -c /data/homeserver.yaml http://localhost:8008
```

### Backup and Restore

#### Backup Database

```bash
docker exec matrix-postgres-1 pg_dump -U synapse synapse > backup.sql
```

#### Restore Database

```bash
cat backup.sql | docker exec -i matrix-postgres-1 psql -U synapse -d synapse
```

#### Backup Volumes

```bash
docker run --rm -v matrix_synapse_storage:/data -v $(pwd):/backup ubuntu tar czf /backup/synapse-backup.tar.gz /data
docker run --rm -v matrix_postgres_storage:/data -v $(pwd):/backup ubuntu tar czf /backup/postgres-backup.tar.gz /data
```

### Monitoring and Logs

```bash
# View logs for all services
docker compose logs -f

# View logs for specific service
docker compose logs -f synapse
docker compose logs -f postgres

# Check container health status
docker compose ps
```

### Troubleshooting

#### Synapse won't start

```bash
# Check logs
docker compose logs synapse

# Verify database is healthy
docker compose ps postgres

# Validate homeserver.yaml syntax
docker exec matrix-synapse-1 python -c "import yaml; yaml.safe_load(open('/data/homeserver.yaml'))"

# Restart services
docker compose restart
```

#### Database connection issues

```bash
# Check database health
docker exec matrix-postgres-1 pg_isready -U synapse -d synapse

# Verify environment variables
docker compose config

# Check database collation (should be 'C' for Synapse)
docker exec matrix-postgres-1 psql -U synapse -d synapse -c "SELECT datcollate FROM pg_database WHERE datname='synapse';"
```

**Note**: If you're migrating from an existing PostgreSQL setup with incorrect collation, you'll need to recreate the database:
1. Backup your data: `docker exec matrix-postgres-1 pg_dump -U synapse synapse > backup.sql`
2. Stop containers: `docker compose down`
3. Remove the postgres volume: `docker volume rm matrix_postgres_storage`
4. Start fresh: `docker compose up -d`
5. Restore data if needed (after fixing collation issues in the dump)

#### Federation issues

```bash
# Test federation using the Matrix Federation Tester
# Visit: https://federationtester.matrix.org/

# Check Synapse federation logs
docker compose logs synapse | grep -i federation
```

#### Cloudflare tunnel not working

```bash
# Check cloudflared logs
docker compose logs cloudflared

# Verify tunnel token is set correctly
docker compose config | grep CLOUDFLARED_TUNNEL_TOKEN
```
