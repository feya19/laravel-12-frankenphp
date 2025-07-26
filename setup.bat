@echo off
echo ====================================
echo Laravel Docker Project Setup
echo ====================================
echo.

:: Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

:: Check if make is installed
where make >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Make is not installed. Please install make first.
    echo You can install it via Chocolatey: choco install make
    pause
    exit /b 1
)

:: Check if .env exists, if not copy from .env.docker.example
if not exist .env (
    echo [INFO] Creating .env file from .env.docker.example
    copy .env.docker.example .env
) else (
    echo [INFO] .env file already exists
)

echo [INFO] Starting development setup...
echo.

:: Run the development setup
make dev-setup

if %errorlevel% equ 0 (
    echo.
    echo ====================================
    echo Setup completed successfully!
    echo ====================================
    echo.
    echo Your Laravel application is now running at:
    echo http://localhost
    echo.
    echo Useful commands:
    echo   make help           - Show all available commands
    echo   make logs-app       - View application logs
    echo   make shell          - Access container shell
    echo   make artisan cmd="migrate" - Run artisan commands
    echo.
    echo To stop the application: make down
    echo ====================================
) else (
    echo.
    echo [ERROR] Setup failed. Please check the errors above.
)

pause
