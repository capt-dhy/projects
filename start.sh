#!/bin/bash
set -e   # Stop immediately if any command fails

# ---------------------------------------------
# 1️⃣ Install dependencies
# ---------------------------------------------
composer install --no-dev --optimize-autoloader

# ---------------------------------------------
# 2️⃣ Generate app key if missing
# ---------------------------------------------
php artisan key:generate --force

# ---------------------------------------------
# 3️⃣ Clear cached config and cache
# ---------------------------------------------
php artisan config:clear
php artisan cache:clear

# ---------------------------------------------
# 4️⃣ Wait for Railway DB to be ready
# ---------------------------------------------
echo "Waiting for DB to be ready..."
until php -r "new PDO('mysql:host='.getenv('DB_HOST').';port='.getenv('DB_PORT').';dbname='.getenv('DB_DATABASE'), getenv('DB_USERNAME'), getenv('DB_PASSWORD'));" 2>/dev/null; do
  echo "DB not ready yet... sleeping 2s"
  sleep 2
done
echo "DB is ready! ✅"

# ---------------------------------------------
# 5️⃣ Run migrations (force to skip prompts)
# ---------------------------------------------
php artisan migrate --force

# ---------------------------------------------
# 6️⃣ Optional: Seed database (if needed)
# ---------------------------------------------
# php artisan db:seed --force

# ---------------------------------------------
# 7️⃣ Start Laravel server
# ---------------------------------------------
echo "Starting Laravel server..."
php -S 0.0.0.0:$PORT -t public
