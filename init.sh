#!/bin/bash

set -e  
set -o pipefail


ENV_FILE=".env"

cd /var/www/html || exit 1


echo "⏳ Menunggu koneksi ke database..."
until php artisan migrate:status > /dev/null 2>&1; do
  >&2 echo "🕐 Plaese exec php artisan migrate and seed (optional)"
  sleep 10
done

chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# Pastikan file .env ada
if [ ! -f "$ENV_FILE" ]; then
  echo "❌ File .env tidak ditemukan!"
  exit 1
fi

# Ambil nilai APP_KEY dari .env
APP_KEY=$(grep '^APP_KEY=' "$ENV_FILE" | cut -d '=' -f2-)

# Cek apakah APP_KEY kosong atau hanya "APP_KEY="
if [ -z "$APP_KEY" ]; then
  echo "🔑 APP_KEY kosong, menjalankan php artisan key:generate..."
  php artisan key:generate
else
  echo "✅ APP_KEY sudah ada, skip generate."
fi

php artisan config:clear 
php artisan config:cache
php artisan route:cache
php artisan view:cache

exec php-fpm

