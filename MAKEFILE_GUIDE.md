# Makefile Usage Guide

Makefile ini menyediakan perintah-perintah yang mudah digunakan untuk mengelola project Laravel dengan Docker.

## Prerequisites

Pastikan Anda telah menginstall:
- Docker & Docker Compose
- Make (untuk Windows, bisa install melalui chocolatey: `choco install make`)
- Node.js & NPM

## Quick Start

```bash
# Lihat semua perintah yang tersedia
make help

# Setup lengkap untuk development
make dev-setup

# Atau step-by-step:
make build          # Build Docker containers
make up             # Start services
make composer-install
make key-generate
make migrate-fresh
make npm-install
```

## Perintah Utama

### Docker Management
- `make build` - Build Docker containers
- `make up` - Start semua services
- `make down` - Stop semua services
- `make restart` - Restart semua services
- `make logs` - Show logs dari semua services

### Development
- `make shell` - Masuk ke container app
- `make artisan cmd="migrate"` - Jalankan artisan command
- `make tinker` - Buka Laravel Tinker

### Database
- `make migrate` - Jalankan migrations
- `make seed` - Jalankan seeders
- `make fresh` - Fresh migration + seeding
- `make migrate-rollback` - Rollback migrations

### Testing
- `make test` - Jalankan PHPUnit tests
- `make test-coverage` - Test dengan coverage
- `make pint` - Code formatting dengan Laravel Pint

### Assets
- `make npm-install` - Install dependencies Node.js
- `make npm-dev` - Build assets untuk development
- `make npm-build` - Build assets untuk production

### Cache Management
- `make cache-clear` - Clear semua cache
- `make cache-optimize` - Optimize cache untuk production

### Laravel Generators
- `make make-controller name="UserController"` - Buat controller
- `make make-model name="User"` - Buat model
- `make make-migration name="create_users_table"` - Buat migration
- `make make-seeder name="UserSeeder"` - Buat seeder

### Maintenance
- `make clean` - Cleanup containers dan volumes
- `make permissions` - Fix storage permissions
- `make backup-db` - Backup database

## Contoh Workflow Development

```bash
# 1. Setup project pertama kali
make dev-setup

# 2. Development sehari-hari
make up                           # Start services
make logs-app                     # Monitor app logs
make artisan cmd="migrate"        # Run migrations
make test                         # Run tests

# 3. Buat fitur baru
make make-controller name="PostController"
make make-model name="Post"
make make-migration name="create_posts_table"

# 4. Cleanup saat selesai
make down
```

## Environment Variables

Pastikan file `.env` sudah dikonfigurasi dengan benar, terutama:
- `DB_DATABASE`
- `DB_USERNAME` 
- `DB_PASSWORD`

## Troubleshooting

Jika ada masalah:
1. `make down && make clean` - Reset containers
2. `make build` - Rebuild containers
3. `make permissions` - Fix permissions
4. `make health` - Check status services
