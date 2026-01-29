# Matrix Synapse Kit

**Matrix Synapse Kit** is an open-source template that quickly sets up a self-hosted Matrix homeserver featuring Synapse with PostgreSQL database and Cloudflare Tunnel integration for secure remote access.

### What's included

✅ [**Matrix Synapse**](https://github.com/element-hq/synapse) - Reference homeserver implementation for the Matrix protocol, enabling decentralized, secure communication

✅ [**PostgreSQL**](https://www.postgresql.org/) - Powerful relational database for reliable message and state storage

✅ [**Cloudflared**](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) - Secure reverse proxy to access your Matrix homeserver from anywhere without exposing ports

### What you can build

⭐️ **Private Communication Server** with end-to-end encrypted messaging

⭐️ **Federated Chat Network** connecting with other Matrix homeservers worldwide

⭐️ **Team Collaboration Platform** with rooms, spaces, and access controls

⭐️ **Bridged Messaging Hub** connecting Matrix to Slack, Discord, Telegram, and more

⭐️ **Self-Hosted Alternative** to commercial chat platforms with full data ownership

## Installation

### Prerequisites

- Docker and Docker Compose installed on your system
- A domain name pointing to your server (required for federation)
- Cloudflare account for tunnel setup

### Running Synapse using Docker Compose

#### Standard Setup

```bash
git clone https://github.com/barrax63/matrix-synapse-kit.git
cd matrix-synapse-kit
cp .env.example .env # Update with your configuration
```

> [!IMPORTANT]
> Make sure to update the following variables in your `.env` file:
> - `POSTGRES_PASSWORD` - Set a strong database password
> - `SYNAPSE_SERVER_NAME` - Your Matrix domain (e.g., `matrix.example.com`)
> - `TZ` - Your timezone (e.g., `Europe/Berlin`, `America/New_York`)

#### First-time Setup (Generate Configuration)

```bash
# Generate and copy initial Synapse configuration
docker compose --profile setup up --exit-code-from synapse-copy synapse-copy

# Edit homeserver.yaml to configure PostgreSQL database
vi homeserver.yaml
```

Update the `database` section in `homeserver.yaml`:

```yaml
database:
  name: psycopg2
  args:
    user: synapse
    password: YOUR_POSTGRES_PASSWORD
    database: synapse
    host: postgres
    cp_min: 5
    cp_max: 10
```

#### Expose Synapse through Cloudflare Tunnel

1. [Create a Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/) and add an HTTP route that points to `http://synapse:8008`.
2. Copy the generated **tunnel token** into your `.env` file as `CLOUDFLARED_TUNNEL_TOKEN`.

#### Start the Stack

```bash
docker compose up -d
```

## First-time Setup

1. **Register Admin User**: Create your first admin user via command line:
   ```bash
   docker exec -it matrix-synapse-1 register_new_matrix_user -c /data/homeserver.yaml http://localhost:8008
   ```
2. **Connect a Client**: Use [Element](https://element.io/), [FluffyChat](https://fluffychat.im/), or any Matrix client
3. **Configure Federation**: Set up `.well-known` files or SRV records for federation with other servers
4. **Enable Features**: Configure push notifications, media storage, and bridges as needed

### How to use

More information on how to use this stack can be found in the [**Usage**](USAGE.md) file.

## Containers and access

The kit consists of multiple containers with restricted access for enhanced security.
For more information on how to access the services, please refer to the table below.

| Container      | Version     | Hostname    | Port | Network accessible?             |
|----------------|-------------|-------------|------|---------------------------------|
| `synapse`      | `latest`    | synapse     | 8008 | From host (without cloudflared) |
| `postgres`     | `16-alpine` | postgres    | 5432 | From Docker network only        |
| `cloudflared`  | `latest`    | cloudflared | -/-  | -/-                             |

## Upgrading

### Update all containers to latest versions

```bash
git pull
docker compose pull
docker compose up -d
```

This will:
- Pull the latest code changes
- Download the latest container images
- Recreate containers with new versions
- Preserve all your data in volumes

### Enable auto-updates

You can enable automatic updates by adding a cron job. Run:

```bash
crontab -u <USER> -e
```

Add this entry:

```bash
# Every Sunday at 00:00 run git pull and compose up with latest images
0 0 * * 0 cd /home/<USER>/matrix-synapse-kit && /usr/bin/git pull && /usr/bin/docker compose pull && /usr/bin/docker compose up -d >> /home/<USER>/matrix-synapse-kit/cron.log 2>&1
```

## Recommended reading

Matrix Synapse offers extensive documentation and guides for getting the most out of your homeserver.

### Official Documentation

- [Synapse Documentation](https://element-hq.github.io/synapse/latest/)
- [Matrix Specification](https://spec.matrix.org/)
- [Installation Guide](https://element-hq.github.io/synapse/latest/setup/installation.html)
- [Admin API Documentation](https://element-hq.github.io/synapse/latest/usage/administration/admin_api/)

### Key Features

- **Federation**: Connect with other Matrix homeservers for decentralized communication
- **End-to-End Encryption**: Secure messaging with Megolm/Olm encryption
- **Rooms & Spaces**: Organize conversations with hierarchical spaces
- **Bridges**: Connect to other platforms (Slack, Discord, Telegram, IRC, etc.)
- **SSO Integration**: SAML, OIDC, and CAS authentication support
- **User Management**: Admin API for user provisioning and management

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.

## Acknowledgments

- [Matrix Synapse](https://github.com/element-hq/synapse) - The reference Matrix homeserver implementation
- [Element](https://element.io/) - The team maintaining Synapse
- [Cloudflare](https://www.cloudflare.com/) - Secure tunnel infrastructure
