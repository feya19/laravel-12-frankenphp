.PHONY: help build up down restart logs shell artisan test migrate seed fresh install composer-install npm-install clean

# Default target
help: ## Show this help message
	@echo "Laravel Project Makefile Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Docker Commands
build: ## Build Docker containers
	docker-compose build

up: ## Start all services
	docker-compose up -d

down: ## Stop all services
	docker-compose down

restart: ## Restart all services
	docker-compose restart

logs: ## Show logs from all services
	docker-compose logs -f

logs-app: ## Show logs from app service only
	docker-compose logs -f app

# Development Commands
shell: ## Access app container shell
	docker-compose exec app bash

artisan: ## Run artisan command (usage: make artisan cmd="migrate")
	docker-compose exec app php artisan $(cmd)

tinker: ## Open Laravel Tinker
	docker-compose exec app php artisan tinker

queue-work: ## Start queue worker
	docker-compose exec app php artisan queue:work

# Database Commands
migrate: ## Run database migrations
	docker-compose exec app php artisan migrate

migrate-rollback: ## Rollback database migrations
	docker-compose exec app php artisan migrate:rollback

migrate-fresh: ## Fresh migration (drop all tables and re-migrate)
	docker-compose exec app php artisan migrate:fresh

seed: ## Run database seeders
	docker-compose exec app php artisan db:seed

fresh: ## Fresh migration with seeding
	docker-compose exec app php artisan migrate:fresh --seed

# Testing Commands
test: ## Run PHPUnit tests
	docker-compose exec app php artisan test

test-coverage: ## Run tests with coverage
	docker-compose exec app php artisan test --coverage

pint: ## Run Laravel Pint (code formatting)
	docker-compose exec app ./vendor/bin/pint

# Installation Commands
install: build composer-install npm-install key-generate migrate ## Complete installation setup

composer-install: ## Install PHP dependencies
	docker-compose run --rm app composer install

composer-update: ## Update PHP dependencies
	docker-compose run --rm app composer update

npm-install: ## Install Node.js dependencies
	npm install

npm-build: ## Build assets for production
	npm run build

npm-dev: ## Build assets for development
	npm run dev

key-generate: ## Generate application key
	docker-compose exec app php artisan key:generate

# Cache Commands
cache-clear: ## Clear all caches
	docker-compose exec app php artisan cache:clear
	docker-compose exec app php artisan config:clear
	docker-compose exec app php artisan route:clear
	docker-compose exec app php artisan view:clear

cache-optimize: ## Optimize caches for production
	docker-compose exec app php artisan config:cache
	docker-compose exec app php artisan route:cache
	docker-compose exec app php artisan view:cache

# Maintenance Commands
storage-link: ## Create storage symbolic link
	docker-compose exec app php artisan storage:link

permissions: ## Fix storage and cache permissions
	docker-compose exec app chmod -R 775 storage bootstrap/cache
	docker-compose exec app chown -R www-data:www-data storage bootstrap/cache

# Cleanup Commands
clean: ## Clean up containers and volumes
	docker-compose down -v
	docker system prune -f

clean-all: ## Clean up everything including images
	docker-compose down -v --rmi all
	docker system prune -af

# Quick Development Setup
dev-setup: up composer-install key-generate migrate npm-install ## Quick development environment setup

# Production Commands
prod-build: ## Build for production
	docker-compose -f docker-compose.yml build --no-cache

prod-up: ## Start production environment
	docker-compose -f docker-compose.yml up -d

# Backup Commands
backup-db: ## Backup database
	docker-compose exec mysql mysqldump -u root -p$(DB_PASSWORD) $(DB_DATABASE) > backup_$(shell date +%Y%m%d_%H%M%S).sql

# Health Check
health: ## Check services health
	docker-compose ps
	@echo "\n=== Application Status ==="
	@curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost || echo "Application not responding"

# Laravel Specific Commands
make-controller: ## Create controller (usage: make make-controller name="UserController")
	docker-compose exec app php artisan make:controller $(name)

make-model: ## Create model (usage: make make-model name="User")
	docker-compose exec app php artisan make:model $(name)

make-migration: ## Create migration (usage: make make-migration name="create_users_table")
	docker-compose exec app php artisan make:migration $(name)

make-seeder: ## Create seeder (usage: make make-seeder name="UserSeeder")
	docker-compose exec app php artisan make:seeder $(name)

make-middleware: ## Create middleware (usage: make make-middleware name="Auth")
	docker-compose exec app php artisan make:middleware $(name)

make-request: ## Create form request (usage: make make-request name="UserRequest")
	docker-compose exec app php artisan make:request $(name)

# Monitoring
monitor: ## Monitor logs in real-time
	docker-compose logs -f app mysql redis
