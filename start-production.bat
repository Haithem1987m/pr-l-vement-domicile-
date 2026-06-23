@echo off
REM =====================================================
REM 🚀 Batch script to start Maaref Haithem on Windows
REM =====================================================

echo ==========================================
echo   🚀 Maaref Haithem - Production Startup
echo ==========================================

REM Check Node.js
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js is not installed. Please install Node.js v18+
    exit /b 1
)
echo ✅ Node.js
node -v

REM Check DATABASE_URL
if "%DATABASE_URL%"=="" (
    if exist .env (
        echo 📝 Loading from .env file...
    ) else (
        echo ❌ DATABASE_URL is not set
        echo    Create a .env file or set the variable:
        echo    set DATABASE_URL=postgresql://...
        exit /b 1
    )
)

echo ✅ DATABASE_URL found

REM Install packages
echo 📦 Installing packages...
call npm install

REM Build
echo 🔨 Building...
call npm run build

REM Push schema
echo 🗄️  Applying database schema...
call npx drizzle-kit push --force

echo.
echo ==========================================
echo   ✅ App is ready!
echo   🌐 http://localhost:3000
echo   🔐 /admin/login (admin / admin123456)
echo ==========================================
echo.

call npm start
